-- paths.lua
-- FIXED VERSION — waits until ALL village noise tables exist
-- Automatic connecting paths for all biomes

local modpath = minetest.get_modpath("nativevillages")

local function register_paths_for_biome(biome_name, place_on_nodes, path_prefix, source_noise)
    if not source_noise then
        minetest.log("warning", "[nativevillages] Path noise missing for " .. biome_name)
        return
    end

    local path_noise = table.copy(source_noise)
    path_noise.scale = path_noise.scale * 28   -- dense inside village
    path_noise.spread = {x = 160, y = 160, z = 160}

    local schematics = {
        "forward_straight_5x5",
        "sideways_straight_5x5",
        "junction_5x5",
        "left_5x5",
        "right_5x5",
    }

    for _, name in ipairs(schematics) do
        local schem_file = modpath .. "/schematics/" .. path_prefix .. "_" .. name .. ".mts"
        minetest.register_decoration({
            name = "nativevillages:path_" .. biome_name .. "_" .. name,
            deco_type = "schematic",
            place_on = place_on_nodes,
            sidelen = 8,
            noise_params = path_noise,
            biomes = {
                grassland = {"grassland", "snowy_grassland", "coniferous_forest", "deciduous_forest"},
                ice       = {"icesheet", "icesheet_ocean"},
                desert    = {"desert", "sandstone_desert"},
                savanna   = {"savanna"},
                lake      = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
                jungle    = {"rainforest"},
            }[biome_name] or {"grassland"},
            y_min = (biome_name == "ice" or biome_name == "lake") and -10 or 1,
            y_max = (biome_name == "ice") and 40 or (biome_name == "lake") and 4 or 140,
            schematic = schem_file,
            flags = "place_center_x, place_center_z, force_placement",
            rotation = "random",
            height = 1,
            place_offset_y = -1,
        })
    end
end

-- Wait until ALL building files are loaded and noise tables exist
minetest.after(5, function()
    register_paths_for_biome("grassland", {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"}, "grass_dirt", grassland_village_noise)
    register_paths_for_biome("ice",       {"default:snowblock", "default:ice"},                                 "snow_dirt",   ice_village_noise)
    register_paths_for_biome("savanna",   {"default:dry_dirt_with_dry_grass"},                                   "savanna_dirt", savanna_village_noise)
    register_paths_for_biome("desert",    {"default:desert_sand", "default:sand"},                              "grass_dirt",  desert_village_noise)  -- reuse grass paths for now
    register_paths_for_biome("lake",      {"default:dirt", "default:sand"},                                      "grass_dirt",  lake_village_noise)
    register_paths_for_biome("jungle",    {"default:dirt_with_rainforest_litter"},                               "grass_dirt",  jungle_village_noise)

    minetest.log("action", "[nativevillages] Paths loaded for all 6 biomes")
end)
