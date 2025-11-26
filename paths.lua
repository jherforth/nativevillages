-- paths.lua
-- FINAL SERVER-SAFE VERSION — no minetest.after(), no crashes
-- Uses the single global village noise

local modpath = minetest.get_modpath("nativevillages")

local function register_paths_for_biome(biome_name, place_on_nodes, path_prefix)
    if not nativevillages.global_village_noise then
        minetest.log("warning", "[nativevillages] global_village_noise not ready yet for paths: " .. biome_name)
        return
    end

    local path_noise = table.copy(nativevillages.global_village_noise)
    path_noise.scale = path_noise.scale * 38
    path_noise.spread = {x = 120, y = 120, z = 120}

    local schematics = {
        "forward_straight_5x5",
        "sideways_straight_5x5",
        "junction_5x5",
        "left_5x5",
        "right_5x5",
    }

    local biome_settings = {
        grassland = {biomes = {"grassland", "snowy_grassland", "coniferous_forest", "deciduous_forest"}, y_min = 1,   y_max = 200},
        ice       = {biomes = {"icesheet", "icesheet_ocean"},                                        y_min = -2,  y_max = 40},
        desert    = {biomes = {"desert", "sandstone_desert"},                                       y_min = 1,   y_max = 200},
        savanna   = {biomes = {"savanna"},                                                         y_min = 1,   y_max = 200},
        lake      = {biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"}, y_min = -2, y_max = 6},
        jungle    = {biomes = {"rainforest"},                                                      y_min = 1,   y_max = 200},
    }
    local s = biome_settings[biome_name] or biome_settings.grassland

    for _, name in ipairs(schematics) do
        minetest.register_decoration({
            name = "nativevillages:path_" .. biome_name .. "_" .. name,
            deco_type = "schematic",
            place_on = place_on_nodes,
            sidelen = 8,
            noise_params = path_noise,
            biomes = s.biomes,
            y_min = s.y_min,
            y_max = s.y_max,
            height = 1,
            height_max = 0,
            schematic = modpath .. "/schematics/" .. path_prefix .. "_" .. name .. ".mts",
            flags = "place_center_x, place_center_z, force_placement",
            rotation = "random",
            place_offset_y = -1,
        })
    end
end

-- Register immediately — safe for servers and singleplayer
register_paths_for_biome("grassland", {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"}, "grass_dirt")
register_paths_for_biome("ice",       {"default:snowblock", "default:ice"},                                 "snow_dirt")
register_paths_for_biome("savanna",   {"default:dry_dirt_with_dry_grass"},                                   "savanna_dirt")
register_paths_for_biome("desert",    {"default:desert_sand", "default:sand"},                              "grass_dirt")
register_paths_for_biome("lake",      {"default:dirt", "default:sand"},                                      "grass_dirt")
register_paths_for_biome("jungle",    {"default:dirt_with_rainforest_litter"},                               "grass_dirt")

minetest.log("action", "[nativevillages] Path system loaded")
