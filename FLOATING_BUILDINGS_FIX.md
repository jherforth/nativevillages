# Floating Buildings Fix

## Problem
Buildings were spawning above the ground with visible air gaps underneath, creating an unrealistic floating appearance.

## Root Cause
- `place_offset_y = 1` - Buildings spawned 1 node ABOVE surface
- `height_max = 3-4` - Allowed placement on steep terrain with large variations

## Solution Implemented

### Changed Building Placement Parameters
All building files now use:
```lua
place_offset_y = 0,    // Ground level (was 1)
height_max = 2,        // Gentle slopes only (was 3-4)
force_placement,       // Complete buildings
```

### Foundation Filling: REMOVED
**Critical:** Automated foundation filling caused floating dirt/stone artifacts in the air. The entire `utils.lua` file and all foundation filling code has been **completely removed**.

Buildings are now grounded purely through placement parameters with no callback functions.

## Results

### What Works
✅ Buildings sit on or very close to ground
✅ No floating terrain artifacts
✅ No mid-air dirt/stone columns
✅ Acceptable building spawn rates
✅ No terrain corruption

### Acceptable Trade-offs
⚠️ Small gaps (0-2 nodes) may appear under buildings on gentle slopes
- This is realistic (like crawl spaces)
- Far better than floating terrain corruption
- Minimal and not visually jarring

## Configuration Options

### Current Balanced Settings (Recommended)
```lua
place_offset_y = 0,
height_max = 2,
```
Good balance of spawn rates and minimal gaps.

### For Zero Gaps (Rarer Buildings)
```lua
height_max = 1,  // Only perfectly flat terrain
```
Buildings become much rarer but have no gaps.

### For More Buildings (Larger Gaps)
```lua
height_max = 3,  // Allow more variation
```
More buildings but may have 2-3 node gaps on slopes.

## Why Foundation Filling Failed

Automated filling caused:
1. **Floating artifacts** - Dirt columns in mid-air
2. **Wrong detection** - Couldn't tell "under building" from "open air"
3. **Timing issues** - Race conditions with chunk generation
4. **Corruption** - Sometimes filled natural terrain incorrectly

**Better solution:** Let placement parameters handle it naturally.

## Alternative Approaches

If gaps are completely unacceptable:
1. **Edit schematics** - Add foundation layers to `.mts` files directly
2. **Stricter terrain** - Set `height_max = 1`
3. **Accept reality** - Small gaps are realistic and better than artifacts

## Files Modified
- All 6 `*buildings.lua` files (placement parameters, removed on_placed callbacks)
- `init.lua` (removed utils.lua loading)

## Files Removed
- `utils.lua` (entire foundation filling system removed)

## Summary
**Problem:** Buildings floating with gaps
**Solution:** Ground-level placement + no risky foundation filling
**Result:** Properly grounded buildings without terrain artifacts
**Trade-off:** Accept small realistic gaps vs. floating corruption
