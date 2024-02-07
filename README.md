K Wider Hotbar
==============

# What this does

It increases the size of the hotbar, that row of item displayed at the bottom of your HUD for items you can switch to.

This mod attempts to be a little more compatible with [Mineclonia](https://content.minetest.net/packages/ryvnf/mineclonia/) and tries to reuse the same textures. Should be compatible with mineclone2 but is untested.

# Usage/Features

Instead of specifying an arbitrary number of slots, you will need to specify the number of rows of inventory to display. In other words, a multiple of the inventory width.

Typically, the hotbar is equal to the the first row of your inventory.

See `k_wider_hotbar.number_of_rows` in game settings.

The reason for using multiples of the inventory width is mostly aesthetics - to be able to reuse the same UI textures as the game this mod is running on. It's easier (just a little bit) to stitch multiples of the same row along the edge than try to overlap cells nicely.

# Limitations

There is an engine limitation where maximum number of hotbar slots is 32. This may eventually be addressed by https://github.com/minetest/minetest/pull/14321

`default` game will have 32 inventory slots with hotbar = 8 slots. So max number of rows you can display here is 4

`mineclonia` and other minecraft clones will have 36 inventory slots with hotbar = 9 slots. But since trying to display everything would exceed the limit of 32, we only display 3 rows or 27 items, meaning you'll still one last inaccessible row.

Can get weird on lower resolutions as minetest will try to stack your hotbar into 2 rows, and may not work well on mobile.

# License

Everything [GPL 3.0 or Later](https://spdx.org/licenses/GPL-3.0-or-later.html).

