local S = minetest.get_translator("nativevillages")

-- ===================================================================
-- SAVANNA VILLAGE CLUSTERING NOISE
-- Large, proud villages with plenty of breathing room
-- ===================================================================

local savanna_village_noise = {
    offset = 0.0,
    scale = 0.005,                 -- Perfect balance: common enough, never overcrowded
    spread = {x = 180, y = 180, z = 180},  -- Big, impressive villages
    seed = 67239184,               -- Unique seed
    octaves = 3,
    persistence = 0.62,
    lacunarity = 2.0,
    flags = "defaults",
}

-- ===================================================================
-- Helper: regular savanna houses
-- ===================================================================

local function register_savanna_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dry_dirt_with_dry_grass"},
        sidelen = params.sidelen or 8,
        noise_params = savanna_village_noise,
        biomes = {"savanna"},
        y_min = 1,
        y_max = 120,                   -- Savanna can go high
        height = 2,                    -- Allows gentle savanna hills
        place_offset_y = params.offset_y or -1,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL SAVANNA HOUSES
-- ===================================================================

register_savanna_building({ name = "savannahouse1", file = "savannahouse1_7_9_7.mts",   sidelen = 8 })
register_savanna_building({ name = "savannahouse2", file = "savannahouse2_9_8_9.mts",   sidelen = 8 })
register_savanna_building({ name = "savannahouse3", file = "savannahouse3_7_5_8.mts",   sidelen = 8 })
register_savanna_building({ name = "savannahouse4", file = "savannahouse4_7_9_9.mts",   sidelen = 8 })
register_savanna_building({ name = "savannahouse5", file = "savannahouse5_7_6_7.mts",   sidelen = 8 })

-- ===================================================================
-- CENTRAL / RARER BUILDINGS (church, market, stable)
-- Lower density + offset seeds → appear near village center
-- ===================================================================

local savanna_central_noise = table.copy(savanna_village_noise)
savanna_central_noise.scale = 0.0003  -- Rarer, more majestic

local function register_savanna_central(params)
    local np = table.copy(savanna_central_noise)
    np.seed = np.seed + params.seed_offset
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dry_dirt_with_dry_grass"},
        sidelen = params.sidelen or 32,
        noise_params = np,
        biomes = {"savanna"},
        y_min = 1,
        y_max = 120,
        height = 2,
        place_offset_y = params.offset_y or -1,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

register_savanna_central({ name = "savannachurch",  file = "savannachurch_8_11_12.mts",   seed_offset = 5001, sidelen = 16 })
register_savanna_central({ name = "savannamarket",  file = "savannamarket_10_5_9.mts",    seed_offset = 5002, sidelen = 16 })
register_savanna_central({ name = "savannastable",  file = "savannastable_15_7_16.mts",  seed_offset = 5003, sidelen = 32, offset_y = -1 })


