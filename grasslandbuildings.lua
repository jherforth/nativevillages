local S = minetest.get_translator("nativevillages")

-- Grassland Village Buildings
-- Schematic naming format: structurename_X_Y_Z.mts
-- X = width, Y = height (informational), Z = depth
-- All structures use place_offset_y = -1 for ground-level placement
-- Terrain validation: spawn_by + num_spawn_by ensures ~50% of footprint is flat ground

minetest.register_decoration({
    name = "nativevillages:grasslandhouse1",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    spawn_by = {"default:dirt_with_grass", "default:dirt"},
    num_spawn_by = 8,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"grassland", "snowy_grassland"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/grasslandhouse1_7_9_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:grasslandhouse2",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    spawn_by = {"default:dirt_with_grass", "default:dirt"},
    num_spawn_by = 6,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"grassland", "snowy_grassland"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/grasslandhouse2_6_7_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:grasslandhouse3",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    spawn_by = {"default:dirt_with_grass", "default:dirt"},
    num_spawn_by = 12,
    place_offset_y = -1,
    sidelen = 16,
    fill_ratio = 0.0002,
    biomes = {"grassland", "snowy_grassland"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/grasslandhouse3_10_10_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:grasslandhouse4",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    spawn_by = {"default:dirt_with_grass", "default:dirt"},
    num_spawn_by = 10,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"grassland", "snowy_grassland"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/grasslandhouse4_7_7_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:grasslandhouse5",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    spawn_by = {"default:dirt_with_grass", "default:dirt"},
    num_spawn_by = 5,
    place_offset_y = -1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"grassland", "snowy_grassland"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/grasslandhouse5_6_6_6.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:grasslandchurch",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    spawn_by = {"default:dirt_with_grass", "default:dirt"},
    num_spawn_by = 30,
    place_offset_y = -1,
    sidelen = 32,
    fill_ratio = 0.0001,
    biomes = {"grassland", "snowy_grassland"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/grasslandchurch_11_17_21.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:grasslandmarket",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    spawn_by = {"default:dirt_with_grass", "default:dirt"},
    num_spawn_by = 12,
    place_offset_y = -1,
    sidelen = 16,
    fill_ratio = 0.00015,
    biomes = {"grassland", "snowy_grassland"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/grasslandmarket_9_5_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:grasslandstable",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    spawn_by = {"default:dirt_with_grass", "default:dirt"},
    num_spawn_by = 35,
    place_offset_y = -1,
    sidelen = 32,
    fill_ratio = 0.00012,
    biomes = {"grassland", "snowy_grassland"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/grasslandstable_15_8_16.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})
