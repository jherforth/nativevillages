local S = minetest.get_translator("nativevillages")

-- Jungle Village Buildings
-- Schematic naming format: structurename_X_Y_Z.mts
-- X = width, Y = height (informational), Z = depth
-- All structures use place_offset_y to adjust groud level spawning mechanic. Can be adjusted.
-- Terrain validation: spawn_by + num_spawn_by ensures ~50% of footprint is flat ground

minetest.register_decoration({
    name = "nativevillages:junglehouse1",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    spawn_by = {"default:dirt_with_rainforest_litter", "default:dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"rainforest"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/junglehouse1_7_26_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:junglehouse2",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    spawn_by = {"default:dirt_with_rainforest_litter", "default:dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"rainforest"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/junglehouse2_7_25_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:junglehouse3",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    spawn_by = {"default:dirt_with_rainforest_litter", "default:dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"rainforest"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/junglehouse3_7_25_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:junglehouse4",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    spawn_by = {"default:dirt_with_rainforest_litter", "default:dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"rainforest"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/junglehouse4_7_26_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:junglehouse5",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    spawn_by = {"default:dirt_with_rainforest_litter", "default:dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 8,
    fill_ratio = 0.0002,
    biomes = {"rainforest"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/junglehouse5_7_28_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:junglechurch",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    spawn_by = {"default:dirt_with_rainforest_litter", "default:dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.0002,
    biomes = {"rainforest"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/junglechurch_7_28_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:junglemarket",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    spawn_by = {"default:dirt_with_rainforest_litter", "default:dirt"},
    num_spawn_by = 12,
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.0002,
    biomes = {"rainforest"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/junglemarket_9_32_9.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})

minetest.register_decoration({
    name = "nativevillages:junglestable",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    spawn_by = {"default:dirt_with_rainforest_litter", "default:dirt"},
    num_spawn_by = 8,
    place_offset_y = 1,
    sidelen = 16,
    fill_ratio = 0.0002,
    biomes = {"rainforest"},
    y_max = 50,
    y_min = 1,
    schematic = minetest.get_modpath("nativevillages").."/schematics/junglestable_7_25_7.mts",
    flags = "place_center_x, place_center_z, force_placement",
    rotation = "random",
})


