local S = minetest.get_translator("nativevillages")

-- Ice Village Buildings
-- Schematic naming format: structurename_X_Y_Z.mts
-- X = width, Y = height (informational), Z = depth
-- All structures use place_offset_y = 0 for ground-level placement and can be adjusted if necessary
-- Terrain validation: spawn_by + num_spawn_by ensures ~50% of footprint is flat ground

minetest.register_decoration({
    name = "nativevillages:icehouse1",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 8,
    place_offset_y = 0,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 50,
    y_min = -10,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse1_7_9_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icehouse2",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 10,
    place_offset_y = 0,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 50,
    y_min = -10,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse2_7_7_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icehouse3",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 5,
    place_offset_y = 0,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 50,
    y_min = -10,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse3_6_6_6.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icehouse4",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 6,
    place_offset_y = 0,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 50,
    y_min = -10,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse4_6_7_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icehouse5",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 8,
    place_offset_y = 0,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 50,
    y_min = -10,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse5_7_4_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icechurch",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 10,
    place_offset_y = 0,
    sidelen = 16,
    fill_ratio = 0.0001,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 50,
    y_min = -10,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icechurch_7_11_10.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icemarket",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 12,
    place_offset_y = 0,
    sidelen = 16,
    fill_ratio = 0.00015,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 50,
    y_min = -10,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icemarket_10_5_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icestable",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 10,
    place_offset_y = 0,
    sidelen = 16,
    fill_ratio = 0.00012,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 50,
    y_min = -10,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icestable_9_5_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

