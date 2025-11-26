-- village_noise.lua
-- ONE global village noise — makes villages truly rare worldwide

nativevillages = nativevillages or {}

-- This is the ONE AND ONLY village noise used by EVERY biome
nativevillages.global_village_noise = {
    offset = 0.0,
    scale = 0.018,            -- ↓ EXTREMELY low = villages are RARE
    spread = {x = 120, y = 120, z = 120},   -- small, cozy villages
    seed = 987654321,
    octaves = 3,
    persistence = 0.5,
    lacunarity = 2.0,
    flags = "defaults",
}

-- Rarer central buildings (church/market/stable)
nativevillages.global_central_noise = table.copy(nativevillages.global_village_noise)
nativevillages.global_central_noise.scale = 0.003   -- appear in ~1 out of 8 villages
