# Bed-Based Linking Update

## Major Change: Biome Markers → Beds

### Why This Change?
**Problem**: Villagers were linked to biome-specific marker blocks (barrels, shrines, etc.) which:
- Only worked in specific biome villages
- Wasn't intuitive (why would they sleep at a barrel?)
- Required maintaining a complex marker→biome mapping
- Didn't work for custom villages without markers

**Solution**: Link villagers directly to **beds** instead!
- Universal: Works with ANY bed from ANY mod (uses `group:bed`)
- Intuitive: Villagers sleep in beds (makes sense!)
- Flexible: Works in player-built villages
- Simpler: No complex biome marker system needed

## What Changed

### File: `house_spawning.lua`
Complete rewrite of spawning logic:

#### Before (Marker-Based):
1. Scan for biome markers (barrels, shrines, etc.)
2. Link villager to marker position
3. Track houses by 16×16×16 grid
4. Villagers "sleep" near markers

#### After (Bed-Based):
1. Scan for all beds in chunk (`group:bed`)
2. Link villager directly to bed position
3. Track beds individually by exact position
4. Villagers sleep IN their assigned bed

### Key Changes:

**Data Structure:**
```lua
-- Old
houses_with_villagers[house_key] = true

-- New
beds_with_villagers[bed_key] = true
```

**Spawning Logic:**
```lua
-- Old: Find markers
local markers = minetest.find_nodes_in_area(..., marker_list)

-- New: Find beds
local beds = minetest.find_nodes_in_area(..., "group:bed")
```

**Villager Linking:**
```lua
-- Old: Link to marker position
luaent.nv_house_pos = vector.new(marker_pos)

-- New: Link to bed position
luaent.nv_house_pos = vector.new(bed_pos)
```

## Biome Detection

Since we're no longer using biome markers for spawning, how do we know which villager type to spawn?

### Smart Biome Detection:
1. When a bed is found, scan 30 blocks around it for biome markers
2. If marker found → use that biome's villager types
3. If no marker found → default to "grassland" villagers
4. This ensures proper villager types even in bed-based system

```lua
local markers_nearby = minetest.find_nodes_in_area(
    {x = bed_pos.x - 30, y = bed_pos.y - 10, z = bed_pos.z - 30},
    {x = bed_pos.x + 30, y = bed_pos.y + 10, z = bed_pos.z + 30},
    marker_list
)

if #markers_nearby > 0 then
    biome = marker_to_biome[markers_nearby[1].name]
else
    biome = "grassland"  -- Safe default
end
```

## Door Interaction Debug

### Added Debug Logging:
```lua
minetest.log("action", "[villagers] Door found: " .. node.name .. " at " .. pos)
minetest.log("action", "[villagers] Opening door at " .. pos)
```

**How to check logs:**
1. Open `debug.txt` in your world folder
2. Search for `[villagers]` entries
3. You'll see when doors are detected and opened

**What to look for:**
- "Door found" = villager detected a door nearby
- "Opening door" = villager attempted to open it
- If you see "Door found" but no "Opening door" → door is already open
- If you see neither → no doors in range OR door detection not working

## Benefits of Bed-Based System

### 1. Universal Compatibility
- ✅ Works with default beds
- ✅ Works with beds from any mod (as long as they use `group:bed`)
- ✅ Works in player-built houses
- ✅ Works in custom villages

### 2. More Intuitive
- Villagers sleep in beds (obvious!)
- Easy to understand: 1 bed = 1 villager
- Visual feedback: see which beds are "occupied"

### 3. Easier to Extend
- Want more villagers? Add more beds!
- Works automatically without configuration
- No need to place biome markers

### 4. Better Pathfinding
- Villagers walk to their specific bed (not just "near" a marker)
- Sleep radius is smaller (3 nodes from bed)
- More precise nighttime behavior

## Migration Notes

### For Existing Worlds:
- **Old villagers**: Will keep their marker-based homes until despawned
- **New villagers**: Will spawn with bed-based homes
- **No corruption**: Old data structure is separate from new one
- **Clean transition**: Both systems coexist safely

### Data Persistence:
```lua
-- Old data (still saved, won't interfere)
storage:get_string("houses_with_villagers")

-- New data (separate key)
storage:get_string("beds_with_villagers")
```

## Testing the New System

### Test 1: Natural Village Spawning
1. Generate new chunks with villages
2. Check `debug.txt` for: "Villager spawned near bed"
3. Use `/time 0` - villagers should walk to beds and sleep

### Test 2: Custom Village
1. Build a house with beds
2. Place beds inside
3. Load/unload the chunk (or restart server)
4. Villagers should spawn near the beds

### Test 3: Mod Compatibility
1. Install a bed mod (e.g., `cottages`, `homedecor`)
2. Place those beds in a village
3. Villagers should recognize and use them

### Test 4: Door Interaction
1. Place doors in village houses
2. Watch villagers approach doors
3. Check `debug.txt` for door detection logs
4. Doors should open when villagers are within 2 nodes

## Configuration

### Spawn Rate (house_spawning.lua:87)
```lua
if math.random() < 0.28 then  -- 28% of beds are empty
```
- Lower number = more empty beds (more sparse villages)
- Higher number = fewer empty beds (more populated)

### Biome Detection Radius (house_spawning.lua:94-97)
```lua
{x = bed_pos.x - 30, y = bed_pos.y - 10, z = bed_pos.z - 30},
{x = bed_pos.x + 30, y = bed_pos.y + 10, z = bed_pos.z + 30}
```
- Increase `30` to detect biome markers further away
- Decrease `30` for stricter biome matching

### Spawn Search Radius (house_spawning.lua:112-114)
```lua
for dx = -2, 2 do
    for dy = 0, 2 do
        for dz = -2, 2 do
```
- Increase range to search further from bed for spawn spot
- Decrease for tighter spawn positions

## Known Issues & Solutions

### Issue: Villagers not spawning
**Check:**
- Are there beds in the village? (use `/lua minetest.find_nodes_in_area({x,y,z}, {x,y,z}, "group:bed")`)
- Is the bed underwater or in a wall?
- Check `debug.txt` for errors

### Issue: Wrong biome villagers
**Cause**: No biome markers within 30 blocks of bed
**Solution**:
- Place a biome marker nearby, OR
- Accept grassland villagers as default, OR
- Increase detection radius in config

### Issue: Villagers spawn but don't sleep
**Check:**
- Is `nv_house_pos` set? (use lua command to inspect entity)
- Is it nighttime? (use `/time 0`)
- Are they tamed/following player? (prevents autonomous sleep)

## Future Enhancements

Possible improvements for next version:
- Bed ownership particles (glowing bed when occupied)
- Villager nametag showing assigned bed coordinates
- Command to manually assign villager to specific bed
- Visual "claim" effect when villager first links to bed
- Prevent players from removing occupied beds

---

## Summary

**Changed**: Villager home linking from biome markers → beds
**Why**: More intuitive, universal, and flexible
**Impact**: Works better for all village types
**Compatibility**: Backward compatible, no world corruption
**Testing**: Check `debug.txt` for spawn logs and door interaction logs
