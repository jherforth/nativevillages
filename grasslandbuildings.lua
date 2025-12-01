local S = minetest.get_translator("nativevillages")

-- utils.lua is now loaded only in init.lua → safe & clean
-- (you can delete the dofile line below if it's still there)
-- dofile(minetest.get_modpath("nativevillages") .. "/utils.lua")

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Normal grassland houses
-- ===================================================================
local function register_grassland_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},
        sidelen = 40,
        noise_params = village_noise,
        biomes = {"grassland"},
        y_min = 1,
        y_max = 110,

        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement",
        height = 1,
        height_max = 1,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",
    })
end

-- ===================================================================
-- Central / rare buildings (church, market, etc.)
-- ===================================================================
local function register_grassland_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},
        sidelen = 48,
        noise_params = central_noise,
        biomes = {"grassland"},
        y_min = 1,
        y_max = 110,

        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement",
        height = 1,
        height_max = 1,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL BUILDINGS
-- ===================================================================

-- Regular houses (grounded placement with place_offset_y = 0)
register_grassland_building({name = "grasslandhouse1", file = "grasslandhouse1_7_9_7.mts"})
register_grassland_building({name = "grasslandhouse2", file = "grasslandhouse2_6_7_7.mts"})
register_grassland_building({name = "grasslandhouse4", file = "grasslandhouse4_7_7_9.mts"})
register_grassland_building({name = "grasslandhouse5", file = "grasslandhouse5_6_6_6.mts"})

-- Central/rare buildings
register_grassland_central({name = "grasslandchurch",   file = "grasslandchurch_11_17_21.mts"})
register_grassland_central({name = "grasslandmarket",   file = "grasslandmarket_9_5_9.mts"})
register_grassland_central({name = "grasslandstable",   file = "grasslandstable_15_8_16.mts"})
register_grassland_central({name = "grasslandhouse3",   file = "grasslandhouse3_10_10_9.mts"})

