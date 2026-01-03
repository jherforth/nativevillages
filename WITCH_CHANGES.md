# Witch Modification Summary

## Overview
Witches have been transformed from passive NPCs into hostile monsters with dual attack abilities: melee punches for close combat and magic teleportation for medium range. Inspired by the witches mod but using the greeting particle system instead of texture-based particles.

## Changes Made

### 1. New File: witch_magic.lua
Created a complete magic system for witches with the following features:

**Particle Effects**
- `effect_area()`: Creates area-based particle effects using greeting-style particles
- `effect_line()`: Creates line-based particle effects between two points
- Uses `default_cloud.png^[colorize:purple:150` instead of any texture-based particles
- Purple color theme to indicate hostile magic
- Glow value of 10 for visibility

**Teleport Attack (Medium Range)**
- Magic attack used at 1.5-5 block distance
- Teleports target 10 blocks away in random direction
- **NO DAMAGE** - pure displacement/disruption
- Random direction (360 degrees, keeps same Y-level)
- Works on both players and entities
- Visual feedback with line and area particle effects
- Magic sound effect at 30% volume (gain = 0.3)

**Melee Punch Attack (Close Range)**
- Standard dogfight attack used at 0-1.5 block distance
- Deals 7 damage per hit
- No special effects or cooldown
- Automatic mobs_redo melee behavior

**Custom Attack Behavior**
- 4-second cooldown between magic attacks (melee has no special cooldown)
- Magic range: 1.5-5 blocks (medium distance)
- Melee range: 0-1.5 blocks (close combat)
- Only attacks when target is in range
- Automatic timer management per witch entity
- Dual-attack strategy based on distance

**Custom do_custom Function**
- Handles magic attack logic
- Maintains mood system for witches
- Skips normal villager behaviors (witches don't follow houses, sleep, etc.)
- Error handling to prevent crashes

### 2. Modified: villagers.lua

**Witch Class Definition Changes**
```lua
- passive = true  →  passive = false
- reach = 3  →  reach = 15
- attacks_monsters = true  →  attacks_monsters = false
- attack_npcs = false  →  attack_npcs = true
- trade_items = {...}  →  trade_items = {}
```

**Conditional do_custom Function**
- Added logic to detect if NPC is a witch
- Witches use `nativevillages.witch_magic.do_custom()`
- Other villagers use standard behavior function
- Maintains backward compatibility with all other villager types

### 3. Modified: init.lua
- Added `dofile(modpath .. "/witch_magic.lua")` before villagers.lua
- Ensures witch_magic module is loaded before witch registration

### 4. Modified: README.md
- Updated witch description: "Hostile magic users that attack with teleportation spells"
- Added to changelog: "Witch Magic System: Witches are now hostile monsters with teleportation magic attacks"

## Technical Details

### Attack Mechanics

**Close Range (0-1.5 blocks):**
1. Witch detects target (players, NPCs)
2. Uses standard mobs_redo melee attack
3. Deals 7 damage per hit
4. No special effects

**Medium Range (1.5-5 blocks):**
1. Witch detects target (players, NPCs)
2. Checks attack timer (4-second cooldown)
3. Validates distance (1.5-5 blocks)
4. Calculates random teleport direction (10 blocks away)
5. Teleports target to new position
6. Spawns particle effects (line + area)
7. No damage - pure disruption
8. Resets cooldown timer

**Long Range (5+ blocks):**
1. Witch chases target to get into magic range

### Particle System
- No texture files required
- Uses existing `default_cloud.png`
- Colorized to purple (hex color applied via colorize modifier)
- Two effect types: line (from witch to target) and area (around witch)
- Configurable density: 50 for line, 100 for area
- Short duration: 0.01-0.5 seconds expiration time
- Small size: 0.3-0.6 nodes
- Upward velocity: 0-1 nodes/second

### Compatibility
- Works with mobs_redo framework
- Compatible with existing mood system
- Does not interfere with other villager types
- Safe error handling prevents crashes

## Spawn Names
Witches spawn in all biomes:
- `nativevillages:grassland_witch`
- `nativevillages:desert_witch`
- `nativevillages:savanna_witch`
- `nativevillages:lake_witch`
- `nativevillages:ice_witch`
- `nativevillages:cannibal_witch`

## Behavior Comparison

### Before
- Type: monster
- Passive: true (didn't attack)
- Attack type: dogfight (unused)
- Range: 3 blocks
- Trading: yes
- Could be befriended

### After
- Type: monster
- Passive: false (actively hostile)
- Attack type: dogfight (chases targets, uses for melee)
- Range: 5 blocks (magic range)
- Trading: no
- Attacks players and NPCs
- **Dual Attack System:**
  - **Melee punch** at 0-1.5 blocks: 7 damage, standard attack
  - **Magic teleport** at 1.5-5 blocks: 10 blocks displacement, no damage
- 4-second cooldown between magic attacks (not melee)
- Purple particle effects for magic
- Magic sound effect (magic.ogg at 30% volume)

## Files Modified Summary
1. ✅ `witch_magic.lua` - Created (main magic system)
2. ✅ `villagers.lua` - Modified (witch definition + conditional do_custom)
3. ✅ `init.lua` - Modified (load order)
4. ✅ `README.md` - Modified (documentation)
5. ✅ `WITCH_MAGIC_SYSTEM.md` - Created (technical documentation)
6. ✅ `WITCH_CHANGES.md` - Created (this file)

## Testing Checklist
- [ ] Witches spawn in all biomes
- [ ] Witches are hostile to players
- [ ] Witches punch at close range (0-1.5 blocks) dealing 7 damage
- [ ] Witches cast teleport at medium range (1.5-5 blocks)
- [ ] Teleport sends player 10 blocks away in random direction
- [ ] Teleport does NOT deal damage
- [ ] Purple particle effects appear on magic attack
- [ ] 4-second cooldown between magic attacks (not melee)
- [ ] No errors in debug.txt
- [ ] Other villager types unaffected
- [ ] Witches don't crash on serialization

## Inspiration Source
Based on the witches mod `magic.lua` file, specifically:
- `witches.magic.teleport()` function (main inspiration)
- `witches.magic.effect_line01()` for particle lines
- `witches.magic.effect_area01()` for particle areas
- `pos_to_vol()` helper function

## Key Differences from Original
1. Uses greeting particles (`default_cloud.png^[colorize:purple:150`)
2. No texture-based magic particles (no fireflies/bubbles)
3. Integrated with Native Villages mod system
4. Works with mobs_redo instead of custom mob API
5. Only teleport attack implemented (no polymorph or splash spells)
6. Purple theme instead of generic magic particles
