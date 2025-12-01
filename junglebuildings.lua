local S = minetest.get_translator("nativevillages")

-- utils.lua loaded in init.lua only → clean & safe

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Regular jungle treehouses (stilts already built into schematic)
-- ===================================================================
local function register_jungle_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_rainforest_litter"},
        sidelen = 48,                          -- jungle clearings are rare → give more space to find flat ones
        noise_params = village_noise,
        biomes = {"rainforest", "rainforest_swamp"},
        y_min = 4,
        y_max = 100,                           -- jungles go high!

        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement",
        height = 1,
        height_max = 2,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",
    })
end

-- ===================================================================
-- Central / legendary jungle buildings (temples, big platforms, etc.)
-- ===================================================================
local function register_jungle_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_rainforest_litter"},
        sidelen = 64,                          -- ultra-rare legendary structures
        noise_params = central_noise,
        biomes = {"rainforest", "rainforest_swamp"},
        y_min = 4,
        y_max = 100,

        place_offset_y = 0,
        flags = "place_center_x, place_center_z, force_placement",
        height = 1,
        height_max = 2,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL JUNGLE STRUCTURES
-- ===================================================================

-- Regular treehouses (all have built-in stilts → no offset needed)
register_jungle_building({name = "junglehouse1",   file = "junglehouse1_7_26_7.mts"})
register_jungle_building({name = "junglehouse2",   file = "junglehouse2_7_25_7.mts"})
register_jungle_building({name = "junglehouse3",   file = "junglehouse3_7_25_7.mts"})
register_jungle_building({name = "junglehouse4",   file = "junglehouse4_7_26_7.mts"})
register_jungle_building({name = "junglehouse5",   file = "junglehouse5_7_28_7.mts"})
register_jungle_building({name = "junglestable",   file = "junglestable_7_25_7.mts"})

-- Legendary central structures
register_jungle_central({name = "junglechurch",    file = "junglechurch_7_28_7.mts"})
register_jungle_central({name = "junglemarket",    file = "junglemarket_9_32_9.mts"})
