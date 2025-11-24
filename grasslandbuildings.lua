local S = minetest.get_translator("nativevillages")

-- ===================================================================
-- GRASSLAND / FOREST VILLAGE CLUSTERING NOISE
-- Same noise for all houses → perfect village grouping
-- ===================================================================

local grassland_village_noise = {
    offset = 0.0,
    scale = 0.045,            -- Slightly higher than desert = more houses per village
    spread = {x = 160, y = 160, z = 160},  -- Bigger villages than desert
    seed = 3546891,          -- Unique seed (different from desert!)
    octaves = 3,
    persistence = 0.6,
    lacunarity = 2.0,
    flags = "defaults",
}

-- ===================================================================
-- Helper function (DRY — don't repeat yourself)
-- ===================================================================

local function register_grassland_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},
        sidelen = params.sidelen or 16,
        noise_params = grassland_village_noise,
        biomes = {"grassland", "snowy_grassland", "coniferous_forest", "deciduous_forest"},
        y_min = 1,
        y_max = 110,                    -- Higher than desert — forests go up to ~100
        height = 2,                     -- Grassland is flatter → we can demand flatter ground
        place_offset_y = params.offset_y or -1,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL GRASSLAND HOUSES
-- ===================================================================

register_grassland_building({ name = "grasslandhouse1", file = "grasslandhouse1_7_9_7.mts",   sidelen = 8 })
register_grassland_building({ name = "grasslandhouse2", file = "grasslandhouse2_6_7_7.mts",   sidelen = 8 })
register_grassland_building({ name = "grasslandhouse3", file = "grasslandhouse3_10_10_9.mts", sidelen = 16 })
register_grassland_building({ name = "grasslandhouse4", file = "grasslandhouse4_7_7_9.mts",   sidelen = 8 })
register_grassland_building({ name = "grasslandhouse5", file = "grasslandhouse5_6_6_6.mts",   sidelen = 8 })

-- ===================================================================
-- CENTRAL / RARER BUILDINGS (church, market, stable)
-- Use slightly lower density and offset seeds so they appear near village centers
-- ===================================================================

local central_noise = table.copy(grassland_village_noise)
central_noise.scale = 0.02  -- ~half as common as regular houses

local function register_central_grassland(params)
    local np = table.copy(central_noise)
    np.seed = np.seed + params.seed_offset
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_grass", "default:dirt_with_coniferous_litter"},
        sidelen = params.sidelen or 32,
        noise_params = np,
        biomes = {"grassland", "snowy_grassland", "coniferous_forest", "deciduous_forest"},
        y_min = 1,
        y_max = 110,
        height = 2,
        place_offset_y = params.offset_y or -1,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

register_central_grassland({
    name = "grasslandchurch",
    file = "grasslandchurch_11_17_21.mts",
    sidelen = 32,
    seed_offset = 2001,
    offset_y = -1,
})

register_central_grassland({
    name = "grasslandmarket",
    file = "grasslandmarket_9_5_9.mts",
    sidelen = 16,
    seed_offset = 2002,
})

register_central_grassland({
    name = "grasslandstable",
    file = "grasslandstable_15_8_16.mts",
    sidelen = 32,
    seed_offset = 2003,
    offset_y = -1,
})

