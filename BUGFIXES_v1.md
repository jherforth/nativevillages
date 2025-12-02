# Bug Fixes - Version 1

## Issues Reported
1. Villagers not returning home at night
2. Particles too large (boxes)
3. Door interaction not working

## Fixes Applied

### 1. Sleep/Home Pathfinding Fixed
**Problem**: Villagers would check if it was night time but wouldn't actually walk home.

**Solution**: Enhanced `handle_sleep()` function to actively move villagers toward their house:
- Sets direct velocity toward house position
- Updates yaw (rotation) to face home
- Only activates when not following player or standing still
- Uses `vector.direction()` and `set_velocity()` for direct movement
- Maintains walk animation during return journey

**Code Location**: `villager_behaviors.lua:217-253`

### 2. Particle Sizes Reduced & Count Increased
**Problem**: Particles were too large (2-4 nodes) appearing as big boxes

**Solution**: Reduced particle size to 1/8th and increased count 8x:

#### Social Interaction Particles
- **Before**: 5 particles, size 2-4
- **After**: 40 particles, size 0.25-0.5
- Location: `villager_behaviors.lua:342-357`

#### Food Sharing Particles
- **Before**: 8 particles, size 1.5-3
- **After**: 64 particles, size 0.2-0.4
- Location: `villager_behaviors.lua:438-453`

#### Player Greeting Particles
- **Before**: 3 particles, size 2-3
- **After**: 24 particles, size 0.25-0.4
- Location: `villager_behaviors.lua:494-509`

### 3. Door Interaction System Improved
**Problem**: Doors weren't opening when villagers approached

**Solutions Applied**:

a) **Added Fallback Door API Support**
   - Primary: Use door's `on_rightclick` callback
   - Fallback: Use `doors.door_toggle()` if available
   - Wrapped in `pcall()` for error handling
   - Handles both standard and custom door mods

b) **Improved Door Detection Frequency**
   - Added 30% random chance per frame for door checks
   - Prevents excessive door spam while maintaining responsiveness

c) **Fixed Callback Parameters**
   - Changed from `on_rightclick(pos, node, entity)`
   - To: `on_rightclick(pos, node, nil, nil)` (standard player API)
   - Falls back to `doors.door_toggle(pos, node, nil)` for compatibility

**Code Locations**:
- `villager_behaviors.lua:112-133` (open_door function)
- `villager_behaviors.lua:144-165` (schedule_door_close function)
- `villager_behaviors.lua:168-179` (handle_door_interaction)

## Technical Details

### Sleep Movement Implementation
```lua
-- Calculate direction to house
local dir = vector.direction(pos, house_pos)
local yaw = minetest.dir_to_yaw(dir)
self.object:set_yaw(yaw)

-- Apply velocity toward home
local speed = self.run_velocity or 2
local vel = vector.multiply(dir, speed)
self.object:set_velocity(vel)
```

### Door API Compatibility
```lua
-- Try standard callback first
local success, err = pcall(function()
    door_def.on_rightclick(door_pos, node, nil, nil)
end)

-- Fall back to doors mod API
if not success then
    if doors and doors.door_toggle then
        doors.door_toggle(door_pos, node, nil)
    end
end
```

## Testing Recommendations

### Test Sleep Behavior
1. Spawn villagers near a village with house markers
2. Use `/time 0` to set night time (midnight)
3. Observe villagers walking toward their house markers
4. Verify they lay down when they reach home (within 3 nodes)
5. Use `/time 6000` to set dawn - villagers should wake up

### Test Particle Effects
1. Spawn 2+ villagers near each other
2. Wait ~45 seconds for social interaction
3. Look for **small sparkle cloud** of happy face particles (not big boxes)
4. Feed one villager with bread
5. Wait ~60 seconds - should see **small blue particles** for food sharing

### Test Door Interaction
1. Build a house with standard wooden doors
2. Spawn villager inside or near doorway
3. Watch villager approach door
4. Door should open automatically when villager is within 2 nodes
5. Door should close after 3 seconds

## Known Limitations

### Sleep System
- Villagers use direct velocity, not pathfinding
- May get stuck on obstacles between them and home
- Stuck detection will teleport them after 5 minutes
- Works best in flat, open villages

### Door Interaction
- Only works with doors that have `group:door`
- Custom door mods may need additional API support
- 30% chance per frame means slight delay (intentional to prevent spam)

## Performance Impact

### Changes to Frame Execution:
- Door checks: 30% chance per frame (reduced from 100%)
- Sleep pathfinding: Only runs during night time
- Particle count increased but particle size decreased (net neutral)

### Memory Impact:
- Minimal - no new persistent data structures
- Door timers cleaned up automatically after 3 seconds

## Compatibility

✅ **Minetest/Luanti 5.0+**
✅ **mobs_redo framework**
✅ **Standard `doors` mod**
✅ **Custom door mods** (if they use `group:door` and standard API)

## Future Improvements

Potential enhancements for next version:
- Use mobs_redo's built-in pathfinding for sleep movement
- Add obstacle avoidance during nighttime return
- Configurable particle sizes in config table
- Debug mode to visualize home paths
- Support for more door APIs (trap doors, gates, etc.)

---

## Version Info
- **Version**: 1.0 Bugfix Release
- **Date**: December 2025
- **Files Modified**: `villager_behaviors.lua`
- **Lines Changed**: ~120 lines
