-- paths_new.lua
-- Improved path system for connecting village buildings
local modpath = minetest.get_modpath("nativevillages")

-- Path node definitions for different biomes
local path_nodes = {
    grassland = "default:dirt",
    desert = "default:desert_sand",
    ice = "default:snowblock",
    savanna = "default:dry_dirt",
    jungle = "default:dirt",
    lake = "default:dirt",
}

-- Simple path registration using noise
minetest.register_decoration({
    name = "nativevillages:grassland_paths",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    sidelen = 40,
    noise_params = nativevillages.global_path_noise,
    biomes = {"grassland"},
    y_min = 1,
    y_max = 110,

    place_offset_y = 0,
    flags = "place_center_x, place_center_z, force_placement",

    schematic = modpath.."/schematics/grass_dirt_forward_straight_5x5.mts",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:desert_paths",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    sidelen = 40,
    noise_params = nativevillages.global_path_noise,
    biomes = {"desert"},
    y_min = 1,
    y_max = 50,

    place_offset_y = 0,
    flags = "place_center_x, place_center_z, force_placement",

    schematic = modpath.."/schematics/grass_dirt_forward_straight_5x5.mts",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:savanna_paths",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    sidelen = 40,
    noise_params = nativevillages.global_path_noise,
    biomes = {"savanna"},
    y_min = 1,
    y_max = 140,

    place_offset_y = 0,
    flags = "place_center_x, place_center_z, force_placement",

    schematic = modpath.."/schematics/savanna_dirt_forward_straight_5x5.mts",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:ice_paths",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    sidelen = 40,
    noise_params = nativevillages.global_path_noise,
    biomes = {"icesheet", "icesheet_ocean"},
    y_min = -2,
    y_max = 40,

    place_offset_y = 0,
    flags = "place_center_x, place_center_z, force_placement",

    schematic = modpath.."/schematics/snow_dirt_forward_straight_5x5.mts",
    rotation = "random",
})

print("[nativevillages] Path system loaded")
