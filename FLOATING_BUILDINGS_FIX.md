# Floating Buildings Fix

## Problem
Buildings were spawning above the ground with visible air gaps underneath, creating an unrealistic floating appearance.

## Root Causes

### 1. Incorrect `place_offset_y`
**Problem:** Set to `1`, meaning buildings spawned 1 node ABOVE the surface.

**Before:**
```lua
place_offset_y = 1,  -- Building floats 1 node above ground
```

**After:**
```lua
place_offset_y = 0,  -- Building sits directly ON the ground
```

### 2. Excessive `height_max`
**Problem:** Values of 3-4 allowed placement on terrain with too much variation, creating large gaps.

**Before:**
```lua
height_max = 3,  -- Allows 3-node terrain variation (too much)
height_max = 4,  -- Savanna had even more (way too much)
```

**After:**
```lua
height_max = 2,  -- Only allows 2-node variation (gentler slopes)
```

### 3. Inadequate Foundation Filling
**Problem:** The `fill_under_house` function wasn't properly filling gaps.

## Solutions Implemented

### Solution 1: Proper Building Placement
Changed all building decorations to use:
- `place_offset_y = 0` (ground level placement)
- `height_max = 2` (stricter terrain requirements)
- `force_placement` (still enabled to ensure complete buildings)

**Files Modified:**
- grasslandbuildings.lua
- desertbuildings.lua
- icebuildings.lua
- savannabuildings.lua
- junglebuildings.lua
- lakebuildings.lua

### Solution 2: Improved Foundation System
Completely rewrote `utils.lua` with a smarter foundation filling algorithm:

**Key Improvements:**
1. **Accurate Size Detection** - Parses schematic filename to get exact dimensions
2. **Biome-Appropriate Materials** - Fills with matching terrain blocks:
   - Desert → desert_sand
   - Ice → snowblock
   - Savanna → dry_dirt
   - Others → dirt
3. **Column-by-Column Filling** - Scans each vertical column to find solid ground
4. **Smart Gap Detection** - Only fills air between building floor and actual terrain
5. **Proper Timing** - Uses emerge_area callback and delayed execution for reliability

## How It Works

### Building Placement Process
```
1. Minetest finds suitable location (height variation ≤ 2 nodes)
2. Building spawns at ground level (place_offset_y = 0)
3. force_placement ensures building is complete
4. on_placed callback triggers foundation filling
```

### Foundation Filling Algorithm
```
For each column (x, z) under the building:
  1. Scan from top to bottom
  2. Find first solid ground node (dirt, stone, sand, etc.)
  3. Fill all air nodes between (pos.y - 1) and (solid_ground + 1)
  4. Use biome-appropriate fill material
```

## Visual Comparison

### Before Fix
```
    [House]     ← Building 1 node above ground
      |air|     ← Visible gap
      |air|
      |air|
    ========    ← Actual terrain
```

### After Fix
```
    [House]     ← Building sits on ground
    ========    ← Foundation fills any small gaps
    ========    ← Actual terrain
```

## Technical Details

### Size Detection
Parses filenames like `grasslandhouse1_7_9_7.mts`:
- X dimension: 7 nodes
- Y dimension: 9 nodes
- Z dimension: 7 nodes

Creates foundation area: building footprint + 2-node padding on each side

### Material Detection
```lua
if node:find("desert") or node == "default:sand" then
    fill_material = "default:desert_sand"
elseif node:find("snow") or node == "default:ice" then
    fill_material = "default:snowblock"
elseif node:find("dry") then
    fill_material = "default:dry_dirt"
else
    fill_material = "default:dirt"
end
```

### Fill Area Calculation
```lua
half_x = ceil(size.x / 2) + 2  -- Building half-width + padding
half_z = ceil(size.z / 2) + 2  -- Building half-depth + padding

Foundation scans from (pos.y - 15) to (pos.y + 2)
```

## Benefits

1. **No More Floating** - Buildings properly grounded
2. **Realistic Appearance** - Foundations blend with terrain
3. **Biome-Appropriate** - Fill materials match surroundings
4. **Performance Friendly** - Only processes buildings that spawn
5. **Handles All Cases** - Works on hills, valleys, and flat terrain

## Edge Cases Handled

### Steep Terrain
- `height_max = 2` rejects locations that are too steep
- Buildings only spawn on relatively flat areas
- Foundation fills small remaining gaps

### Different Biomes
- Automatic material detection
- Desert sand in deserts
- Snow in arctic
- Dry dirt in savanna
- Regular dirt elsewhere

### Lake Buildings (Stilts)
- Still use `place_offset_y = 0`
- `height_max = 2` ensures proper water level
- Foundation fills underwater supports

### Jungle Treehouses
- Also use `place_offset_y = 0`
- Foundation fills support pillar gaps
- Works with built-in schematic stilts

## Testing Results

Expected improvements in new chunks:
- ✓ Buildings sit directly on terrain
- ✓ No visible air gaps underneath
- ✓ Foundations use appropriate materials
- ✓ Works on gentle slopes
- ✓ Rejects locations that are too steep

## Configuration Notes

### To Allow More Sloped Placement
In building files, increase:
```lua
height_max = 3,  -- Allows more terrain variation
```
⚠️ May result in some gaps (foundation will still fill them)

### To Require Flatter Terrain
```lua
height_max = 1,  -- Very strict (nearly flat only)
```
⚠️ Buildings become rarer but perfectly grounded

### To Adjust Fill Depth
In utils.lua, modify:
```lua
y = pos.y - 15,  -- Current: checks 15 nodes down
                 -- Increase for deeper fills
                 -- Decrease for performance
```

## Performance Impact

- Minimal: Only runs when buildings spawn (rare events)
- Delayed execution: Doesn't block mapgen
- Efficient: Only processes building footprint area
- One-time: Foundation created once, never recalculated

## Migration

- Old chunks: Buildings remain as-is
- New chunks: All buildings properly grounded
- No world corruption or save issues
- Can coexist with old villages

## Future Enhancements

Potential improvements:
1. Add cobblestone foundations for stone buildings
2. Create visible foundation blocks (different material)
3. Add stairs/ramps for elevated buildings
4. Support terraced foundations on steeper slopes
5. Add foundation decorations (vines, moss on corners)
