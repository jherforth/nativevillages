local S = minetest.get_translator("nativevillages")

-- ===================================================================
-- GRASSLAND / FOREST VILLAGE CLUSTERING NOISE
-- Same noise for all houses → perfect village grouping
-- ===================================================================

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Helper function (DRY — don't repeat yourself)
-- ===================================================================

local function register_grassland_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},
        sidelen = 24,
        noise_params = village_noise,
        biomes = {"grassland", "coniferous_forest", "deciduous_forest"},
        y_min = 0,
        y_max = 110,                    -- Higher than desert — forests go up to ~100
        height = 2,                     -- Grassland is flatter → we can demand flatter ground
        place_offset_y = params.offset_y or 0,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL GRASSLAND HOUSES
-- ===================================================================

register_grassland_building({ name = "grasslandhouse1", file = "grasslandhouse1_7_9_7.mts"})
register_grassland_building({ name = "grasslandhouse2", file = "grasslandhouse2_6_7_7.mts"})
register_grassland_building({ name = "grasslandhouse3", file = "grasslandhouse3_10_10_9.mts"})
register_grassland_building({ name = "grasslandhouse4", file = "grasslandhouse4_7_7_9.mts"})
register_grassland_building({ name = "grasslandhouse5", file = "grasslandhouse5_6_6_6.mts"})

-- ===================================================================
-- CENTRAL / RARER BUILDINGS (church, market, stable)
-- Use slightly lower density and offset seeds so they appear near village centers
-- ===================================================================

local function register_grassland_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},
        sidelen = 32,
        noise_params = central_noise,
        biomes = {"grassland", "snowy_grassland", "coniferous_forest", "deciduous_forest"},
        y_min = 1,
        y_max = 110,
        height = 2,
        place_offset_y = params.offset_y or 0,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

register_grassland_central({name = "grasslandchurch", file = "grasslandchurch_11_17_21.mts", offset_y = 0})
register_grassland_central({name = "grasslandmarket",file = "grasslandmarket_9_5_9.mts", offset_y = 0})
register_grassland_central({name = "grasslandstable", file = "grasslandstable_15_8_16.mts", offset_y = 0})








