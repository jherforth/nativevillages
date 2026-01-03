# Witch Modification Summary

## Overview
Witches have been transformed from passive NPCs into hostile monsters with magic attack abilities, inspired by the witches mod but using the greeting particle system instead of texture-based particles.

## Changes Made

### 1. New File: witch_magic.lua
Created a complete magic system for witches with the following features:

**Particle Effects**
- `effect_area()`: Creates area-based particle effects using greeting-style particles
- `effect_line()`: Creates line-based particle effects between two points
- Uses `default_cloud.png^[colorize:purple:150` instead of any texture-based particles
- Purple color theme to indicate hostile magic
- Glow value of 10 for visibility

**Teleport Attack**
- Primary witch attack: throws targets away and upward
- Default strength: 8 blocks horizontal displacement
- Default height: 5 blocks vertical lift
- Deals 7 damage to target
- Works on both players and entities
- Visual feedback with line and area particle effects
- Sound support (if attack sounds are defined)

**Custom Attack Behavior**
- 4-second cooldown between attacks
- Attack range: 3-15 blocks (witches need distance to cast)
- Only attacks when target is in range
- Automatic timer management per witch entity

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
1. Witch detects target (players, NPCs)
2. Checks attack timer (4-second cooldown)
3. Validates distance (3-15 blocks)
4. Calculates throw direction and height
5. Teleports target to new position
6. Spawns particle effects (line + area)
7. Deals 7 damage
8. Resets cooldown timer

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
- Attack type: dogfight (chases targets)
- Range: 10 blocks (magic range)
- Trading: no
- Attacks players and NPCs
- Uses magic teleport attack
- 4-second attack cooldown
- Purple particle effects
- Magic sound effect (magic.ogg)

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
- [ ] Witches attack with teleport spell
- [ ] Purple particle effects appear on attack
- [ ] 4-second cooldown between attacks
- [ ] Witches work at 3-15 block range
- [ ] Witches deal 7 damage per attack
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
