# Witch Dual-Attack System Update

## Changes Made

Modified witch combat system from single magic attack to dual-attack system with range-based behavior.

**Latest Update:** Adjusted attack ranges and frequency:
- Melee range reduced to 1 block (was 1.5 blocks)
- Magic range expanded to 1-5 blocks (was 1.5-5 blocks)
- Magic cooldown reduced to 2 seconds (was 4 seconds) - more frequent attacks
- Magic is now the primary attack method

## What Changed

### witch_magic.lua

**Before:**
- Single teleport attack that dealt 7 damage
- Minimal displacement (0.8 blocks horizontal, 0.5 blocks vertical)
- Used at 1.5-5 block range

**After:**
- **Two attack types:**
  1. **Melee Punch (0-1.5 blocks):** Standard dogfight attack, 7 damage
  2. **Magic Teleport (1.5-5 blocks):** Displaces target 10 blocks, NO damage

**Code Changes:**
```lua
# OLD
function nativevillages.witch_magic.teleport_attack(self, target, strength, height)
    # Threw target away by 0.8 blocks and up by 0.5 blocks
    # Dealt 7 damage

# NEW
function nativevillages.witch_magic.teleport_attack(self, target, distance)
    # Teleports target 10 blocks away in RANDOM direction
    # NO DAMAGE - pure disruption
    local angle = math.random() * math.pi * 2
    local offset_x = math.cos(angle) * distance
    local offset_z = math.sin(angle) * distance
```

## Combat Strategy

### Range-Based Attacks

**Close Range (0-1 blocks):**
- Witch uses standard melee punch
- Deals 7 damage per hit
- Standard melee timing (less frequent)
- Player takes damage but isn't displaced
- Only happens when within 1 block

**Medium Range (1-5 blocks):**
- Witch casts teleport spell (primary attack)
- Teleports player 10 blocks away in random direction
- **NO DAMAGE** - pure displacement
- 2-second cooldown (more frequent than melee)
- Purple particles and magic sound
- Forces player to reposition
- Main threat due to wider range and faster cooldown

**Long Range (5+ blocks):**
- Witch chases target
- Will pursue until in magic range

### Player Tactics

Players must now:
- **Stay out of 1-block range** to prevent taking melee damage
- **Beware 1-5 block zone** where magic attacks happen frequently (every 2 seconds)
- **Use positioning** to control engagement distance
- **Deal with randomness** - can't predict teleport direction
- **Magic is main threat** - more frequent and wider range than melee

## Technical Details

### Teleport Direction
```lua
local angle = math.random() * math.pi * 2  -- Random 0 to 2π (360 degrees)
local offset_x = math.cos(angle) * 10      -- X component
local offset_z = math.sin(angle) * 10      -- Z component
```

### Y-Level Preservation
The teleport keeps the player at the same Y-level (height), only changing X and Z coordinates.

### Damage Removal
```lua
-- OLD CODE (removed):
if target:is_player() then
    target:set_hp(target:get_hp() - 7)
end

-- NEW CODE:
-- NO DAMAGE - teleport only!
-- Melee punch (dogfight) attack handles damage separately
```

## Benefits

1. **More Dynamic Combat:** Players must adapt to two distinct threats
2. **Range Management:** Distance matters strategically
3. **Unpredictable:** Random teleport direction adds challenge
4. **Clearer Roles:** Melee for damage, magic for disruption
5. **Better Balance:** Teleport is less punishing without damage, but still effective

## Files Modified

- `witch_magic.lua` - Changed teleport function, removed damage
- `WITCH_MAGIC_SYSTEM.md` - Updated documentation
- `WITCH_CHANGES.md` - Updated behavior description
- `README.md` - Updated witch description and changelog
- `SESSION_SUMMARY.md` - Updated session summary

## Testing Checklist

- [ ] Witches punch at 0-1 blocks dealing 7 damage
- [ ] Witches teleport at 1-5 blocks
- [ ] Teleport sends player 10 blocks away (not 0.8)
- [ ] Teleport direction is random (not always away from witch)
- [ ] Teleport does NOT deal damage
- [ ] Player stays at same Y-level after teleport
- [ ] 2-second cooldown applies to magic (more frequent than melee)
- [ ] Magic attacks happen more often than melee
- [ ] Purple particles only appear on magic attacks
- [ ] Magic sound only plays on magic attacks (at 10% volume)

## Compatibility

This change is backward compatible:
- Existing witch entities will use new behavior immediately
- No save file changes needed
- Works with all biomes
- No texture or sound file changes required
