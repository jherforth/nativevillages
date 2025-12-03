local S = minetest.get_translator("nativevillages")

-- utils.lua is loaded only in init.lua → no need here
-- (delete the dofile line if still present)

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Regular ice houses
-- ===================================================================
local function register_ice_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:snowblock", "default:ice"},
        sidelen = 24,                       -- consistent with desert/grassland
        noise_params = village_noise,
        biomes = {"icesheet", "icesheet_ocean"},  -- also allows coastal ice villages
        y_min = -7,
        y_max = 40,

        -- THE THREE MAGIC LINES (identical to every other biome)
        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement, all_floors",
        height = 0,
        height_max = 0,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",
    })
end

-- ===================================================================
-- Central / rare ice buildings
-- ===================================================================
local function register_ice_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:snowblock", "default:ice"},
        sidelen = 32,                       -- slightly larger grid for rare buildings
        noise_params = central_noise,
        biomes = {"icesheet", "icesheet_ocean"},
        y_min = -2,
        y_max = 40,

        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement, all_floors",
        height = 0,
        height_max = 0,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL ICE BUILDINGS
-- ===================================================================

-- Regular houses
register_ice_building({name = "icehouse1", file = "icehouse1_7_9_7.mts"})
register_ice_building({name = "icehouse2", file = "icehouse2_7_7_9.mts"})
register_ice_building({name = "icehouse3", file = "icehouse3_6_6_6.mts"})
register_ice_building({name = "icehouse4", file = "icehouse4_6_7_7.mts"})

-- Central / rare buildings
register_ice_central({name = "icechurch",  file = "icechurch_7_11_10.mts"})
register_ice_central({name = "icemarket",  file = "icemarket_10_5_9.mts"})
register_ice_central({name = "icestable",  file = "icestable_9_5_7.mts"})




