# Performance Analysis - Native Villages Mod

## Current State

### Entities & Decorations
- **45 mob types** registered across all biomes
- **51 decorations** (buildings, crops, decorative items)
- **30 spawn decorations** for mob placement
- **1 custom entity** (mood indicator)

### Performance Characteristics

#### ✅ ALREADY OPTIMIZED
1. **Mood System Throttling**: Updates only every 5 seconds (not every frame)
2. **Reduced Spawn Counts**: NPCs spawn 2 per house (down from 4)
3. **Conditional Loading**: Only loads atl_path/farming features if mods present
4. **Simple do_custom callbacks**: Minimal logic in per-frame updates

#### ⚠️ POTENTIAL CONCERNS
1. **Decoration Count**: 51 decorations run through mapgen system
2. **Mob Diversity**: 45 different mob types loaded into memory
3. **Trade Item Checks**: `get_objects_inside_radius()` called every 5 seconds per NPC
4. **Mood Indicators**: Visual entities attached to every villager

## Performance Optimization Opportunities

### LOW-HANGING FRUIT (Easy Wins)

#### 1. Increase Mood Update Interval
Current: 5 seconds
Suggested: 10-15 seconds
**Impact**: 50-66% reduction in mood calculations

```lua
-- In npcmood.lua line 116
if self.nv_mood_timer < 10 then  -- was 5
```

#### 2. Optimize Trade Item Detection
Current: Checks all objects in 4-block radius every 5 seconds
Suggested: Only check when player is nearby

```lua
function nativevillages.mood.check_nearby_trade_items(self)
    -- Add early exit if no players nearby
    local pos = self.object:get_pos()
    if not pos then return false end

    local players = minetest.get_connected_players()
    local player_nearby = false
    for _, player in ipairs(players) do
        if vector.distance(pos, player:get_pos()) < 5 then
            player_nearby = true
            break
        end
    end

    if not player_nearby then
        return false
    end

    -- ... rest of function
end
```

#### 3. Lazy Load Mood Indicators
Current: Always active
Suggested: Only create when player is nearby

#### 4. Reduce Decoration Complexity
Current: Many small decorations
Suggested: Combine related decorations (e.g., all wheat fields in one decoration)

### MODERATE OPTIMIZATIONS

#### 1. Consolidate Mob Types
- Many mobs share identical behavior with different textures
- Could use texture variants instead of separate mob types
- Example: All "village male" types could be one mob with texture variants

#### 2. Biome-Specific File Loading
- Load only creatures for biomes that exist in the world
- Use mod settings to enable/disable entire biome sets

#### 3. Distance-Based Mood Updates
- NPCs far from players could update less frequently
- Use tiered update rates: 10s (near), 30s (medium), 60s (far)

### ADVANCED OPTIMIZATIONS

#### 1. Schematic Simplification
- Some schematics might be overly complex
- Consider reducing node counts in large buildings

#### 2. Sound Optimization
- 130+ sound files loaded
- Could use sound atlases or reduce variety

#### 3. ABM Audit
- Check if any after-load processes use ABMs
- Replace with LBMs where possible

## Current Performance Status

**VERDICT**: Mod is reasonably well-optimized for its scope.

The removed on_generated callback was the right call - it would have iterated every block in every chunk, which is extremely expensive.

### Recommended Actions (Priority Order)

1. ✅ **Already Done**: Remove expensive on_generated path callback
2. 🟡 **Optional**: Increase mood update interval to 10 seconds
3. 🟡 **Optional**: Add player proximity check to trade detection
4. 🟢 **Future**: Consider consolidating similar mob types
5. 🟢 **Future**: Add mod settings to disable unused biomes

## Memory Usage

- **Models**: 73 B3D files (mob models)
- **Textures**: 300+ PNG files
- **Sounds**: 130+ OGG files
- **Schematics**: 47 MTS files

These are loaded on demand by Minetest, so memory impact is reasonable.

## Conclusion

The mod's performance is **good** for its feature scope. The main "cost" comes from:
1. Number of different mob types (45)
2. Number of decorations (51)
3. Mood system complexity

All of these are reasonable trade-offs for the mod's rich feature set. The mood system is already well-optimized with 5-second throttling. The removed path generation callback was the biggest performance win.

**No immediate refactoring required** unless specific performance issues are observed in-game.
