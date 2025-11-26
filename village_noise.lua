-- village_noise.lua
-- ONE global village noise — makes villages truly rare worldwide

nativevillages = nativevillages or {}

-- This is the ONE AND ONLY village noise used by EVERY biome
nativevillages.global_village_noise = {
    offset = 0.0,
    scale = 0.0001,            -- ↓ EXTREMELY low = villages are RARE
    spread = {x = 80, y = 80, z = 80},   -- small, cozy villages
    seed = 987654321,
    octaves = 3,
    persistence = 0.5,
    lacunarity = 2.0,
    flags = "defaults",
}

-- Rarer central buildings (church/market/stable)
nativevillages.global_central_noise = table.copy(nativevillages.global_village_noise)
nativevillages.global_central_noise.scale = 0.00003   -- appear in ~1 out of 8 villages

-- Third noise just for paths that is very strongly correlated but not identical
nativevillages.global_path_noise = {
    offset = 0,
    scale = 0.001,          -- same rarity as houses
    spread = {x = 80, y = 80, z = 80},
    seed = 987654321 + 12345,   -- ← different seed so paths are offset a few meters from houses
    octaves = 3,
    persist = 0.5,
    lacunarity = 2.0,
}
