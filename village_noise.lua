-- village_noise.lua
-- ONE global village noise — makes villages truly rare worldwide

nativevillages = nativevillages or {}

-- This is the ONE AND ONLY village noise used by EVERY biome
-- Optimized for compact, cohesive villages with grid layout
nativevillages.global_village_noise = {
    offset = 0.0,
    scale = 0.001,            -- Increased for better building clustering
    spread = {x = 300, y = 300, z = 300},   -- Tighter spread = more compact villages
    seed = 987654321,
    octaves = 2,              -- Reduced octaves = smoother, more predictable areas
    persistence = 0.6,
    lacunarity = 2.0,
    flags = "defaults",
}

-- Rarer central buildings (church/market/stable)
nativevillages.global_central_noise = table.copy(nativevillages.global_village_noise)
nativevillages.global_central_noise.scale = 0.0001   -- appear in ~1 out of 10 villages
nativevillages.global_central_noise.spread = {x = 400, y = 400, z = 400}

-- Path noise - slightly different seed for variation but similar scale
nativevillages.global_path_noise = {
    offset = 0,
    scale = 0.001,
    spread = {x = 300, y = 300, z = 300},
    seed = 987654322,        -- Different seed for slight offset
    octaves = 2,
    persistence = 0.6,
    lacunarity = 2.0,
    flags = "defaults",
}
