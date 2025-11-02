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
    local path_dirt = minetest.get_content_id("atl_path:path_dirt")
    local path_sand = minetest.get_content_id("atl_path:path_sand")
    local path_snow = minetest.get_content_id("atl_path:path_snow")

    local dirt_with_grass = minetest.get_content_id("default:dirt_with_grass")
    local dry_dirt_with_dry_grass = minetest.get_content_id("default:dry_dirt_with_dry_grass")
    local dirt_with_rainforest = minetest.get_content_id("default:dirt_with_rainforest_litter")
    local desert_sand = minetest.get_content_id("default:desert_sand")
    local snowblock = minetest.get_content_id("default:snowblock")
    local dirt = minetest.get_content_id("default:dirt")

    minetest.register_on_generated(function(minp, maxp, blockseed)
        local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
        local data = vm:get_data()
        local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})

        local pr = PseudoRandom(blockseed + 719)
        local changed = false

        for y = minp.y, maxp.y do
            for z = minp.z, maxp.z do
                for x = minp.x, maxp.x do
                    local vi = area:index(x, y, z)
                    local vi_above = area:index(x, y+1, z)
                    local node = data[vi]
                    local node_above = data[vi_above]

                    if node_above == minetest.CONTENT_AIR or
                       node_above == dirt_with_grass or
                       node_above == dry_dirt_with_dry_grass or
                       node_above == dirt_with_rainforest then

                        if (node == dirt_with_grass or node == dry_dirt_with_dry_grass or node == dirt_with_rainforest) and pr:next(1, 100) <= 8 then
                            data[vi] = path_dirt
                            changed = true
                        elseif node == desert_sand and pr:next(1, 100) <= 8 then
                            data[vi] = path_sand
                            changed = true
                        elseif node == snowblock and pr:next(1, 100) <= 8 then
                            data[vi] = path_snow
                            changed = true
                        end
                    end
                end
            end
        end

        if changed then
            vm:set_data(data)
            vm:write_to_map()
        end
    end)
end

if minetest.get_modpath("farming") then
    minetest.register_decoration({
        name = "nativevillages:grasslandvillage_wheat",
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 4,
        fill_ratio = 0.08,
        biomes = {"grassland", "snowy_grassland"},
        y_max = 20.5,
        y_min = 15.5,
        decoration = "farming:wheat_8",
        flags = "all_floors",
    })

    minetest.register_decoration({
        name = "nativevillages:grasslandvillage_cotton",
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 4,
        fill_ratio = 0.04,
        biomes = {"grassland", "snowy_grassland"},
        y_max = 20.5,
        y_min = 15.5,
        decoration = "farming:cotton_8",
        flags = "all_floors",
    })

    minetest.register_decoration({
        name = "nativevillages:grasslandvillage_carrot",
        deco_type = "simple",
        place_on = {"default:dirt_with_grass"},
        sidelen = 4,
        fill_ratio = 0.03,
        biomes = {"grassland"},
        y_max = 20.5,
        y_min = 15.5,
        decoration = "farming:carrot_8",
        flags = "all_floors",
    })
end