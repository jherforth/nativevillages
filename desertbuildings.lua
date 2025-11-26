local S = minetest.get_translator("nativevillages")

-- Load the shared fill-under function map gen helper
dofile(minetest.get_modpath("nativevillages") .. "/utils.lua")

-- ===================================================================
-- DESERT VILLAGE CLUSTERING NOISE
-- One shared noise = all buildings appear in the same village spots
-- ===================================================================

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Helper function so we don't repeat the same 20 lines 8 times
-- ===================================================================

local function register_desert_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand"},
        sidelen = 40,
        noise_params = village_noise,
        biomes = {"desert"},
        y_min = 1,
        y_max = 50,
        height = 1,
        height_max = 3,
        place_offset_y = params.offset_y or 0,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z,
        rotation = "random",
        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,
    })
end

-- ===================================================================
-- REGISTER ALL DESERT BUILDINGS
-- ===================================================================

register_desert_building({name = "deserthouse1", file = "deserthouse1_12_14_9.mts", offset_y = -1 })
register_desert_building({name = "deserthouse2", file = "deserthouse2_8_7_8.mts" })
register_desert_building({name = "deserthouse3", file = "deserthouse3_8_10_8.mts" })
register_desert_building({name = "deserthouse4", file = "deserthouse4_10_8_7.mts" })
register_desert_building({name = "deserthouse5", file = "deserthouse5_10_6_8.mts" })

-- ===================================================================
-- CENTRAL / RARER BUILDINGS — use the global central noise
-- ===================================================================

local function register_desert_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand"},
        sidelen = 32,
        noise_params = central_noise,
        biomes = {"desert"},
        y_min = 0,
        y_max = 50,
        height = 1,
        height_max = 3,
        place_offset_y = params.offset_y or 0,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z,
        rotation = "random",
        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,
    })
end

register_desert_central({name = "desertchurch", file = "desertchurch_9_12_16.mts", offset_y = 0})
register_desert_central({name = "desertmarket", file = "desertmarket_12_16_13.mts", offset_y = 0})
register_desert_central({name = "desertstable",file = "desertstable_13_6_9.mts", offset_y = 0})
















