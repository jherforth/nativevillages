local S = minetest.get_translator("nativevillages")

minetest.register_decoration({
    name = "nativevillages:lakevillage",
    deco_type = "schematic",
    place_on = {"default:dirt", "default:sand"},
    place_offset_y = 0,
    sidelen = 8,
    fill_ratio = 0.0001,
    biomes = {"deciduous_forest_ocean", "grassland_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
    y_max = -0.5,
    y_min = -0.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/lakevillage3_0_180.mts",
    flags = "force_placement",
})

minetest.register_decoration({
    name = "nativevillages:junglevillage",
    deco_type = "schematic",
    place_on = {"default:dirt_with_rainforest_litter"},
    place_offset_y = -4,
    sidelen = 8,
    fill_ratio = 0.0001,
    biomes = {"rainforest", "rainforest_swamp"},
    y_max = 3.5,
    y_min = 2.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/junglevillage_4_180.mts",
    flags = "force_placement",
})

minetest.register_decoration({
    name = "nativevillages:grasslandvillage",
    deco_type = "schematic",
    place_on = {"default:dirt_with_grass"},
    place_offset_y = -4,
    sidelen = 8,
    fill_ratio = 0.0001,
    biomes = {"grassland", "grassland_dunes", "deciduous_forest_shore"},
    y_max = 3.5,
    y_min = 2.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/grasslandvillage_4_270.mts",
    flags = "force_placement",
})

minetest.register_decoration({
    name = "nativevillages:savannavillge",
    deco_type = "schematic",
    place_on = {"default:dry_dirt_with_dry_grass"},
    place_offset_y = -4,
    sidelen = 8,
    fill_ratio = 0.0001,
    biomes = {"savanna"},
    y_max = 3.5,
    y_min = 2.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/savannavillage_4_180.mts",
    flags = "force_placement",
})

minetest.register_decoration({
    name = "nativevillages:desertvillage",
    deco_type = "schematic",
    place_on = {"default:desert_sand", "default:sand"},
    place_offset_y = -4,
    sidelen = 8,
    fill_ratio = 0.0001,
    biomes = {"desert"},
    y_max = 3.5,
    y_min = 2.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/desertvillage_4_180.mts",
    flags = "force_placement",
})

minetest.register_decoration({
    name = "nativevillages:icevillage",
    deco_type = "schematic",
    place_on = {"default:snowblock"},
    place_offset_y = -4,
    sidelen = 8,
    fill_ratio = 0.0001,
    biomes = {"icesheet", "icesheet_ocean", "tundra", "tundra_ocean", "tundra_highland", },
    y_max = 3.5,
    y_min = 2.5,
    schematic = minetest.get_modpath("nativevillages").."/schematics/icevillage_4_90.mts",
    flags = "force_placement",
})

if minetest.get_modpath("atl_path") then
    minetest.register_decoration({
        name = "nativevillages:grasslandvillage_path",
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 8,
        fill_ratio = 0.05,
        biomes = {"grassland", "grassland_dunes", "deciduous_forest_shore"},
        y_max = 3.5,
        y_min = 2.5,
        decoration = "atl_path:path_dirt",
        flags = "all_floors",
    })

    minetest.register_decoration({
        name = "nativevillages:desertvillage_path",
        deco_type = "simple",
        place_on = {"default:desert_sand", "default:sand"},
        sidelen = 8,
        fill_ratio = 0.05,
        biomes = {"desert"},
        y_max = 3.5,
        y_min = 2.5,
        decoration = "atl_path:path_sand",
        flags = "all_floors",
    })

    minetest.register_decoration({
        name = "nativevillages:savannavillage_path",
        deco_type = "simple",
        place_on = {"default:dry_dirt_with_dry_grass"},
        sidelen = 8,
        fill_ratio = 0.05,
        biomes = {"savanna"},
        y_max = 3.5,
        y_min = 2.5,
        decoration = "atl_path:path_dirt",
        flags = "all_floors",
    })

    minetest.register_decoration({
        name = "nativevillages:icevillage_path",
        deco_type = "simple",
        place_on = {"default:snowblock"},
        sidelen = 8,
        fill_ratio = 0.05,
        biomes = {"icesheet", "icesheet_ocean", "tundra", "tundra_ocean", "tundra_highland"},
        y_max = 3.5,
        y_min = 2.5,
        decoration = "atl_path:path_snow",
        flags = "all_floors",
    })
end

if minetest.get_modpath("farming") then
    minetest.register_decoration({
        name = "nativevillages:grasslandvillage_wheat",
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 8,
        fill_ratio = 0.08,
        biomes = {"grassland", "grassland_dunes"},
        y_max = 3.5,
        y_min = 2.5,
        decoration = "farming:wheat_8",
        flags = "all_floors",
    })

    minetest.register_decoration({
        name = "nativevillages:grasslandvillage_cotton",
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 8,
        fill_ratio = 0.04,
        biomes = {"grassland", "grassland_dunes"},
        y_max = 3.5,
        y_min = 2.5,
        decoration = "farming:cotton_8",
        flags = "all_floors",
    })

    minetest.register_decoration({
        name = "nativevillages:grasslandvillage_carrot",
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 8,
        fill_ratio = 0.03,
        biomes = {"grassland"},
        y_max = 3.5,
        y_min = 2.5,
        decoration = "farming:carrot_8",
        flags = "all_floors",
    })
end