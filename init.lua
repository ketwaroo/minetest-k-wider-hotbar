-- k_wider_hotbar

k_wider_hotbar = {
    -- predefined data on inventory grids.
    -- not ideal. would prefer autodetection.
    inv_sizes = {
        default = {
            -- total initial hotbar width can be calculated from inv width
            cell = 78,
            border = 4,
        },
        mcl = {
            cell = 22,
            border = 2,
        },
    },
    -- deterimine hotbar size from various sources.
    -- @return number
    determine_hotbar_rows = function(player)
        -- @todo, store param in user meta.
        return math.floor(tonumber(minetest.settings:get("k_wider_hotbar.number_of_rows") or 1))
    end,
}

minetest.register_on_joinplayer(function(player)

    local mult = k_wider_hotbar.determine_hotbar_rows(player)

    -- not applicable for single row hotbar
    if mult == 1 then
        return
    end

    local setup = function(playerName, multiplier)
        -- ref doesn't work? need refretch
        local player = minetest.get_player_by_name(playerName)
        local inv = player:get_inventory()

        -- sanitise multiplier.
        -- problem with hud_set_hotbar_itemcount is that number of items, must be between 1 and 32
        -- https://api.minetest.net/class-reference/#player-only-no-op-for-other-objects
        -- for mineclonia, we'd be missing 4 items out of 36.
        -- instead limit to minimum whole multiple of minWidth, which amounts to 27
        local minWidth = math.max(8, inv:get_width("main"))
        local maxWidth = math.min(32, inv:get_size("main"))
        local maxMult = math.floor(maxWidth / minWidth)

        multiplier = math.max(math.min(multiplier, maxMult), 1)

        local cellDim = k_wider_hotbar.inv_sizes.default.cell
        local cellBorder = k_wider_hotbar.inv_sizes.default.border

        -- should work on miclonia/mineclone2
        if minetest.get_modpath("mcl_inventory") then
            cellDim = k_wider_hotbar.inv_sizes.mcl.cell
            cellBorder = k_wider_hotbar.inv_sizes.mcl.border
        end

        -- reuse same hotbar bg but multiply it.
        -- @todo may be some way to get hotbarBgWidth from currentBg
        local currentBg = player:hud_get_hotbar_image()
        -- initial hotbar - one border is always one row. or one assumes..
        local hotbarBgWidth = (minWidth * (cellDim - cellBorder))
        -- build stitch
        local stitch = string.format("[combine:%dx%d", (hotbarBgWidth * multiplier) + cellBorder, cellDim)
        for i = 1, multiplier, 1 do
            stitch = stitch .. string.format(":%d,0=%s", (i - 1) * hotbarBgWidth, currentBg)
        end

        --set hotbar size
        player:hud_set_hotbar_itemcount(minWidth * multiplier)
        player:hud_set_hotbar_image(stitch)
    end

    -- add a delay so it's sort of the last thing
    minetest.after(0.33, setup, player:get_player_name(), mult)
end)
