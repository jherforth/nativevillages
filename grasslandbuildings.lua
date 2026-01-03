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
        y_max = 2010,

        place_offset_y = -6,
        flags = "place_center_x, place_center_z, force_placement, all_floors",

        -- Check height across ENTIRE schematic footprint (not just center)
        height = 0,
        height_max = 0,

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
        y_max = 2010,

        place_offset_y = -6,
        flags = "place_center_x, place_center_z, force_placement, all_floors",

        -- Check height across ENTIRE schematic footprint (not just center)
        height = 0,
        height_max = 0,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL BUILDINGS
-- ===================================================================

-- Regular houses (grounded placement with place_offset_y = 0)
register_grassland_building({name = "grasslandhouse1", file = "grasslandhouse1.mts"})
register_grassland_building({name = "grasslandhouse2", file = "grasslandhouse2.mts"})
register_grassland_building({name = "grasslandhouse3", file = "grasslandhouse3.mts"})
register_grassland_building({name = "grasslandhouse4", file = "grasslandhouse4.mts"})

-- Central/rare buildings
register_grassland_central({name = "grasslandchurch",   file = "grasslandchurch.mts"})
register_grassland_central({name = "grasslandmarket",   file = "grasslandmarket.mts"})
register_grassland_central({name = "grasslandstable",   file = "grasslandstable.mts"})





