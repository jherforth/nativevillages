# Witch Magic System

This document describes the witch magic system implemented in the Native Villages mod.

## Overview

Witches are now properly hostile monsters with two distinct attack types: melee punches for close combat and magic teleportation for medium range. The magic system is inspired by the witches mod but uses the greeting particles from villager_behaviors.lua instead of texture-based particles.

## Key Features

### 1. Monster Type
- **Type**: monster
- **Passive**: false (actively hostile)
- **Attacks**: Players and NPCs
- **Range**: 5 blocks (magic range)

### 2. Melee Punch Attack (Close Range)
When the witch is very close to the target (0-1 blocks):
- Uses standard mobs_redo dogfight attack
- Deals 7 damage per hit
- Standard melee timing (less frequent than magic)
- No special effects
- Automatic when in close range

### 3. Magic Attack: Teleport (Medium Range)
When the witch is at medium distance (1-5 blocks):
- Teleports target 10 blocks away in a random direction
- **NO DAMAGE** - pure disruption/displacement
- Random direction (360 degrees, keeps same Y-level)
- Has a 2-second cooldown between magic attacks (more frequent than melee)
- Creates purple particle effects using greeting-style particles
- Plays magic.ogg sound when casting (10% volume)
- Forces target to reposition and re-engage

### 4. Particle Effects
Instead of using texture-based particles, the witch magic uses the same particle system as the greeting particles in villager_behaviors.lua:
- **Texture**: `default_cloud.png^[colorize:purple:150`
- **Color**: Purple (to indicate hostile magic)
- **Glow**: 10
- **Effects**:
  - Line effect from witch to target
  - Area effect around the witch when casting

### 5. Attack Behavior Strategy
Witches use a dual-attack strategy based on distance:

**Close Range (0-1 blocks):**
- Automatically uses melee punch attack
- Deals 7 damage per hit
- No special effects or sounds
- Standard mobs_redo dogfight behavior
- Less frequent than magic attacks

**Medium Range (1-5 blocks):**
- Uses magic teleport attack
- Teleports target 10 blocks away randomly
- No damage (disruption only)
- 2-second cooldown between magic casts (more frequent)
- Purple particle effects and magic sound

**Long Range (5+ blocks):**
- Chases target to get within magic range
- Attack type: "dogfight" (will pursue)

**Combat Flow:**
1. Witch spots player/NPC
2. Chases if too far away (5+ blocks)
3. Casts teleport when in range (1-5 blocks) every 2 seconds
4. Punches if player gets too close (within 1 block)
5. Magic attacks are more frequent, making them the primary threat
6. Player must carefully manage distance to avoid both attacks

## Technical Implementation

### Files Modified
1. **villagers.lua**:
   - Changed witch to `passive = false`
   - Increased reach to 15
   - Removed trade items
   - Added custom do_custom function for witches

2. **init.lua**:
   - Added witch_magic.lua to load order

### Files Created
1. **witch_magic.lua**: Complete magic system implementation
   - Particle effect functions
   - Teleport attack function
   - Custom attack behavior
   - Witch-specific do_custom function

## Spawning

Witches spawn in all biomes (grassland, desert, savanna, lake, ice, cannibal) with the suffix "_witch":
- nativevillages:grassland_witch
- nativevillages:desert_witch
- nativevillages:savanna_witch
- nativevillages:lake_witch
- nativevillages:ice_witch
- nativevillages:cannibal_witch

## Drops

Witches drop:
- Mese crystal (100% chance, 0-1)
- Zombie tame item (33% chance, 0-1)

## Comparison with Inspiration

### From witches mod magic.lua:
- ✓ Teleport function (main attack)
- ✓ Line particle effects
- ✓ Area particle effects
- ✓ Directional throwing mechanic
- ✗ Polymorph spell (not implemented)
- ✗ Splash spell (not implemented)

### Differences:
- Uses greeting particles instead of firefly/bubble textures
- Integrated into Native Villages villager system
- Works with mobs_redo framework
- Purple color theme for hostile magic
