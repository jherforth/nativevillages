# Village Size Limits

## Overview

Villages have been constrained to fit within 1-2 mapchunks (80-160 nodes across) instead of sprawling into massive cities.

## What Changed

### Noise Parameters (village_noise.lua)

**Before:**
- `spread = {x = 300, y = 300, z = 300}` - Created villages 300+ nodes across
- `persistence = 0.6` - More variation at different scales
- Central building spread: `400x400x400`

**After:**
- `spread = {x = 100, y = 100, z = 100}` - Creates villages ~100-160 nodes across
- `persistence = 0.5` - Less variation, more compact clusters
- Central building spread: `120x120x120` - Keeps central buildings within village

## Technical Details

### Mapchunk Reference
- **Mapchunk**: 5x5x5 mapblocks = 80x80x80 nodes
- **Village Size**: Now fits in 1-2 mapchunks (80-160 nodes)
- **Previous Size**: 300+ nodes (4+ mapchunks)

### How Noise Spread Works

The `spread` parameter in Minetest's noise controls how "zoomed in" or "zoomed out" the noise pattern is:

- **Smaller spread (e.g., 100)** = More "zoomed in" = Tighter clusters = Smaller villages
- **Larger spread (e.g., 300)** = More "zoomed out" = Wider distribution = Larger villages

### Persistence Impact

The `persistence` parameter controls how much each octave contributes:

- **Lower persistence (0.5)** = Smoother transitions, less detail at small scales = More compact
- **Higher persistence (0.6-0.8)** = More detail at all scales = More scattered

## Configuration Guide

To adjust village size further, edit `village_noise.lua`:

### For Single-Mapchunk Villages (80 nodes)
```lua
spread = {x = 80, y = 80, z = 80}
persistence = 0.4
```

### For Current Size (1-2 mapchunks, 100-160 nodes)
```lua
spread = {x = 100, y = 100, z = 100}  -- Current setting
persistence = 0.5                     -- Current setting
```

### For Slightly Larger Villages (2-3 mapchunks, 160-240 nodes)
```lua
spread = {x = 150, y = 150, z = 150}
persistence = 0.5
```

### For Original Large Villages (300+ nodes)
```lua
spread = {x = 300, y = 300, z = 300}
persistence = 0.6
```

## Building Density

The `scale` parameter controls how many buildings spawn:

- **Current value**: `0.001` - Balanced density
- **More buildings**: Increase to `0.002` or `0.005`
- **Fewer buildings**: Decrease to `0.0005`

## Central Buildings

Churches, markets, and stables use separate noise with:
- `scale = 0.0001` - Very rare (1 in ~10 villages)
- `spread = {x = 120, y = 120, z = 120}` - Matches village size

This ensures central buildings only spawn in established villages, not randomly.

## Results

**Before:**
- Villages sprawled across 300-400+ nodes
- Often merged into neighboring villages
- Performance impact from large village areas

**After:**
- Villages are compact, fitting in 1-2 mapchunks
- Clear separation between villages
- Better distribution of building placement
- Improved performance

## Testing

To see the changes:
1. Generate new world chunks (villages in existing chunks won't change)
2. Look for villages in grassland, desert, ice, lake, savanna, or jungle biomes
3. Villages should be noticeably smaller and more compact
4. Buildings should cluster tightly together

## Files Modified

- `village_noise.lua` - Updated noise parameters for all biomes

## Compatibility

This change only affects newly generated chunks. Existing villages in already-generated chunks will remain at their current size.
