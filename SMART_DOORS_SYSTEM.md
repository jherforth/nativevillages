# Smart Doors System

## Overview

The smart doors system makes doors automatically detect nearby NPCs and open/close themselves. This is more reliable than having NPCs try to interact with doors.

## How It Works

### Approach
Instead of NPCs trying to open doors, the doors themselves:
1. Monitor their surroundings for nearby NPCs
2. Automatically open when an NPC approaches
3. Automatically close after NPCs leave

### Technical Implementation

**Node Timers**
- Each door runs a node timer that checks every 1 second
- Closed doors check for approaching NPCs
- Open doors check if NPCs have left

**Detection Radius**
- Doors detect NPCs within 2.5 blocks
- Doors close when no NPCs are within 3.5 blocks for 3 seconds

**Door Types**
- Works with all standard Minetest doors (e.g., `doors:door_wood_b`)
- Works with custom doors that follow the naming pattern: `doors:door_*_a` (open) and `doors:door_*_b` (closed)

### Benefits

1. **More Reliable**: Doors always work regardless of NPC pathfinding
2. **Simpler NPC Code**: NPCs don't need door interaction logic
3. **Better Performance**: Only doors near NPCs are actively checking
4. **Automatic**: Works for all villagers without special code

## Configuration

Located in `smart_doors.lua`:

```lua
DOOR_CHECK_INTERVAL = 1.0     -- Check for NPCs every second
DOOR_DETECTION_RADIUS = 2.5   -- How close NPCs need to be to open door
DOOR_CLOSE_DELAY = 3          -- Seconds to wait before closing
```

## Sound Effects

- Doors play their defined open/close sounds at 30% volume (gain = 0.3)
- Sounds only play within 10 blocks (max_hear_distance = 10)

## NPC Detection

Doors will open for:
- All villager types (grassland, desert, ice, lake, savanna, jungle)
- Non-hostile NPCs only

Doors will NOT open for:
- Hostile mobs (type = "monster")
- Witches
- Raiders
- Other hostile entities

## Integration with NPC Behaviors

The old door interaction code in `villager_behaviors.lua` has been disabled:
- NPCs no longer call `handle_door_interaction()`
- NPCs no longer track which doors they opened
- Door state is now entirely managed by the doors themselves

## Files

1. **smart_doors.lua** - Main smart doors system
2. **init.lua** - Loads smart_doors.lua after villager_behaviors.lua
3. **villager_behaviors.lua** - Door interaction code disabled

## Testing Checklist

- [ ] Doors open when NPCs approach
- [ ] Doors close after NPCs leave
- [ ] Multiple NPCs can use the same door
- [ ] Door sounds play at appropriate volume
- [ ] Doors don't open for hostile mobs
- [ ] Performance is acceptable with many doors
- [ ] Works with all door types (wood, steel, custom)
