local S = minetest.get_translator("lualore")

-- Load utils once (init.lua already does this — you can delete this line if you want)
-- dofile(minetest.get_modpath("lualore") .. "/utils.lua")

local village_noise = lualore.global_village_noise
local central_noise = lualore.global_central_noise

-- ===================================================================
-- Normal houses
-- ===================================================================
local function register_desert_building(params)
    minetest.register_decoration({
        name = "lualore:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand","default:sand"},
        sidelen = 50,
        noise_params = village_noise,
        biomes = {"desert","mesa","everness:forsaken_desert"},
        y_min = 1,
        y_max = 2050,

        place_offset_y = -6,
        flags = "place_center_x, place_center_z, force_placement, all_floors",
        height = 0,
        height_max = 0,

        schematic = minetest.get_modpath("lualore") .. "/schematics/" .. params.file,
        rotation = "random",

    })
end

-- ===================================================================
-- Central / big buildings (church, market, etc.)
-- ===================================================================
local function register_desert_central(params)
    minetest.register_decoration({
        name = "lualore:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand","default:sand"},
        sidelen = 58,                          -- bigger grid for rare buildings
        noise_params = central_noise,
        biomes = {"desert","mesa","everness:forsaken_desert"},
        y_min = 0,
        y_max = 2050,

        place_offset_y = -6,
        flags = "place_center_x, place_center_z, force_placement, all_floors",
        height = 0,
        height_max = 0,

        schematic = minetest.get_modpath("lualore") .. "/schematics/" .. params.file,
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER EVERYTHING
-- ===================================================================

register_desert_building({name = "deserthouse1", file = "deserthouse1.mts"})
register_desert_building({name = "deserthouse2", file = "deserthouse2.mts"})
register_desert_building({name = "deserthouse3", file = "deserthouse3.mts"})
register_desert_building({name = "deserthouse4", file = "deserthouse4.mts"})

register_desert_central({name = "desertchurch",  file = "desertchurch.mts"})
register_desert_central({name = "desertmarket",  file = "desertmarket.mts"})
register_desert_central({name = "desertstable",  file = "desertstable.mts"})




