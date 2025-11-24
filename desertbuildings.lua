local S = minetest.get_translator("nativevillages")

-- ===================================================================
-- DESERT VILLAGE CLUSTERING NOISE
-- One shared noise = all buildings appear in the same village spots
-- ===================================================================

local desert_village_noise = {
    offset = 0.0,
    scale = 0.035,          -- Controls village density inside clusters
    spread = {x = 140, y = 140, z = 140},  -- Village size & spacing
    seed = 22847392,        -- Change this number if you want different layout
    octaves = 3,
    persistence = 0.55,
    lacunarity = 2.0,
    flags = "defaults",
}

-- ===================================================================
-- Helper function so we don't repeat the same 20 lines 8 times
-- ===================================================================

local function register_desert_building(params)
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand", "default:sand"},
        sidelen = params.sidelen or 16,
        noise_params = desert_village_noise,
        biomes = {"desert", "sandstone_desert"},
        y_min = 1,
        y_max = 50,

        -- Only place on relatively flat ground (max 3 nodes height difference)
        height = 3,

        place_offset_y = params.offset_y or -1,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",

        -- Slight random offset so buildings of same type don't stack perfectly
        -- (optional but looks more natural)
        param2 = params.param2 or 0,
    })
end

-- ===================================================================
-- REGISTER ALL DESERT BUILDINGS
-- ===================================================================

register_desert_building({
    name = "deserthouse1",
    file = "deserthouse1_12_14_9.mts",
    sidelen = 16,
    offset_y = -1,
})

register_desert_building({
    name = "deserthouse2",
    file = "deserthouse2_8_7_8.mts",
    sidelen = 8,
})

register_desert_building({
    name = "deserthouse3",
    file = "deserthouse3_8_10_8.mts",
    sidelen = 8,
})

register_desert_building({
    name = "deserthouse4",
    file = "deserthouse4_10_8_7.mts",
    sidelen = 8,
})

register_desert_building({
    name = "deserthouse5",
    file = "deserthouse5_10_6_8.mts",
    sidelen = 8,
})

-- Larger/rarer central buildings — slightly lower density by reducing scale just for them
local central_noise = table.copy(desert_village_noise)
central_noise.scale = 0.015  -- about half as common as houses

local function register_central_building(params)
    local np = table.copy(central_noise)
    np.seed = np.seed + params.seed_offset  -- different seed = slightly different centers
    minetest.register_decoration({
        name = "nativevillages:" .. params.name,
        deco_type = "schematic",
        place_on = {"default:desert_sand", "default:sand"},
        sidelen = 16,
        noise_params = np,
        biomes = {"desert", "sandstone_desert"},
        y_min = 1,
        y_max = 50,
        height = 3,
        place_offset_y = params.offset_y or -1,
        schematic = minetest.get_modpath("nativevillages") .. "/schematics/" .. params.file,
        flags = "place_center_x, place_center_z, force_placement",
        rotation = "random",
    })
end

register_central_building({
    name = "desertchurch",
    file = "desertchurch_9_12_16.mts",
    seed_offset = 1001,
    offset_y = -1,
})

register_central_building({
    name = "desertmarket",
    file = "desertmarket_12_16_13.mts",
    seed_offset = 1002,
    offset_y = -2,
})

register_central_building({
    name = "desertstable",
    file = "desertstable_13_6_9.mts",
    seed_offset = 1003,
})

