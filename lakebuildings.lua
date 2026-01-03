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
        sidelen = 58,                            -- lake shores are narrow → give more space to find flat spots
        noise_params = village_noise,
        biomes = {
            "deciduous_forest_shore",
            "coniferous_forest_ocean"
        },
        y_min = -2,
        y_max = 4,                               -- must be right at water level

        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement, all_floors",
        height = 0,
        height_max = 0,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",
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
        sidelen = 74,                            -- ultra-rare water temples
        noise_params = central_noise,
        biomes = {
            "deciduous_forest_shore",
            "coniferous_forest_shore"
        },
        y_min = -2,
        y_max = 4,

        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement, all_floors",
        height = 0,
        height_max = 0,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL LAKE STRUCTURES
-- ===================================================================

-- Regular stilt houses
register_lake_building({name = "lakehouse1", file = "lakehouse1.mts"})
register_lake_building({name = "lakehouse2", file = "lakehouse2.mts"})
register_lake_building({name = "lakehouse3", file = "lakehouse3.mts"})
register_lake_building({name = "lakehouse4", file = "lakehouse4.mts"})

-- Central / epic water buildings
register_lake_central({name = "lakechurch", file = "lakechurch.mts"})
register_lake_central({name = "lakemarket", file = "lakemarket.mts"})
register_lake_central({name = "lakestable", file = "lakestable.mts"})


