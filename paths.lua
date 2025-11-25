-- paths.lua
-- Automatic connecting paths for all nativevillages biomes
-- Uses the exact same noise as houses → perfect natural roads

local modpath = minetest.get_modpath("nativevillages")

-- Helper: register a whole set of paths for one biome
local function register_paths_for_biome(biome_name, place_on_nodes, path_prefix, noise_copy_from)
    -- Use the exact same noise as houses, but much denser inside the village blob
    local path_noise = table.copy(noise_copy_from)
    path_noise.scale = path_noise.scale * 28   -- 28× denser than houses = fills the village
    path_noise.spread = {x = 160, y = 160, z = 160}  -- same size as village

    local path_schematics = {
        modpath.."/schematics/"..path_prefix.."_forward_straight_5x5.mts",
        modpath.."/schematics/"..path_prefix.."_sideways_straight_5x5.mts",
        modpath.."/schematics/"..path_prefix.."_junction_5x5.mts",
        modpath.."/schematics/"..path_prefix.."_left_5x5.mts",
        modpath.."/schematics/"..path_prefix.."_right_5x5.mts",
    }

    for _, schem in ipairs(path_schematics) do
        minetest.register_decoration({
            name = "nativevillages:path_"..biome_name.."_"..math.random(999),
            deco_type = "schematic",
            place_on = place_on_nodes,
            sidelen = 8,
            fill_ratio = 0.0,           -- we use noise_params instead
            noise_params = path_noise,
            biomes = biome_name == "ice" and {"icesheet", "icesheet_ocean"} or
                     biome_name == "desert" and {"desert", "sandstone_desert"} or
                     biome_name == "savanna" and {"savanna"} or
                     biome_name == "jungle" and {"rainforest"} or
                     biome_name == "lake" and {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"} or
                     {"grassland", "snowy_grassland", "coniferous_forest", "deciduous_forest"},
            y_min = biome_name == "ice" and -10 or (biome_name == "lake" and 0 or 1),
            y_max = biome_name == "ice" and 40 or (biome_name == "lake" and 4 or 140),
            schematic = schem,
            flags = "place_center_x, place_center_z, force_placement",
            rotation = "random",
            height = 1,
            place_offset_y = -1,   -- paths sit flush on ground
        })
    end
end

-- ===================================================================
-- CALL THIS FROM init.lua AFTER all your village noise tables exist
-- ===================================================================

minetest.after(1, function()
    -- Grassland
    register_paths_for_biome("grassland", {"default:dirt_with_grass"}, "grass_dirt", grassland_village_noise)
    -- Snow/Ice
    register_paths_for_biome("ice", {"default:snowblock", "default:ice"}, "snow_dirt", ice_village_noise)
    -- Savanna
    register_paths_for_biome("savanna", {"default:dry_dirt_with_dry_grass"}, "savanna_dirt", savanna_village_noise)
    -- Desert (you can make desert_path_*.mts later if you want sandstone paths)
    register_paths_for_biome("desert", {"default:desert_sand", "default:sand"}, "grass_dirt", desert_village_noise)  -- reuse grass for now
    -- Lake villages (use grass/dirt paths on shore)
    register_paths_for_biome("lake", {"default:dirt", "default:sand"}, "grass_dirt", lake_village_noise)
    -- Jungle (you can make vine-covered paths later)
    register_paths_for_biome("jungle", {"default:dirt_with_rainforest_litter"}, "grass_dirt", jungle_village_noise)
end)
