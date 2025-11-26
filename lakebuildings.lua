local S = minetest.get_translator("nativevillages")

-- ===================================================================
-- LAKE / STILT VILLAGE NOISE
-- Elongated clusters that naturally follow coastlines
-- ===================================================================

local village_noise = nativevillages.global_village_noise
local central_noise = nativevillages.global_central_noise

-- ===================================================================
-- Helper: regular lake houses
-- ===================================================================

local function register_lake_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt", "default:sand"},
        sidelen = 16,
        noise_params = village_noise,
        biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
        y_min = -1,
        y_max = 3,                     -- Must be right at water level
        height = 1,                    -- Extremely flat only (stilt houses!)
        place_offset_y = params.offset_y or 1,  -- Most lake schematics have stilts
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL LAKE HOUSES
-- ===================================================================

register_lake_building({ name = "lakehouse1", file = "lakehouse1_12_11_15.mts", sidelen = 16, offset_y = 2 })
register_lake_building({ name = "lakehouse2", file = "lakehouse2_6_8_8.mts",     sidelen = 16,  offset_y = 2 })
register_lake_building({ name = "lakehouse3", file = "lakehouse3_5_9_9.mts",     sidelen = 16,  offset_y = 2 })
register_lake_building({ name = "lakehouse4", file = "lakehouse4_5_9_9.mts",     sidelen = 16,  offset_y = 2 })
register_lake_building({ name = "lakehouse5", file = "lakehouse5_6_11_10.mts",   sidelen = 16,  offset_y = 2 })

-- ===================================================================
-- CENTRAL / RARER BUILDINGS (church, market, stable)
-- Lower density + offset seeds → appear at the "heart" of each hamlet
-- ===================================================================

local lake_central_noise = table.copy(lake_village_noise)
lake_central_noise.scale = 0.0003   -- Rarer than houses

local function register_lake_central(params)
    local np = table.copy(lake_central_noise)
    np.seed = np.seed + params.seed_offset
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt", "default:sand"},
        sidelen = params.sidelen or 16,
        noise_params = central_noise,
        biomes = {"deciduous_forest_ocean", "deciduous_forest_shore", "coniferous_forest_ocean"},
        y_min = -1,
        y_max = 3,
        height = 1,
        place_offset_y = params.offset_y or 1,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

register_lake_central({ name = "lakechurch",  file = "lakechurch_9_13_13.mts",   seed_offset = 4001, sidelen = 16, offset_y = 2 })
register_lake_central({ name = "lakemarket",  file = "lakemarket_7_6_10.mts",    seed_offset = 4002, sidelen = 16, offset_y = 1 })
register_lake_central({ name = "lakestable",  file = "lakestable_7_7_13.mts",    seed_offset = 4003, sidelen = 16, offset_y = 1 })




