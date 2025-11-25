local S = minetest.get_translator("nativevillages")

-- ===================================================================
-- ICE VILLAGE CLUSTERING NOISE
-- Tighter, more frequent villages than grassland — fits arctic theme
-- ===================================================================

local ice_village_noise = {
    offset = 0.0,
    scale = 0.025,               -- High density inside villages (ice villages are compact)
    spread = {x = 80, y = 80, z = 80},  -- Smaller village footprint than grassland
    seed = 91927465,            -- Unique seed
    octaves = 3,
    persistence = 0.5,
    lacunarity = 2.0,
    flags = "defaults",
}

-- ===================================================================
-- Helper: regular ice houses
-- ===================================================================

local function register_ice_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:snowblock", "default:ice"},
        sidelen = params.sidelen or 8,
        noise_params = ice_village_noise,
        biomes = {"icesheet", "icesheet_ocean"},
        y_min = 0,        -- Allow slight underwater ice shelf placement
        y_max = 40,
        height = 1,         -- Ice is perfectly flat → demand perfection
        place_offset_y = params.offset_y or 0,  -- Most ice schematics sit directly on surface
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL ICE HOUSES
-- ===================================================================

register_ice_building({ name = "icehouse1", file = "icehouse1_7_9_7.mts",   sidelen = 8, offset_y = 0 })
register_ice_building({ name = "icehouse2", file = "icehouse2_7_7_9.mts",   sidelen = 8 })
register_ice_building({ name = "icehouse3", file = "icehouse3_6_6_6.mts",   sidelen = 8 })
register_ice_building({ name = "icehouse4", file = "icehouse4_6_7_7.mts",   sidelen = 8 })
register_ice_building({ name = "icehouse5", file = "icehouse5_7_4_7.mts",   sidelen = 8 })

-- ===================================================================
-- CENTRAL / RARER BUILDINGS (church, market, stable)
-- Slightly lower density + offset seeds → appear near village centers
-- ===================================================================

local ice_central_noise = table.copy(ice_village_noise)
ice_central_noise.scale = 0.01  -- ~half as common

local function register_ice_central(params)
    local np = table.copy(ice_central_noise)
    np.seed = np.seed + params.seed_offset
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:snowblock", "default:ice"},
        sidelen = params.sidelen or 16,
        noise_params = np,
        biomes = {"icesheet", "icesheet_ocean"},
        y_min = 0,
        y_max = 40,
        height = 1,
        place_offset_y = params.offset_y or 0,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

register_ice_central({ name = "icechurch",  file = "icechurch_7_11_10.mts",  seed_offset = 3001, sidelen = 16 })
register_ice_central({ name = "icemarket",  file = "icemarket_10_5_9.mts",   seed_offset = 3002, sidelen = 16 })
register_ice_central({ name = "icestable",  file = "icestable_9_5_7.mts",    seed_offset = 3003, sidelen = 16 })



