# Critical Fixes v2 - Chest and Placement Issues

## Problem Summary
After initial fixes, two persistent issues remained:
1. **Chests still glitched/unusable** - Items not showing, inventory broken
2. **Buildings still spawning on hills** - Despite height_max = 1

## Root Causes Discovered

### Issue 1: Chest Loot System
**Why the first fix didn't work:**
The `register_on_placenode` callback does NOT fire for schematic decorations during mapgen. It only fires for nodes placed during active gameplay or by mods using `set_node`.

**Key insight:**
Schematics placed by the decoration system bypass `register_on_placenode` entirely. The chests were never getting filled because the callback never ran.

### Issue 2: Building Placement
**Why height_max = 1 wasn't enough:**
By default, Minetest's `height` and `height_max` parameters only check a **small column** at the decoration spawn point, not the entire schematic footprint.

For a 10x10 building:
- Without `all_floors`: Checks only center 1x1 column
- With `all_floors`: Checks ALL floor nodes in schematic

**Key insight:**
The `all_floors` flag changes height checking from "single column" to "entire footprint".

---

## Solutions Implemented

### Fix 1: LBM-Based Chest Filling

**Changed from:**
```lua
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    -- This never fires for schematic decorations!
end)
```

**Changed to:**
```lua
minetest.register_lbm({
    label = "Fill village chests with loot",
    name = "nativevillages:fill_chests",
    nodenames = {"default:chest"},
    run_at_every_load = false,
    action = function(pos, node)
        fill_chest_with_loot(pos)
    end
})
```

**How LBMs work:**
- LBM = Loading Block Modifier
- Runs when blocks are loaded/generated
- Perfect for post-processing schematic placements
- `run_at_every_load = false` means it only runs once per chest

**Advantages:**
✅ Works with schematic decorations
✅ Runs after mapgen completes
✅ Doesn't affect player-placed chests (they get filled once, then marked)
✅ No timing issues or race conditions

---

### Fix 2: Proper Footprint Checking

**Changed from:**
```lua
flags = "place_center_x, place_center_z, force_placement",
height = 1,
height_max = 1,
```

**Changed to:**
```lua
flags = "place_center_x, place_center_z, force_placement, all_floors",
height = 0,
height_max = 0,
```

**What changed:**

1. **Added `all_floors` flag**
   - Checks EVERY floor node in the schematic
   - Not just the center spawn point
   - Ensures entire building footprint is on flat terrain

2. **Set height = 0, height_max = 0**
   - With `all_floors`, this means: "All floor nodes must be at EXACTLY the same height"
   - Zero variation tolerance = perfectly flat terrain required
   - More stringent than height_max = 1

**How it works:**
```
Without all_floors:        With all_floors:
   ? ? ? ? ?                ✓ ✓ ✓ ✓ ✓
   ? ? ? ? ?                ✓ ✓ ✓ ✓ ✓
   ? ? X ? ?                ✓ ✓ X ✓ ✓  (X = checked point)
   ? ? ? ? ?                ✓ ✓ ✓ ✓ ✓
   ? ? ? ? ?                ✓ ✓ ✓ ✓ ✓

Only center checked      ALL floor nodes checked
```

---

## Technical Details

### LBM Behavior
```lua
run_at_every_load = false  -- Only runs once per node
```

This means:
- First time chest loads: LBM fills it
- Subsequent loads: LBM skips it (already processed)
- No performance impact after initial fill
- Works perfectly with decoration system

### Height Checking with all_floors

The `all_floors` flag changes how height checking works:

**Normal behavior** (without all_floors):
- Check single column at spawn point
- height_max = 1 → allow 1 node variation in that column

**With all_floors:**
- Check ALL floor nodes in schematic
- height_max = 0 → ALL floor nodes must be at exact same Y level
- Much more stringent = truly flat terrain

### Why height = 0, height_max = 0?

From Minetest decoration API:
- `height`: Average height to find
- `height_max`: Maximum variation from average

With `all_floors`:
- `height = 0, height_max = 0` means "find areas where all floor nodes have zero variation"
- This is stronger than `height = 1, height_max = 1` which allows some variation

---

## Files Modified

### loot.lua - Complete Rewrite
- Removed `register_on_placenode` approach
- Implemented LBM-based filling
- Added `filled_chests` tracking to prevent refills
- Simplified biome detection logic

### All *buildings.lua files (6 total)
- grasslandbuildings.lua
- desertbuildings.lua
- icebuildings.lua
- savannabuildings.lua
- junglebuildings.lua
- lakebuildings.lua

Changes in each:
1. Added `all_floors` to flags
2. Changed `height = 1` → `height = 0`
3. Changed `height_max = 1` → `height_max = 0`

---

## Expected Results

### Chest Loot
✅ Village chests fill with biome-appropriate loot
✅ Chests are fully usable (not glitched)
✅ Items visible and accessible
✅ Player-placed chests remain empty (unless filled manually)

### Building Placement
✅ Buildings ONLY spawn on perfectly flat terrain
✅ Zero gaps under any building
✅ Professional, clean appearance
✅ **Trade-off:** Buildings become significantly rarer

---

## Trade-offs

### Rarity Impact
Buildings are now MUCH rarer because:
- `height_max = 0` with `all_floors` is extremely strict
- Requires perfectly flat areas equal to building footprint
- Large buildings (15x15) need larger flat areas than small ones (6x6)

### Configuration Options

If buildings are too rare:

**Option 1: Slight relaxation**
```lua
height = 0,
height_max = 1,  // Allow 1 node variation across footprint
```
Result: More buildings, occasional small gaps

**Option 2: Moderate relaxation**
```lua
height = 1,
height_max = 2,  // Allow 2 nodes variation
```
Result: Many more buildings, accept 1-2 node gaps

**Option 3: Maximum buildings**
```lua
height = 1,
height_max = 3,  // Allow 3 nodes variation
```
Result: Maximum spawn rate, accept visible gaps

---

## Testing Instructions

### Test Chests
1. Generate NEW world (or explore new chunks)
2. Find a village building with a chest
3. Open chest - should contain loot
4. Place a chest manually elsewhere - should be empty
5. Break and replace village chest - should stay filled

### Test Placement
1. Generate NEW world
2. Find villages in all biomes
3. Walk around buildings - check for gaps
4. Buildings should sit perfectly flush on ground
5. Note: May need to explore more to find villages (rarer now)

---

## Troubleshooting

### "I still see glitched chests"
- These are from OLD chunks before the fix
- Solution: Explore NEW chunks or generate new world
- LBM won't retroactively fix old glitched chests

### "I can't find any villages"
- Expected with `height_max = 0`
- Perfectly flat terrain is rare
- Solution: Increase `height_max` to 1 or 2
- Or increase noise scale for more spawn attempts

### "Buildings still on hills"
- Are these in OLD chunks? (Check coords)
- Verify all_floors flag is in building files
- Check that height_max = 0 in all files

---

## Why Previous Fixes Failed

### Chest Fix v1 Failed Because:
- Used `register_on_placenode`
- This callback doesn't fire for decoration schematics
- Only fires for manual placement or set_node calls
- Chests never got the callback = never filled

### Building Fix v1 Failed Because:
- Missing `all_floors` flag
- height_max only checked small column
- Didn't account for full building footprint
- Large buildings could span sloped terrain

---

## Key Learnings

### Minetest Decoration System
1. **Schematics bypass on_placenode**
   - Use LBMs for post-processing decorations
   - on_placenode is for manual/scripted placement only

2. **Height checking is limited by default**
   - Without all_floors: checks single column
   - With all_floors: checks entire schematic footprint
   - Critical for large structures

3. **Flag combinations matter**
   - force_placement + all_floors = strict terrain check but guaranteed placement
   - Without all_floors = buildings can bridge terrain variations

### LBM Best Practices
- `run_at_every_load = false` for one-time processing
- Track processed nodes to avoid redundant work
- Perfect for decoration post-processing
- No performance impact after initial run

---

## Future Enhancements

### Possible Improvements
1. **Adaptive height_max**: Different values per building size
2. **Biome-specific strictness**: Flatter requirements for grassland, relaxed for mountains
3. **Smart terrain detection**: Pre-scan for suitable flat areas
4. **Schematic variants**: Pre-built foundations in schematic files

### Not Recommended
- ❌ Terrain flattening (looks unnatural)
- ❌ Foundation filling (causes floating artifacts)
- ❌ Dynamic gap filling (race conditions)
- ❌ on_placenode for decorations (doesn't work)
