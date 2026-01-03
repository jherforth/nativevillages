# Witch Magic System

This document describes the witch magic system implemented in the Native Villages mod.

## Overview

Witches are now properly hostile monsters that use magic attacks instead of melee combat. The magic system is inspired by the witches mod but uses the greeting particles from villager_behaviors.lua instead of texture-based particles.

## Key Features

### 1. Monster Type
- **Type**: monster
- **Passive**: false (actively hostile)
- **Attacks**: Players and NPCs
- **Range**: 15 blocks (longer than melee)

### 2. Magic Attack: Teleport
The witch's primary attack is a teleport spell that:
- Throws the target away from the witch
- Lifts the target into the air
- Deals 7 damage
- Has a 4-second cooldown between attacks
- Works at range (3-15 blocks)
- Creates purple particle effects using greeting-style particles

### 3. Particle Effects
Instead of using texture-based particles, the witch magic uses the same particle system as the greeting particles in villager_behaviors.lua:
- **Texture**: `default_cloud.png^[colorize:purple:150`
- **Color**: Purple (to indicate hostile magic)
- **Glow**: 10
- **Effects**:
  - Line effect from witch to target
  - Area effect around the witch when casting

### 4. Attack Behavior
- Witches only attack when they have a target
- Minimum distance: 3 blocks (need some distance to cast)
- Maximum distance: 15 blocks (magic range)
- Cooldown: 4 seconds between attacks
- Attack type: "dogfight" (will chase targets)

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
