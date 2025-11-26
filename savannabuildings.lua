local S = minetest.get_translator("nativevillages")

-- ===================================================================
-- SAVANNA VILLAGE CLUSTERING NOISE
-- Large, proud villages with plenty of breathing room
-- ===================================================================

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Helper: regular savanna houses
-- ===================================================================

local function register_savanna_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dry_dirt_with_dry_grass"},
        sidelen = 32,
        noise_params = village_noise,
        biomes = {"savanna"},
        y_min = 1,
        y_max = 120,                   -- Savanna can go high
        height = 1,                    -- Allows gentle savanna hills
        height_max = 1,
        place_offset_y = params.offset_y or 0,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL SAVANNA HOUSES
-- ===================================================================

register_savanna_building({ name = "savannahouse1", file = "savannahouse1_7_9_7.mts"})
register_savanna_building({ name = "savannahouse2", file = "savannahouse2_9_8_9.mts"})
register_savanna_building({ name = "savannahouse3", file = "savannahouse3_7_5_8.mts"})
register_savanna_building({ name = "savannahouse4", file = "savannahouse4_7_9_9.mts"})
register_savanna_building({ name = "savannahouse5", file = "savannahouse5_7_6_7.mts"})

-- ===================================================================
-- CENTRAL / RARER BUILDINGS (church, market, stable)
-- Lower density + offset seeds → appear near village center
-- ===================================================================

local function register_savanna_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dry_dirt_with_dry_grass"},
        sidelen = 40,
        noise_params = central_noise,
        biomes = {"savanna"},
        y_min = 1,
        y_max = 120,
        height = 1,
        height_max = 1,
        place_offset_y = params.offset_y or -1,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

register_savanna_central({ name = "savannachurch",  file = "savannachurch_8_11_12.mts"})
register_savanna_central({ name = "savannamarket",  file = "savannamarket_10_5_9.mts"})
register_savanna_central({ name = "savannastable",  file = "savannastable_15_7_16.mts", offset_y = -1 })






