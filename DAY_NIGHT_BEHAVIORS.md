# Day/Night Cycle Behaviors

## Overview

NPCs now have distinct behaviors based on the time of day. During the day, they avoid beds and seek social interaction. At night, they seek beds and ignore other NPCs.

## Configuration

Located in `villager_behaviors.lua`:

```lua
bed_detection_radius = 8        -- How far to detect beds during daytime
bed_avoidance_distance = 6      -- Stay this far from beds during day
npc_seek_radius = 10            -- Radius to search for NPCs to socialize with during day
```

## Daytime Behaviors (6:00 AM - 6:00 PM)

### 1. Bed Avoidance
- NPCs actively scan for nearby beds within 8 blocks
- If a bed is detected within 6 blocks, NPC moves away from it
- Movement direction is directly away from the closest bed
- This keeps NPCs active and out of sleeping areas during the day

### 2. NPC Seeking
- NPCs search for other NPCs within 10 blocks to socialize with
- Only approaches NPCs that are more than 2 blocks away
- Moves toward the closest suitable NPC
- Triggers social interactions when close enough

### 3. Active Behaviors
During daytime, NPCs can:
- Socialize with other NPCs (mood boost, particles)
- Share food with hungry NPCs
- Greet nearby players

## Nighttime Behaviors (6:00 PM - 6:00 AM)

### 1. Bed Seeking
- NPCs pathfind directly to their assigned bed/house position
- Ignores all other NPCs while seeking bed
- Stops when within sleep radius (3 blocks) of house

### 2. Social Avoidance
- Social interactions are disabled at night
- Food sharing is disabled at night
- Player greetings are disabled at night
- Focus is entirely on getting to bed

### 3. Sleep Mode
- Once at house, NPC remains stationary
- No active wandering or social behaviors
- Waits for daytime to resume activities

## Implementation Details

### Bed Detection
```lua
function nativevillages.behaviors.find_nearby_beds(self)
```
- Scans a cube around the NPC (8 block radius, ±2 blocks vertically)
- Identifies any node with "bed" in its name
- Returns a list of bed positions

### Bed Avoidance
```lua
function nativevillages.behaviors.get_bed_avoidance_position(self)
```
- Finds the closest bed
- If closer than 6 blocks, calculates an "away" position
- Returns a position 8 blocks away from the bed

### NPC Seeking
```lua
function nativevillages.behaviors.find_npc_to_socialize_with(self)
```
- Searches for friendly NPCs within 10 blocks
- Excludes NPCs that are too close (< 2 blocks)
- Returns the closest suitable NPC

### Movement Priority

The system follows this priority order:

1. **Player Control** - If NPC is following player or ordered to stand, ignore all automatic behaviors
2. **Night Mode** - At night, pathfind to bed (ignoring everything else)
3. **Day Mode** - During day:
   - First: Move away from beds if too close
   - Second: Move toward other NPCs for socializing
4. **Stuck Recovery** - If stuck, attempt teleport after 5 minutes
5. **Random Activities** - Social interactions, food sharing, player greetings

## Time Periods

```lua
0.0 - 0.25  = Night   (6:00 PM - 6:00 AM)
0.25 - 0.35 = Morning (6:00 AM - 8:24 AM)
0.35 - 0.65 = Afternoon (8:24 AM - 3:36 PM)
0.65 - 0.75 = Evening (3:36 PM - 6:00 PM)
0.75 - 1.0  = Night   (6:00 PM - 6:00 AM)
```

Day behaviors: Morning, Afternoon, Evening
Night behaviors: Night only

## Benefits

1. **More Realistic** - NPCs have a clear daily routine
2. **Better Village Life** - During day, villages feel more alive with NPCs interacting
3. **Clear Night Behavior** - At night, NPCs focus on getting to bed
4. **Natural Spacing** - Bed avoidance prevents NPCs from clustering around beds during day
5. **Social Encouragement** - NPC seeking promotes more social interactions

## Testing Checklist

- [ ] NPCs avoid beds during daytime
- [ ] NPCs move toward other NPCs during daytime
- [ ] NPCs socialize when close to each other during day
- [ ] NPCs pathfind to beds at nighttime
- [ ] NPCs ignore other NPCs at nighttime
- [ ] No social interactions occur at night
- [ ] NPCs stay near their beds at night
- [ ] Transition between day/night works smoothly

## Files Modified

1. **villager_behaviors.lua** - Added day/night behavior functions and updated main update loop
