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
        place_on = {"default:desert_sand","default:sand"},
        sidelen = 40,
        noise_params = village_noise,
        biomes = {"desert","mesa","everness:forsaken_desert"},
        y_min = 1,
        y_max = 50,

        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement, all_floors",
        height = 0,
        height_max = 0,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",

    })
end

-- ===================================================================
-- Central / big buildings (church, market, etc.)
-- ===================================================================
local function register_desert_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand","default:sand"},
        sidelen = 48,                          -- bigger grid for rare buildings
        noise_params = central_noise,
        biomes = {"desert","mesa","everness:forsaken_desert"},
        y_min = 0,
        y_max = 50,

        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement, all_floors",
        height = 0,
        height_max = 0,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
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


