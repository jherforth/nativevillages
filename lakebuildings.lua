local S = minetest.get_translator("nativevillages")

-- Lake Village Buildings
-- Schematic naming format: structurename_X_Y_Z.mts
-- X = width, Y = height (informational), Z = depth
-- All structures use place_offset_y to adjust groud level spawning mechanic. Can be adjusted.
-- Terrain validation: spawn_by + num_spawn_by ensures ~50% of footprint is flat ground

minetest.register_decoration({
    name = "nativevillages:lakehouse1",
    deco_type = "schematic",
    place_on = {"default:dirt", "default:sand"},
    spawn_by = {"default:dirt", "default:sand"},
    num_spawn_by = 12,
    place_offset_y = 2,
    sidelen = 16,
    fill_ratio = 0.0002,
    biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
    y_max = 2,
    y_min = -1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/lakehouse1_12_11_15.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:lakehouse2",
    deco_type = "schematic",
    place_on = {"default:dirt", "default:sand"},
    spawn_by = {"default:dirt", "default:sand"},
    num_spawn_by = 12,
    place_offset_y = 2,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
    y_max = 2,
    y_min = -1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/lakehouse2_6_8_8.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:lakehouse3",
    deco_type = "schematic",
    place_on = {"default:dirt", "default:sand"},
    spawn_by = {"default:dirt", "default:sand"},
    num_spawn_by = 12,
    place_offset_y = 2,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
    y_max = 2,
    y_min = -1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/lakehouse3_5_9_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:lakehouse4",
    deco_type = "schematic",
    place_on = {"default:dirt", "default:sand"},
    spawn_by = {"default:dirt", "default:sand"},
    num_spawn_by = 12,
    place_offset_y = 2,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
    y_max = 2,
    y_min = -1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/lakehouse4_5_9_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:lakehouse5",
    deco_type = "schematic",
    place_on = {"default:dirt", "default:sand"},
    spawn_by = {"default:dirt", "default:sand"},
    num_spawn_by = 12,
    place_offset_y = 2,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
    y_max = 2,
    y_min = -1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/lakehouse5_6_11_10.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:lakechurch",
    deco_type = "schematic",
    place_on = {"default:dirt", "default:sand"},
    spawn_by = {"default:dirt", "default:sand"},
    num_spawn_by = 12,
    place_offset_y = 2,
    sidelen = 16,
    fill_ratio = 0.0002,
    biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
    y_max = 2,
    y_min = -1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/lakechurch_9_13_13.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:lakemarket",
    deco_type = "schematic",
    place_on = {"default:dirt", "default:sand"},
    spawn_by = {"default:dirt", "default:sand"},
    num_spawn_by = 12,
    place_offset_y = 2,
    sidelen = 16,
    fill_ratio = 0.00015,
    biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
    y_max = 2,
    y_min = -1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/lakemarket_7_6_10.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:lakestable",
    deco_type = "schematic",
    place_on = {"default:dirt", "default:sand"},
    spawn_by = {"default:dirt", "default:sand"},
    num_spawn_by = 12,
    place_offset_y = 2,
    sidelen = 16,
    fill_ratio = 0.00015,
    biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
    y_max = 2,
    y_min = -1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/lakestable_7_7_13.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})





