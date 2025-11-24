local S = minetest.get_translator("nativevillages")

-- ===================================================================
-- JUNGLE TREEHOUSE VILLAGE NOISE
-- Very rare, very small, perfectly flat clearings only
-- ===================================================================

local jungle_village_noise = {
    offset = 0.0,
    scale = 0.05,                  -- High density BUT only in tiny zones
    spread = {x = 80, y = 80, z = 80},   -- Tiny clusters → 3–10 buildings max
    seed = 48192756,               -- Unique seed (you'll remember this one)
    octaves = 4,
    persistence = 0.4,
    lacunarity = 2.4,
    flags = "defaults",
}

-- ===================================================================
-- Helper: regular jungle treehouses
-- ===================================================================

local function register_jungle_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_rainforest_litter"},
        sidelen = params.sidelen or 8,
        noise_params = jungle_village_noise,
        biomes = {"rainforest"},
        y_min = 4,
        y_max = 80,                    -- Jungles are tall!
        height = 1,                    -- ONLY perfectly flat clearings (absolutely required)
        place_offset_y = params.offset_y or 0,  -- Your treehouses already have massive stilts
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

-- ===================================================================
-- REGISTER ALL JUNGLE TREEHOUSES
-- ===================================================================

register_jungle_building({ name = "junglehouse1", file = "junglehouse1_7_26_7.mts",   offset_y = 0 })
register_jungle_building({ name = "junglehouse2", file = "junglehouse2_7_25_7.mts",   offset_y = 0 })
register_jungle_building({ name = "junglehouse3", file = "junglehouse3_7_25_7.mts",   offset_y = 0 })
register_jungle_building({ name = "junglehouse4", file = "junglehouse4_7_26_7.mts",   offset_y = 0 })
register_jungle_building({ name = "junglehouse5", file = "junglehouse5_7_28_7.mts",   offset_y = 0 })
register_jungle_building({ name = "junglestable", file = "junglestable_7_25_7.mts",   offset_y = 0 })

-- ===================================================================
-- CENTRAL / RARER BUILDINGS
-- Even rarer — these are legendary lost temples in the jungle
-- ===================================================================

local jungle_central_noise = table.copy(jungle_village_noise)
jungle_central_noise.scale = 0.02   -- Extremely rare
jungle_central_noise.spread = {x = 100, y = 100, z = 100}

local function register_jungle_central(params)
    local np = table.copy(jungle_central_noise)
    np.seed = np.seed + params.seed_offset
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:dirt_with_rainforest_litter"},
        sidelen = params.sidelen or 16,
        noise_params = np,
        biomes = {"rainforest"},
        y_min = 4,
        y_max = 80,
        height = 1,
        place_offset_y = params.offset_y or 0,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

register_jungle_central({ name = "junglechurch", file = "junglechurch_7_28_7.mts", seed_offset = 6001, sidelen = 16 })
register_jungle_central({ name = "junglemarket", file = "junglemarket_9_32_9.mts", seed_offset = 6002, sidelen = 16 })

