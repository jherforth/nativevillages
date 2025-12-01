# Path System Removal

## Issue
Paths were spawning randomly throughout the world instead of clustering with villages. They appeared in random locations far from any buildings, creating disconnected road segments with no purpose.

## Root Cause
The path decoration system used the same noise parameters as villages but had no actual coordination with building placements. Paths could spawn anywhere the noise matched, independent of whether buildings were nearby.

**The problem:**
```
Village Noise:  scale: 0.001, spread: {300, 300, 300}
Path Noise:     scale: 0.003, spread: {250, 250, 250}
```

Even though paths had 3x denser noise, they weren't synchronized with building locations. This resulted in:
- Paths in empty fields with no buildings
- Villages with no paths nearby
- Random road segments throughout the landscape
- No coherent village layout

## Solution
Removed the entire path system until a proper village-aware implementation can be built.

**Files removed:**
- `paths.lua` - Main path generation code
- `PATH_DISTRIBUTION_GUIDE.txt` - Configuration guide
- `PATH_SYSTEM_SUMMARY.md` - Documentation

**Files modified:**
- `init.lua` - Removed paths.lua loading
- `KNOWN_ISSUES.txt` - Documented removal
- `CHANGES_SUMMARY.txt` - Updated to remove path references

**Files kept:**
- Path schematics (`*_dirt_*.mts`) - Kept for future use
  - `grass_dirt_forward_straight_5x5.mts`
  - `grass_dirt_sideways_straight_5x5.mts`
  - `grass_dirt_left_5x5.mts`
  - `grass_dirt_right_5x5.mts`
  - `grass_dirt_junction_5x5.mts`
  - (Same for snow_dirt_* and savanna_dirt_*)

## Future Implementation Ideas

### Option 1: Village Center Detection
Detect when a building cluster forms and spawn paths only in those areas:
```lua
-- Pseudo-code
on village detection:
    center = calculate_center(buildings)
    for each building:
        spawn_path_from(center, building)
```

### Option 2: Building-Attached Paths
Each building decoration could include a small path segment:
- Schematics include 3-5 nodes of path leading toward village center
- Naturally creates connected paths as buildings spawn
- No separate decoration needed

### Option 3: Post-Generation Pass
After mapgen completes:
- Scan for building clusters
- Calculate optimal path layout
- Place paths connecting buildings
- Use LBM for one-time processing

### Option 4: Coordinated Noise
Use shared noise with offset:
```lua
-- Buildings
noise_offset = {x=0, y=0, z=0}

-- Paths (slightly shifted but overlapping)
noise_offset = {x=10, y=0, z=10}
```
This keeps them in same general area while providing variation.

## Why Minetest Decorations Don't Work for Paths

Minetest's decoration system is designed for independent, scattered features like trees or rocks. It's not well-suited for coordinated placement of multiple related structures.

**Limitations:**
1. **No communication** between decorations - each spawns independently
2. **No hierarchy** - can't make paths "children" of villages
3. **No post-processing** - can't analyze what spawned and adjust
4. **Noise-based only** - can't spawn "near X" or "between A and B"

**What decorations ARE good for:**
- Scattered, independent features (trees, rocks, plants)
- Things that look natural anywhere (flowers, grass)
- Features that don't need relationships (ore deposits)

**What decorations ARE NOT good for:**
- Connected networks (paths, roads)
- Hierarchical structures (village → buildings → paths)
- Dependent placement (spawn X near Y)
- Coordinated layouts (organized settlements)

## Recommended Approach: Custom Mapgen Modifier

For a proper village + path system, use a custom mapgen modifier:

```lua
minetest.register_on_generated(function(minp, maxp, blockseed)
    -- 1. Detect if this chunk should have a village
    if should_spawn_village(minp, maxp) then
        -- 2. Place buildings
        local buildings = place_village_buildings(minp, maxp)

        -- 3. Calculate village center
        local center = calculate_center(buildings)

        -- 4. Place paths connecting buildings to center
        for _, building in ipairs(buildings) do
            create_path(center, building.pos)
        end
    end
end)
```

This approach allows full control over village layout and ensures paths connect actual buildings.

## Conclusion

The path system has been removed because it wasn't fulfilling its purpose. Paths need to be part of a coordinated village generation system, not independent decorations.

The schematic files have been kept for future use when a proper implementation is built.
