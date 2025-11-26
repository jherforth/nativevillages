-- paths.lua
-- FINAL VERSION — uses the ONE global village noise so paths appear exactly where villages do

local modpath = minetest.get_modpath("nativevillages")

local function register_paths_for_biome(biome_name, place_on_nodes, path_prefix)
    -- Use the exact same global village noise as houses, but way denser inside the blob
    local path_noise = table.copy(nativevillages.global_village_noise)
    path_noise.scale = path_noise.scale * 38   -- 38× denser = fills the village nicely
    path_noise.spread = {x = 120, y = 120, z = 120}

    local schematics = {
        "forward_straight_5x5",
        "sideways_straight_5x5",
        "junction_5x5",
        "left_5x5",
        "right_5x5",
    }

    local biome_list = {
        grassland = {"grassland", "snowy_grassland", "coniferous_forest", "deciduous_forest"},
        ice       = {"icesheet", "icesheet_ocean"},
        desert    = {"desert", "sandstone_desert"},
        savanna   = {"savanna"},
        lake      = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
        jungle    = {"rainforest"},
    }

    for _, name in ipairs(schematics) do
        local full_path = modpath .. "/schematics/" .. path_prefix .. "_" .. name .. ".mts"

        minetest.register_decoration({
            name = "nativevillages:path_" .. biome_name .. "_" .. name,
            deco_type = "schematic",
            place_on = place_on_nodes,
            sidelen = 8,                     -- paths want to be dense
            noise_params = path_noise,
            biomes = biome_list[biome_name] or biome_list.grassland,
            y_min = (biome_name == "ice" or biome_name == "lake") and -2 or 1,
            y_max = (biome_name == "ice") and 40 or (biome_name == "lake") and 6 or 200,
            height = 1,
            height_max = 0,                  -- perfectly flat under paths too
            schematic = full_path,
            flags = "place_center_x, place_center_z, force_placement",
            rotation = "random",
            place_offset_y = -1,
        })
    end
end

-- Wait until everything is loaded
minetest.after(8, function()
    register_paths_for_biome("grassland", {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"}, "grass_dirt")
    register_paths_for_biome("ice",       {"default:snowblock", "default:ice"},    "snow_dirt")
    register_paths_for_biome("savanna",   {"default:dry_dirt_with_dry_grass"},     "savanna_dirt")
    register_paths_for_biome("desert",    {"default:desert_sand", "default:sand"}, "grass_dirt")  -- change to desert_dirt later if you make them
    register_paths_for_biome("lake",      {"default:dirt", "default:sand"},        "grass_dirt")
    register_paths_for_biome("jungle",    {"default:dirt_with_rainforest_litter"}, "grass_dirt")

    minetest.log("action", "[nativevillages] All path schematics successfully registered!")
end)
