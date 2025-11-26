local S = minetest.get_translator("nativevillages")

-- utils.lua loaded only in init.lua → clean and safe

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Regular savanna houses
-- ===================================================================
local function register_savanna_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dry_dirt_with_dry_grass"},
        sidelen = 40,                          -- consistent with all other biomes
        noise_params = village_noise,
        biomes = {"savanna"},
        y_min = 1,
        y_max = 140,                           -- savannas can climb high!

        -- THE THREE FINAL MAGIC LINES — savanna edition
        place_offset_y = 1,                    -- sits perfectly on dry grass
        flags = "place_center_x, place_center_z",  -- NO force_placement
        height = 1,
        height_max = 4,                        -- savanna has rolling hills → allow gentle slopes

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",

        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,
    })
end

-- ===================================================================
-- Central / epic savanna buildings (big church, market, chief's hut)
-- ===================================================================
local function register_savanna_central(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dry_dirt_with_dry_grass"},
        sidelen = 48,                          -- rare, proud structures
        noise_params = central_noise,
        biomes = {"savanna"},
        y_min = 1,
        y_max = 140,

        place_offset_y = 1,
        flags = "place_center_x, place_center_z",
        height = 1,
        height_max = 4,

        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        rotation = "random",

        on_placed = function(pos)
            nativevillages.fill_under_house(pos, params.file)
        end,
    })
end

-- ===================================================================
-- REGISTER ALL SAVANNA STRUCTURES
-- ===================================================================

-- Regular houses
register_savanna_building({name = "savannahouse1", file = "savannahouse1_7_9_7.mts"})
register_savanna_building({name = "savannahouse2", file = "savannahouse2_9_8_9.mts"})
register_savanna_building({name = "savannahouse3", file = "savannahouse3_7_5_8.mts"})
register_savanna_building({name = "savannahouse4", file = "savannahouse4_7_9_9.mts"})
register_savanna_building({name = "savannahouse5", file = "savannahouse5_7_6_7.mts"})

-- Central / epic buildings
register_savanna_central({name = "savannachurch", file = "savannachurch_8_11_12.mts"})
register_savanna_central({name = "savannamarket", file = "savannamarket_10_5_9.mts"})
register_savanna_central({name = "savannastable", file = "savannastable_15_7_16.mts"})
