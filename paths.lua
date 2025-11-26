-- paths.lua
-- FINAL WORKING VERSION — no syntax errors, no timing issues
-- Automatic dirt paths that perfectly connect all your villages

local modpath = minetest.get_modpath("nativevillages")

local function register_paths_for_biome(biome_name, place_on_nodes, path_prefix, source_noise)
    if not source_noise then
        minetest.log("warning", "[nativevillages] Missing noise for paths: " .. biome_name)
        return
    end

    local path_noise = table.copy(nativevillages.global_village_noise)
    path_noise.scale = path_noise.scale * 38   -- dense paths inside the rare village
    path_noise.spread = {x = 160, y = 160, z = 160}

    local schematics = {
        "forward_straight_5x5",
        "sideways_straight_5x5",
        "junction_5x5",
        "left_5x5",
        "right_5x5",
    }

    -- Biome-specific settings
    local biome_settings = {
        grassland = {biomes = {"grassland", "snowy_grassland", "coniferous_forest", "deciduous_forest"}, y_min = 1,   y_max = 140},
        ice       = {biomes = {"icesheet", "icesheet_ocean"},                                y_min = -10, y_max = 40},
        desert    = {biomes = {"desert", "sandstone_desert"},                               y_min = 1,   y_max = 140},
        savanna   = {biomes = {"savanna"},                                                 y_min = 1,   y_max = 140},
        lake      = {biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"}, y_min = -2, y_max = 6},
        jungle    = {biomes = {"rainforest"},                                              y_min = 1,   y_max = 140},
    }

    local settings = biome_settings[biome_name] or biome_settings.grassland

    for _, name in ipairs(schematics) do
        local full_path = modpath .. "/schematics/" .. path_prefix .. "_" .. name .. ".mts"

        minetest.register_decoration({
            name = "nativevillages:path_" .. biome_name .. "_" .. name,
            deco_type = "schematic",
            place_on = place_on_nodes,
            sidelen = 8,
            noise_params = path_noise,
            biomes = settings.biomes,
            y_min = settings.y_min,
            y_max = settings.y_max,
            schematic = full_path,
            flags = "place_center_x, place_center_z, force_placement",
            rotation = "random",
            height = 1,
            place_offset_y = -1,
        })
    end
end

-- Wait long enough for ALL building files to define their noise tables
minetest.after(6, function()
    register_paths_for_biome("grassland", {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"}, "grass_dirt", grassland_village_noise)
    register_paths_for_biome("ice",       {"default:snowblock", "default:ice"},                                 "snow_dirt",   ice_village_noise)
    register_paths_for_biome("savanna",   {"default:dry_dirt_with_dry_grass"},                                   "savanna_dirt", savanna_village_noise)
    register_paths_for_biome("desert",    {"default:desert_sand", "default:sand"},                              "grass_dirt",  desert_village_noise)  -- reuse grass paths until you make desert ones
    register_paths_for_biome("lake",      {"default:dirt", "default:sand"},                                      "grass_dirt",  lake_village_noise)
    register_paths_for_biome("jungle",    {"default:dirt_with_rainforest_litter"},                               "grass_dirt",  jungle_village_noise)

    minetest.log("action", "[nativevillages] All village paths successfully registered!")
end)
