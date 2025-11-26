local S = minetest.get_translator("nativevillages")

-- Load utils once (init.lua already does this — you can delete this line if you want)
-- dofile(minetest.get_modpath("nativevillages") .. "/utils.lua")

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Normal houses
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

        -- THESE THREE LINES ARE THE MAGIC
        place_offset_y = 1,                    -- house sits ON the ground, never inside
        flags = "place_center_x, place_center_z",  -- NO force_placement!
        height = 1,
        height_max = 3,                        -- allows gentle dunes, rejects cliffs

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",

        -- Fill any tiny gaps under the house
        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,
    })
end

-- ===================================================================
-- Central / big buildings (church, market, etc.)
-- ===================================================================
local function register_desert_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand"},
        sidelen = 48,                          -- bigger grid for rare buildings
        noise_params = central_noise,
        biomes = {"desert"},
        y_min = 0,
        y_max = 50,

        place_offset_y = 1,                    -- same rule: sit ON the ground
        flags = "place_center_x, place_center_z",
        height = 1,
        height_max = 3,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",

        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,
    })
end

-- ===================================================================
-- REGISTER EVERYTHING
-- ===================================================================

register_desert_building({name = "deserthouse1", file = "deserthouse1_12_14_9.mts"})
register_desert_building({name = "deserthouse2", file = "deserthouse2_8_7_8.mts"})
register_desert_building({name = "deserthouse3", file = "deserthouse3_8_10_8.mts"})
register_desert_building({name = "deserthouse4", file = "deserthouse4_10_8_7.mts"})
register_desert_building({name = "deserthouse5", file = "deserthouse5_10_6_8.mts"})

register_desert_central({name = "desertchurch",  file = "desertchurch_9_12_16.mts"})
register_desert_central({name = "desertmarket",  file = "desertmarket_12_16_13.mts"})
register_desert_central({name = "desertstable",  file = "desertstable_13_6_9.mts"})
