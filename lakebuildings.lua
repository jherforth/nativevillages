local S = minetest.get_translator("nativevillages")

-- utils.lua loaded only in init.lua → clean

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Regular lake stilt houses
-- ===================================================================
local function register_lake_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt", "default:sand", "default:clay"},
        sidelen = 48,                            -- lake shores are narrow → give more space to find flat spots
        noise_params = village_noise,
        biomes = {
            "deciduous_forest_shore",
            "coniferous_forest_ocean"
        },
        y_min = -2,
        y_max = 4,                               -- must be right at water level

        place_offset_y = 1,
        flags = "place_center_x, place_center_z, force_placement",
        height = 1,
        height_max = 2,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",

        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,
    })
end

-- ===================================================================
-- Central / rare lake buildings (church on water, big market platform, etc.)
-- ===================================================================
local function register_lake_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt", "default:sand", "default:clay"},
        sidelen = 64,                            -- ultra-rare water temples
        noise_params = central_noise,
        biomes = {
            "deciduous_forest_shore",
            "coniferous_forest_shore"
        },
        y_min = -2,
        y_max = 4,

        place_offset_y = 1,
        flags = "place_center_x, place_center_z, force_placement",
        height = 1,
        height_max = 2,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",

        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,
    })
end

-- ===================================================================
-- REGISTER ALL LAKE STRUCTURES
-- ===================================================================

-- Regular stilt houses
register_lake_building({name = "lakehouse1", file = "lakehouse1_12_11_15.mts"})
register_lake_building({name = "lakehouse2", file = "lakehouse2_6_8_8.mts"})
register_lake_building({name = "lakehouse3", file = "lakehouse3_5_9_9.mts"})
register_lake_building({name = "lakehouse4", file = "lakehouse4_5_9_9.mts"})
register_lake_building({name = "lakehouse5", file = "lakehouse5_6_11_10.mts"})

-- Central / epic water buildings
register_lake_central({name = "lakechurch", file = "lakechurch_9_13_13.mts"})
register_lake_central({name = "lakemarket", file = "lakemarket_7_6_10.mts"})
register_lake_central({name = "lakestable", file = "lakestable_7_7_13.mts"})

