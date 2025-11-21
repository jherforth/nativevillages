local S = minetest.get_translator("nativevillages")

-- Desert Village Buildings
-- Schematic naming format: structurename_X_Y_Z.mts
-- X = width, Y = height (informational), Z = depth
-- All structures use place_offset_y = -1 for ground-level placement
-- Terrain validation: spawn_by + num_spawn_by ensures 75% of footprint is flat ground

minetest.register_decoration({
    name = "nativevillages:deserthouse1",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    spawn_by = {"default:desert_sand"},
    num_spawn_by = 81,
    place_offset_y = -1,
    sidelen = 16,
    fill_ratio = 0.000015,
    biomes = {"desert"},
    y_max = 30.5,
    y_min = 25.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/deserthouse1_12_14_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:deserthouse2",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    spawn_by = {"default:desert_sand"},
    num_spawn_by = 48,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.000015,
    biomes = {"desert"},
    y_max = 30.5,
    y_min = 25.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/deserthouse2_8_7_8.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:deserthouse3",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    spawn_by = {"default:desert_sand"},
    num_spawn_by = 48,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.000015,
    biomes = {"desert"},
    y_max = 30.5,
    y_min = 25.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/deserthouse3_8_10_8.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:deserthouse4",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    spawn_by = {"default:desert_sand"},
    num_spawn_by = 53,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.000015,
    biomes = {"desert"},
    y_max = 30.5,
    y_min = 25.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/deserthouse4_10_8_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:deserthouse5",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    spawn_by = {"default:desert_sand"},
    num_spawn_by = 60,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.000015,
    biomes = {"desert"},
    y_max = 30.5,
    y_min = 25.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/deserthouse5_10_6_8.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:desertchurch",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    spawn_by = {"default:desert_sand"},
    num_spawn_by = 108,
    place_offset_y = -1,
    sidelen = 16,
    fill_ratio = 0.000008,
    biomes = {"desert"},
    y_max = 30.5,
    y_min = 25.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/desertchurch_9_12_16.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:desertmarket",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    spawn_by = {"default:desert_sand"},
    num_spawn_by = 117,
    place_offset_y = -1,
    sidelen = 16,
    fill_ratio = 0.000012,
    biomes = {"desert"},
    y_max = 30.5,
    y_min = 25.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/desertmarket_12_16_13.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:desertstable",
    deco_type = "schematic",
    place_on = {"default:desert_sand"},
    spawn_by = {"default:desert_sand"},
    num_spawn_by = 88,
    place_offset_y = -1,
    sidelen = 16,
    fill_ratio = 0.000010,
    biomes = {"desert"},
    y_max = 30.5,
    y_min = 25.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/desertstable_13_6_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})
