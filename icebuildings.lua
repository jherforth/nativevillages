local S = minetest.get_translator("nativevillages")

-- Ice Village Buildings
-- Schematic naming format: structurename_X_Y_Z.mts
-- X = width, Y = height (informational), Z = depth
-- All structures use place_offset_y = -1 for ground-level placement
-- Terrain validation: spawn_by + num_spawn_by ensures ~50% of footprint is flat ground

minetest.register_decoration({
    name = "nativevillages:icehouse1",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 18,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.000015,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 3.5,
    y_min = 1.0,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse1_7_9_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icehouse2",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 24,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.000015,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 3.5,
    y_min = 1.0,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse2_7_7_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icehouse3",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 14,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.000015,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 3.5,
    y_min = 1.0,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse3_6_6_6.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icehouse4",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 16,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.000015,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 3.5,
    y_min = 1.0,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse4_6_7_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icehouse5",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 18,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.000015,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 3.5,
    y_min = 1.0,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icehouse5_7_4_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icechurch",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 27,
    place_offset_y = -1,
    sidelen = 16,
    fill_ratio = 0.000008,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 3.5,
    y_min = 1.0,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icechurch_7_11_10.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icemarket",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 34,
    place_offset_y = -1,
    sidelen = 16,
    fill_ratio = 0.000012,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 3.5,
    y_min = 1.0,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icemarket_10_5_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:icestable",
    deco_type = "schematic",
    place_on = {"default:snowblock", "default:ice"},
    spawn_by = {"default:snowblock", "default:ice"},
    num_spawn_by = 24,
    place_offset_y = -1,
    sidelen = 16,
    fill_ratio = 0.000010,
    biomes = {"icesheet", "icesheet_ocean"},
    y_max = 3.5,
    y_min = 1.0,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icestable_9_5_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})
