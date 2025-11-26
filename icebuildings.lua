local S = minetest.get_translator("nativevillages")

-- ===================================================================
-- ICE VILLAGE CLUSTERING NOISE
-- Tighter, more frequent villages than grassland — fits arctic theme
-- ===================================================================

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Helper: regular ice houses
-- ===================================================================

local function register_ice_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:snowblock", "default:ice"},
        sidelen = 24,
        noise_params = village_noise,
        biomes = {"icesheet", "icesheet_ocean"},
        y_min = 0,
        y_max = 40,
        height = 0,
        height_max = 0,
        place_offset_y = params.offset_y or 0,  -- Most ice schematics sit directly on surface
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL ICE HOUSES
-- ===================================================================

register_ice_building({ name = "icehouse1", file = "icehouse1_7_9_7.mts", offset_y = 0 })
register_ice_building({ name = "icehouse2", file = "icehouse2_7_7_9.mts" })
register_ice_building({ name = "icehouse3", file = "icehouse3_6_6_6.mts" })
register_ice_building({ name = "icehouse4", file = "icehouse4_6_7_7.mts" })
register_ice_building({ name = "icehouse5", file = "icehouse5_7_4_7.mts" })

-- ===================================================================
-- CENTRAL / RARER BUILDINGS — use the global central noise
-- ===================================================================

local function register_ice_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:snowblock", "default:ice"},
        sidelen = 32,
        noise_params = central_noise,
        biomes = {"icesheet", "icesheet_ocean"},
        y_min = 0,
        y_max = 40,
        height = 0,
        height_max = 0,
        place_offset_y = params.offset_y or 0,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

register_ice_central({ name = "icechurch", file = "icechurch_7_11_10.mts" })
register_ice_central({ name = "icemarket", file = "icemarket_10_5_9.mts" })
register_ice_central({ name = "icestable", file = "icestable_9_5_7.mts" })










