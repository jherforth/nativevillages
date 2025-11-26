-- village_noise.lua
-- ONE global village noise — makes villages truly rare worldwide

nativevillages = nativevillages or {}

-- This is the ONE AND ONLY village noise used by EVERY biome
nativevillages.global_village_noise = {
    offset = 0.0,
    scale = 0.0002,            -- ↓ EXTREMELY low = villages are RARE
    spread = {x = 500, y = 500, z = 500},   -- small, cozy villages
    seed = 987654321,
    octaves = 3,
    persistence = 0.5,
    lacunarity = 2.0,
    flags = "defaults",
}

-- Rarer central buildings (church/market/stable)
nativevillages.global_central_noise = table.copy(nativevillages.global_village_noise)
nativevillages.global_central_noise.scale = 0.00002   -- appear in ~1 out of 8 villages

-- Third noise just for paths that is very strongly correlated but not identical
nativevillages.global_path_noise = {
    offset = 0,
    scale = 0.0002,          -- same rarity as houses
    spread = {x = 500, y = 500, z = 500},
    seed = 987654321 + 1,   -- ← different seed so paths are offset a few meters from houses
    octaves = 3,
    persist = 0.5,
    lacunarity = 2.0,
}
