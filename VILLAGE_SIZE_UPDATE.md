# Village Size Update - Quick Summary

## Problem
Villages were spawning as massive sprawling cities, often 300+ nodes across and merging with neighboring villages.

## Solution
Reduced noise spread parameters to constrain villages to 1-2 mapchunks (80-160 nodes).

## Changes

### village_noise.lua
```lua
# BEFORE
spread = {x = 300, y = 300, z = 300}
persistence = 0.6

# AFTER
spread = {x = 100, y = 100, z = 100}   # 66% reduction
persistence = 0.5                       # More compact
```

Also updated:
- Central building spread: 400 → 120
- Path noise spread: 300 → 100

## Results
- Villages now fit in 1-2 mapchunks (approximately 80-160 nodes across)
- Clear separation between villages
- Compact, organized layouts
- Better performance
- Perfect distribution maintained, just more tightly clustered

## User Configuration

Edit `village_noise.lua` to adjust village size:

**Single Mapchunk (80 nodes):**
```lua
spread = {x = 80, y = 80, z = 80}
persistence = 0.4
```

**Current (1-2 mapchunks, 100-160 nodes) - DEFAULT:**
```lua
spread = {x = 100, y = 100, z = 100}
persistence = 0.5
```

**Larger (2-3 mapchunks, 160-240 nodes):**
```lua
spread = {x = 150, y = 150, z = 150}
persistence = 0.5
```

**Original Large (300+ nodes):**
```lua
spread = {x = 300, y = 300, z = 300}
persistence = 0.6
```

## Notes
- Only affects newly generated chunks
- Existing villages remain unchanged
- No code changes required, just parameter tuning
- Works with all biomes (grassland, desert, ice, lake, savanna, jungle)

## Mapchunk Reference
- Mapchunk = 5x5x5 mapblocks = 80x80x80 nodes
- Previous village size: ~4+ mapchunks
- New village size: 1-2 mapchunks
