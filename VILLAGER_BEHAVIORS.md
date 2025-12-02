# Enhanced Villager Behaviors

This document describes the new AI behaviors implemented for villagers in the Native Villages mod.

## Features Overview

### 1. House Assignment and Sleep System
- **House Linking**: Each villager is automatically linked to a house marker when spawned (handled by `house_spawning.lua`)
- **Sleep Cycle**: Villagers automatically return to their house at night and enter sleep state
- **Sleep Animation**: Uses the "lay" animation from character.b3d when sleeping
- **Home Radius**: Villagers stay within a configurable radius of their house (default: 20 nodes)
- **Night Detection**: Uses Luanti's `minetest.get_timeofday()` to detect day/night cycles

**How it works:**
- Night time: 0.0-0.25 and 0.75-1.0 (Luanti time scale)
- Villagers pathfind to their house position when night falls
- Once within 3 nodes of house, they enter sleep state and play lay animation
- They wake up automatically when morning comes

### 2. Door Interaction System
- **Automatic Door Opening**: Villagers detect and open nearby doors automatically
- **Smart Door Closing**: Doors automatically close 3 seconds after opening
- **Door Detection**: Scans for doors within 2 node radius
- **Compatible**: Works with all door types using `group:door`

**How it works:**
- Every frame, villagers check for doors within 2 nodes
- If a closed door is detected, the villager opens it
- A timer schedules the door to close after 3 seconds
- Prevents door spam with timer tracking system

### 3. Daily Routine Scheduler
The villager's behavior changes based on time of day:

| Time Period | Time Range | Behavior | Activity Radius |
|------------|------------|----------|-----------------|
| **Night** | 0.0-0.25, 0.75-1.0 | Sleep at house | 3 nodes (sleep radius) |
| **Morning** | 0.25-0.35 | Wake up, emerge from house | 50% of base radius |
| **Afternoon** | 0.35-0.65 | Active, explore village | 120% of base radius |
| **Evening** | 0.65-0.75 | Social gathering, return home | 70% of base radius |

**How it works:**
- Activity radius dynamically adjusts based on time period
- Morning: Villagers stay close to home as they wake up
- Afternoon: Peak activity time, wider roaming range
- Evening: Social time, moderate radius
- Night: Return home for sleep

### 4. Villager-to-Villager Social Interactions
- **Social Detection**: Villagers detect other villagers within 5 nodes
- **Interaction Cooldown**: Social interactions occur every 45 seconds
- **Mood Synchronization**: Happy villagers improve nearby villager moods (+5 mood points)
- **Loneliness Reduction**: Social interactions reduce loneliness (-15 points)
- **Visual Feedback**: Chat bubble particles appear between socializing villagers

**How it works:**
- Scans for nearby NPC entities within 5 nodes every frame (5% chance)
- When villagers interact, happy mood particle effects spawn between them
- Existing mood sound system continues to play during interactions
- Each villager tracks last social time to prevent spam

### 5. Food Sharing System
- **Hunger Detection**: Well-fed villagers (hunger < 30) help hungry villagers (hunger > 85)
- **Food Transfer**: Giver gains +15 hunger, receiver loses -30 hunger
- **Health Bonus**: Hungry villager receives +3 health when fed
- **Mood Improvement**: Receiver gets +10 mood points
- **Share Cooldown**: Each villager can share food every 60 seconds
- **Visual Feedback**: Blue particle effects (not bread particles) indicate food sharing
- **Silent Sharing**: No feeding sound plays (reserved for player interactions only)

**How it works:**
- Checks within 8 node radius for hungry villagers (3% chance per frame)
- Only well-fed villagers share food
- Particle effects show food exchange without playing audio
- Cooldown prevents excessive food sharing

### 6. Greeting System
- **Player Detection**: Villagers detect nearby players (1-3 nodes away)
- **Greeting Particles**: Color-coded particles show villager disposition
  - **Green particles**: Friendly villager
  - **Red particles**: Hostile/attacking villager
- **Greeting Cooldown**: Each villager greets players once every 30 seconds

### 7. Enhanced Movement and Safety
- **Stuck Detection**: If villager is too far from home for 5 minutes, teleports back
- **Flee to House**: When health drops below 30%, villager attempts to flee home
- **Dynamic Radius**: Home radius expands/contracts based on time of day
- **Pathfinding Priority**: House at night > safety when hurt > normal wandering

## Configuration

All settings can be adjusted in `villager_behaviors.lua`:

```lua
nativevillages.behaviors.config = {
	home_radius = 20,                    -- Base radius villagers stay within
	sleep_radius = 3,                    -- Distance to house to trigger sleep
	door_detection_radius = 2,           -- How far to look for doors
	social_detection_radius = 5,         -- Range for social interactions
	food_share_detection_radius = 8,     -- Range for food sharing
	social_interaction_cooldown = 45,    -- Seconds between social interactions
	food_share_cooldown = 60,            -- Seconds between food sharing
	door_close_delay = 3,                -- Seconds before door closes
	stuck_teleport_threshold = 300,      -- Seconds before stuck teleport (5 minutes)
}
```

## Data Persistence

All villager behavior data is saved using Luanti's entity staticdata system:

### Saved Data:
- `nv_house_pos`: Vector3 coordinates of assigned house
- `nv_home_radius`: Personal home radius
- `nv_sleeping`: Current sleep state
- `nv_stuck_timer`: Accumulated stuck time
- `nv_last_social_time`: Last social interaction timestamp
- `nv_last_food_share_time`: Last food sharing timestamp
- `nv_last_player_greeting_time`: Last player greeting timestamp

Data is serialized in `get_staticdata()` and restored in `on_activate()`.

## Technical Details

### Performance Optimization
- Random chance checks prevent every villager from running expensive operations every frame
- Social interactions: 5% chance per frame
- Food sharing: 3% chance per frame
- Player greetings: 2% chance per frame
- Door detection: Every frame but cheap radius check
- Sleep checks: Cheap time-of-day check

### Integration with Existing Systems
- **Mood System**: Behaviors integrate with existing mood/hunger system
- **House Spawning**: Leverages existing house detection from `house_spawning.lua`
- **mobs_redo**: Uses existing pathfinding, animations, and state system
- **Sound System**: Preserves existing mood sound implementation

### Animation States
The mod uses character.b3d animation frames:
- **stand**: 0-79 (default, awake)
- **lay**: Built-in animation (sleeping)
- **walk**: 168-187 (moving)
- **punch**: 189-198 (attacking)

## Future Enhancements (Not Implemented)

Potential additions for future versions:
- Ladder climbing (requires additional pathfinding logic)
- Work station behaviors per class (farmer → farm, blacksmith → furnace)
- Village center gathering during festivals
- Trade route behaviors between villages
- Child villagers following parents
- Villager chat messages (optional)

## Troubleshooting

### Villagers Not Sleeping
- Verify house marker nodes exist nearby (barrels, shrines, etc.)
- Check `nv_house_pos` is set (use debug output)
- Ensure time of day is within night range (0.0-0.25 or 0.75-1.0)

### Doors Not Opening
- Ensure doors have `group:door` in their node definition
- Check door detection radius (default: 2 nodes)
- Verify villager is moving toward the door

### No Social Interactions
- Ensure multiple villagers are within 5 nodes of each other
- Check both villagers have `type = "npc"` (not monsters)
- Social interactions are random (5% chance per frame)

### Villagers Stuck Far From Home
- Stuck detection will teleport them back after 5 minutes
- Can reduce `stuck_teleport_threshold` for faster recovery
- Check pathfinding isn't blocked by terrain

## Credits

Enhanced behaviors designed to work within the Luanti modding API and mobs_redo framework.
Based on the original Native Villages mod by original authors.
