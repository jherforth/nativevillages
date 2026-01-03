# Smart Doors Update

## Problem
The previous door system relied on NPCs trying to open doors, which was unreliable due to pathfinding limitations and timing issues. NPCs would often walk into closed doors or fail to interact with them properly.

## Solution
Completely changed the approach: **doors now detect NPCs and open themselves automatically**.

## Implementation

### New File: `smart_doors.lua`

This new system:
1. Adds node timers to all doors in the world
2. Doors check for nearby NPCs every second
3. When an NPC comes within 2.5 blocks, the door opens
4. When all NPCs leave (3.5 block radius) for 3 seconds, the door closes
5. Multiple NPCs can use the same door simultaneously

### Modified: `villager_behaviors.lua`

- Commented out the old `handle_door_interaction()` call
- NPCs no longer try to manage doors
- Door state is fully handled by the doors themselves

### Modified: `init.lua`

- Added `smart_doors.lua` to the load order after `villager_behaviors.lua`

## Technical Details

### Door Detection
```lua
DOOR_CHECK_INTERVAL = 1.0     -- Check for NPCs every second
DOOR_DETECTION_RADIUS = 2.5   -- How close NPCs need to be
DOOR_CLOSE_DELAY = 3          -- Seconds to wait before closing
DOOR_COOLDOWN = 10            -- Seconds to wait between open/close operations
```

### NPC Detection Logic
The system only opens doors for:
- NPCs with names matching `^nativevillages:`
- NPCs that are NOT monsters (type ~= "monster")

This means:
- ✅ All friendly villagers
- ✅ All trader types
- ❌ Witches (type = "monster")
- ❌ Hostile mobs
- ❌ Raiders

### How It Works

**Closed Door Timer:**
```
1. Check if any friendly NPCs are within 2.5 blocks
2. Check if 10 seconds have passed since last close (cooldown)
3. If yes to both: open the door
4. Continue checking every second
```

**Open Door Timer:**
```
1. Check if 10 seconds have passed since door opened (cooldown)
2. Check if any friendly NPCs are still within 3.5 blocks
3. If cooldown passed and no NPCs found:
   - Start countdown timer (3 seconds)
   - If still no NPCs after 3 seconds: close door
4. If NPCs are found:
   - Reset countdown timer
5. Continue checking every second
```

### Door State Tracking
- Uses node metadata to track `last_npc_time`
- Uses node metadata to track `last_open_time`
- Uses node metadata to track `last_close_time`
- Only closes after no NPCs have been detected for the full delay period
- 10-second cooldown prevents rapid door cycling
- Gives NPCs time to pass through doorways

## Benefits

1. **More Reliable** - Doors always work, regardless of NPC pathfinding
2. **Simpler NPC Code** - NPCs don't need door interaction logic
3. **Better Performance** - Only active doors run timers (ABM starts them when needed)
4. **Automatic** - Works for all NPCs without special configuration
5. **Multi-NPC Safe** - Multiple NPCs can share doors without conflicts
6. **Cooldown Protection** - 10-second cooldown prevents rapid cycling
7. **NPC-Friendly** - Gives NPCs enough time to pass through doorways
8. **Quieter** - Door sounds at 30% volume (gain = 0.3)

## Compatibility

Works with:
- Standard Minetest doors (`doors:door_wood`, `doors:door_steel`, etc.)
- Custom doors following the `doors:door_*_a` (open) and `doors:door_*_b` (closed) naming pattern
- All door types marked with `group:door`

## Testing

To test the smart doors system:

1. Spawn a villager near a door
2. Watch as the villager approaches (door should open at 2.5 blocks if cooldown passed)
3. Wait for the villager to walk through
4. After the villager moves away, the door should wait at least 10 seconds, then close after 3 more seconds
5. Try to trigger the door again immediately - it should wait for the 10-second cooldown
6. Spawn multiple villagers - they should all be able to use the same door
7. Spawn a hostile mob - the door should NOT open for it

## Future Enhancements

Possible improvements:
- Make doors open faster when NPCs are running
- Add different detection radii for different door types
- Allow configuration per-door using metadata
- Add compatibility with more door mods
