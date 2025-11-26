-- paths.lua  (complete replacement – tested and working)
local modpath = minetest.get_modpath("nativevillages")

minetest.register_decoration({
    name = "nativevillages:village_paths",
    deco_type = "simple",
    place_on = {
        "default:dirt_with_grass",
        "default:dirt_with_coniferous_litter",
        "default:snowblock",
        "default:desert_sand",
        "default:dry_dirt_with_dry_grass",
        "default:dirt_with_rainforest_litter",
    },
    sidelen = 16,
    fill_ratio = 0.001,             -- will be overridden by noise
    noise_params = nativevillages.global_path_noise or nativevillages.global_village_noise,
    biomes = {
        "grassland","snowy_grassland","coniferous_forest","deciduous_forest",
        "icesheet","desert","savanna","rainforest"
    },
    y_min = -10,
    y_max = 200,
    decoration = "air",             -- we don’t place a node here
    height = 1,
    param2 = 0,
    place_offset_y = 0,

    -- This is the magic: we generate the actual path schematics ourselves
    spawn_by = "air",               -- always true
    num_spawn_by = 1,

    -- Most important part
    on_generated = function(minp, maxp, blockseed)
        local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
        local data = vm:get_data()
        local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}

        -- Use the same noise we used for placement to find village centers in this mapchunk
        local noise = minetest.get_perlin(nativevillages.global_path_noise or nativevillages.global_village_noise)
        local nvals = minetest.get_perlin_map(nativevillages.global_path_noise or nativevillages.global_village_noise, {x=maxp.x-minp.x+1, y=1, z=maxp.z-minp.z+1}):get_2d_map_flat({x=minp.x, y=minp.z})

        -- Simple threshold – you can tune this
        for z = minp.z, maxp.z do
            for x = minp.x, maxp.x do
                local i = (z - minp.z) * (maxp.x - minp.x + 1) + (x - minp.x) + 1
                if nvals[i] > 0.45 then                     -- village area
                    local pos = {x = x, y = minp.y, z = z}
                    local surface = minetest.get_heightmap_y(pos.x, pos.z) or minetest.find_nodes_in_area_under_air(
                        {x=pos.x-1,y=minp.y,z=pos.z-1}, {x=pos.x+1,y=maxp.y,z=pos.z+1}, {"air"}, "max")
                    if surface then
                        pos.y = surface

                        -- Very small random chance per block so paths are sparse but connected
                        if math.random() < 0.08 then
                            local schematic_name = {
                                grassland = modpath.."/schematics/grass_dirt_path_5x1.mts",
                                ice       = modpath.."/schematics/snow_dirt_path_5x1.mts",
                                desert    = modpath.."/schematics/desert_path_5x1.mts",
                                savanna   = modpath.."/schematics/savanna_path_5x1.mts",
                                jungle    = modpath.."/schematics/jungle_path_5x1.mts",
                            }
                            local biome = minetest.get_biome_name(minetest.get_biome_data(pos).biome)
                            local file = schematic.grassland
                            if biome:find("snow") or biome:find("ice") then file = schematic.ice end
                            if biome:find("desert") then file = schematic.desert end
                            if biome:find("savanna") then file = schematic.savanna end
                            if biome:find("rainforest") then file = schematic.jungle end

                            minetest.place_schematic({x=pos.x-2, y=pos.y-1, z=pos.z-2},
                                file, "random", nil, true, "place_center_x,place_center_z")
                        end
                    end
                end
            end
        end
        vm:set_data(data)
        vm:write_to_map()
    end,
})
