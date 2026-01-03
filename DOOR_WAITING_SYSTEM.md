# Door Waiting System Implementation

## Overview
Implemented a comprehensive door waiting and pathfinding system that makes all NPCs and monsters wait at closed doors instead of walking through them or getting stuck.

## Key Features

### 1. Door Cooldown Extended
- **File**: `smart_doors.lua`
- **Change**: Increased `DOOR_COOLDOWN` from 10 to 30 seconds
- Prevents doors from rapidly opening and closing
- Doors now work for ALL entity types (NPCs and monsters)

### 2. Enhanced Pathfinding
- **File**: `villager_behaviors.lua`
- **New Function**: `find_nearest_door_to_target(self, target_pos)`
  - Scans up to 15 blocks in direction of target
  - Finds the NEAREST closed door in path
  - Only returns first door found (single door pathfinding)
  - Checks 3x4x3 area at each scan position

### 3. Door Waiting System
- **File**: `villager_behaviors.lua`
- **New Function**: `handle_door_waiting(self)`
  - NPCs stop and stand at closed doors within 3 blocks
  - Waits up to 5 seconds for smart_doors system to open the door
  - After timeout, clears target and finds alternate route
  - Resumes movement when door opens

### 4. Intermediate Waypoint System
- NPCs now path through doors using waypoints:
  1. Detect door in path to destination
  2. Set door position as intermediate waypoint
  3. Wait at door when reached
  4. Continue to final destination after door opens
- Implemented in:
  - `update_movement_target()` - Night-time house pathfinding
  - `handle_daytime_movement()` - Day-time bed avoidance and NPC seeking
  - `handle_night_time_movement_with_avoidance()` - Night-time movement

### 5. Entity Improvements
- **File**: `villagers.lua`
- Added `stepheight = 1.1` to all villager entities
- Helps NPCs navigate slight elevation changes near doors

### 6. Monster Door Support
- **File**: `witch_magic.lua`
  - Witches now call `handle_door_waiting()` when type is "monster"
  - Non-monster witches use full behaviors.update
- **File**: `explodingtoad.lua`
  - Added `do_custom` function to both wild and tamed toads
  - Toads now wait at closed doors

### 7. State Persistence
- **File**: `villager_behaviors.lua`
- Added save/load support for:
  - `nv_final_destination` - Original destination when pathing through door
  - `nv_waiting_for_door` - Whether NPC is currently waiting
  - `nv_door_wait_start` - Timestamp when waiting started
  - `nv_waiting_door_pos` - Position of door being waited on

## Behavior Flow

### NPC Encounters Closed Door:
1. NPC has destination (house, bed avoidance, or other NPC)
2. `find_nearest_door_to_target()` scans path and finds closed door
3. Original destination stored in `nv_final_destination`
4. Door position becomes immediate target (`self._target`)
5. NPC walks to door position
6. `handle_door_waiting()` detects closed door within 3 blocks:
   - Sets `nv_waiting_for_door = true`
   - Records wait start time
   - Stops movement (velocity = 0, animation = "stand")
7. smart_doors.lua detects NPC within 2.5 blocks
8. smart_doors.lua opens door (respecting 30s cooldown)
9. `handle_door_waiting()` detects door is now open:
   - Sets `nv_waiting_for_door = false`
   - Clears wait data
10. Movement resumes with `nv_final_destination` as new target
11. Process repeats if another door is in path

### Timeout Handling:
- If door doesn't open within 5 seconds:
  - Clear waiting state
  - Clear current target
  - NPC will find alternate path on next update

## Entity Types Covered
✅ All villager types (farmer, blacksmith, etc.)
✅ Hostile NPCs
✅ Raiders
✅ Witches (monster type)
✅ Exploding toads (wild and tamed)
✅ Any future entities using the behaviors system

## Configuration
All configuration in `villager_behaviors.lua`:
- `door_detection_radius = 2` - Not currently used (legacy)
- Wait timeout: 5 seconds (hardcoded in `handle_door_waiting`)
- Door search distance: 15 blocks (in `find_nearest_door_to_target`)
- Wait trigger distance: 3 blocks (in `handle_door_waiting`)

In `smart_doors.lua`:
- `DOOR_DETECTION_RADIUS = 2.5` - How close NPCs must be to trigger door
- `DOOR_COOLDOWN = 30` - Seconds between door operations
- `DOOR_CLOSE_DELAY = 3` - Seconds after NPCs leave before closing

## Testing Recommendations
1. NPC walking through building with multiple rooms and doors
2. Monster chasing player through doorways
3. Multiple NPCs using same door simultaneously
4. NPC pathfinding when door is on cooldown (should wait)
5. Toads navigating through buildings
6. Witches entering/exiting structures
