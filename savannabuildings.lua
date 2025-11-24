local S = minetest.get_translator("nativevillages")

-- Savanna Village Buildings
-- Schematic naming format: structurename_X_Y_Z.mts
-- X = width, Y = height (informational), Z = depth
-- All structures use place_offset_y to adjust groud level spawning mechanic. Can be adjusted.
-- Terrain validation: spawn_by + num_spawn_by ensures ~50% of footprint is flat ground

minetest.register_decoration({
    name = "nativevillages:savannahouse1",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    spawn_by = {"default:dry_dirt_with_dry_grass", "default:dry_dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"savanna"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/savannahouse1_7_9_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:savannahouse2",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    spawn_by = {"default:dry_dirt_with_dry_grass", "default:dry_dirt"},
    num_spawn_by = 12,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"savanna"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/savannahouse2_9_8_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:savannahouse3",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    spawn_by = {"default:dry_dirt_with_dry_grass", "default:dry_dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"savanna"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/savannahouse3_7_5_8.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:savannahouse4",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    spawn_by = {"default:dry_dirt_with_dry_grass", "default:dry_dirt"},
    num_spawn_by = 10,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"savanna"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/savannahouse4_7_9_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:savannahouse5",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    spawn_by = {"default:dry_dirt_with_dry_grass", "default:dry_dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"savanna"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/savannahouse5_7_6_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:savannachurch",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    spawn_by = {"default:dry_dirt_with_dry_grass", "default:dry_dirt"},
    num_spawn_by = 15,
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.0001,
    biomes = {"savanna"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/savannachurch_8_11_12.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:savannamarket",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    spawn_by = {"default:dry_dirt_with_dry_grass", "default:dry_dirt"},
    num_spawn_by = 12,
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.00015,
    biomes = {"savanna"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/savannamarket_10_5_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:savannastable",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    spawn_by = {"default:dry_dirt_with_dry_grass", "default:dry_dirt"},
    num_spawn_by = 35,
    place_offset_y = 1,
    sidelen = 32,
    fill_ratio = 0.00012,
    biomes = {"savanna"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/savannastable_15_7_16.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})


