# Door Interaction System - Fixed

## Problem
The previous door system was overly complex with multiple fallback methods and wasn't properly using the doors API. NPCs were getting trapped because doors wouldn't open reliably.

## Solution
Simplified the system to use the proper `doors.get()` API inspired by the auto_door mod approach.

## Key Changes

### 1. Proper doors API Usage
```lua
function nativevillages.behaviors.get_door_at_pos(pos)
    if doors and doors.get then
        local success, door = pcall(doors.get, pos)
        if success and door then
            return door
        end
    end
    return nil
end
```

**How it works:**
- Uses `doors.get(pos)` to retrieve door object
- Returns door object with methods: `door:state()`, `door:open()`, `door:close()`
- Much simpler and more reliable than previous node manipulation

### 2. Smart Door Detection
```lua
local check_positions = {
    pos,  -- Center
    {x = pos.x + 1, y = pos.y, z = pos.z},  -- Cardinal directions
    {x = pos.x - 1, y = pos.y, z = pos.z},
    {x = pos.x, y = pos.y, z = pos.z + 1},
    {x = pos.x, y = pos.y, z = pos.z - 1},
    {x = pos.x, y = pos.y + 1, z = pos.z},  -- Above
    {x = pos.x, y = pos.y - 1, z = pos.z},  -- Below
}
```

**How it works:**
- Checks 7 positions around NPC (inspired by auto_door mod)
- Includes vertical positions for multi-level buildings
- Only checks nodes in "door" group

### 3. Automatic Door Closing
```lua
-- Close door if NPC is far away (>4 blocks) or hasn't been near it for 5 seconds
if dist > 4 or time_since > 5 then
    -- Check if any other NPCs are near this door
    if not other_npcs_nearby then
        door:close(nil)
    end
end
```

**How it works:**
- Doors close when NPC moves >4 blocks away
- Doors close after 5 seconds of inactivity
- Won't close if another NPC is using the same door
- Prevents doors from staying open forever

### 4. Multi-NPC Coordination
```lua
nativevillages.behaviors.open_doors = {}  -- Global tracking
```

**How it works:**
- Tracks which NPCs have opened which doors
- Prevents one NPC from closing a door another NPC is using
- Each NPC tracks its own opened doors
- Global table coordinates between all NPCs

## Technical Details

### State Tracking
Each NPC maintains:
```lua
self.nv_opened_doors[door_key] = {
    pos = door_pos,        -- Position of door
    time = gametime        -- Last interaction time
}
```

### Door Opening Logic
1. NPC approaches door
2. System detects door in 7 positions around NPC
3. Checks if door is closed using `door:state()`
4. Opens door with `door:open(nil)` (nil player works for NPCs)
5. Tracks door in NPC's opened_doors table
6. Updates global tracking table

### Door Closing Logic
1. Every update, check all doors NPC has opened
2. Calculate distance from NPC to each door
3. Calculate time since last interaction
4. If dist >4 blocks OR time >5 seconds:
   - Check if other NPCs are near the door
   - If no other NPCs, close the door
   - Remove from tracking tables

## Comparison with Previous System

### Before (Complex, Unreliable)
- ❌ Multiple fallback methods (on_rightclick, door_toggle, node swap)
- ❌ Timer-based checking (only every 10 steps)
- ❌ No automatic closing
- ❌ State tracking issues
- ❌ Excessive logging spam
- ❌ No multi-NPC coordination

### After (Simple, Reliable)
- ✅ Single method using doors API
- ✅ Checked every update for responsiveness
- ✅ Automatic closing with timer and distance
- ✅ Proper state tracking per NPC
- ✅ Clean error handling with pcall
- ✅ Multi-NPC coordination

## Benefits

1. **NPCs Don't Get Trapped**: Doors open reliably using proper API
2. **Doors Close Automatically**: No more open doors everywhere
3. **Multi-NPC Safe**: Multiple NPCs can use the same door
4. **Performance**: Efficient checking with proper tracking
5. **Clean Code**: Much simpler and easier to maintain

## Inspiration Source
Based on the auto_door mod by blut (https://gitgud.io/blut/auto_door)

Key concepts adapted:
- Using `doors.get()` API
- Checking multiple positions around entity
- Distance-based closing
- Time-based closing
- Tracking open doors

## Testing Checklist
- [ ] NPCs can open doors when approaching
- [ ] NPCs can walk through open doors
- [ ] Doors close after NPC moves away
- [ ] Doors close after 5 seconds of inactivity
- [ ] Multiple NPCs can use same door simultaneously
- [ ] No errors in debug.txt
- [ ] Works with all door types in "door" group
- [ ] Door state persists through save/load
