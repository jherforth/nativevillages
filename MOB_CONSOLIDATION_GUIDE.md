# Mob Consolidation Guide

## Overview

You've added `villagermale.b3d` and `villagerfemale.b3d` models. This guide explains how to consolidate multiple similar villager mobs into single entities with texture variants.

## Current Villager Mobs

### Male Villagers
- `nativevillages:grasslandmale` (Grasslandmale.b3d)
- `nativevillages:lakevillagermale` (Lakevillagermale.b3d)
- `nativevillages:savannamale` (Savannamale.b3d)
- `nativevillages:icevillagermale` (Icevillagermale.b3d)
- `nativevillages:desertvillagermale` (Desertvillagermale.b3d)
- Various jungle villagers (check junglecreatures.lua)

### Female Villagers
- `nativevillages:grasslandfemale` (Grasslandfemale.b3d)
- `nativevillages:lakevillagerfemale` (Lakevillagerfemale.b3d)
- `nativevillages:savannafemale` (Savannafemale.b3d)
- `nativevillages:icevillagerfemale` (Icevillagerfemale.b3d)
- `nativevillages:desertvillagerfemale` (Desertvillagerfemale.b3d)
- Various jungle villagers (check junglecreatures.lua)

## Consolidation Strategy

### Step 1: Prepare Texture Arrays

For each consolidated mob type, gather all texture variants:

**Example for Male Villagers:**
```lua
local male_textures = {
    -- Grassland
    {"texturegrasslandmale.png"},
    {"texturegrasslandmale2.png"},
    {"texturegrasslandmale3.png"},
    {"texturegrasslandmale4.png"},

    -- Lake
    {"texturelakevillagermale.png"},
    {"texturelakevillagermale2.png"},
    {"texturelakevillagermale3.png"},

    -- Savanna
    {"texturesavannamale.png"},
    {"texturesavannamale2.png"},
    {"texturesavannamale3.png"},
    {"texturesavannamale4.png"},

    -- Ice
    {"textureicevillagermale.png"},
    {"textureicevillagermalebaby.png"},

    -- Desert
    {"texturedesertvillagermale.png"},
    {"texturedesertvillagermale2.png"},
    {"texturedesertvillagermale3.png"},
    {"texturedesertvillagermale4.png"},
    {"texturedesertvillagermale5.png"},
}
```

### Step 2: Create Consolidated Mob

Create a single "generic" male villager:

```lua
mobs:register_mob("nativevillages:villager_male", {
    stepheight = 1,
    type = "npc",
    passive = false,
    attack_type = "dogfight",
    group_attack = true,
    owner_loyal = true,
    attack_npcs = false,
    reach = 2,
    damage = 4,
    hp_min = 20,
    hp_max = 50,
    armor = 100,
    collisionbox = {-0.25, -0.01, -0.25, 0.25, 1.75, 0.25},
    visual = "mesh",
    mesh = "villagermale.b3d",  -- Use the new unified model
    textures = male_textures,    -- All texture variants
    makes_footstep_sound = true,
    sounds = {
        -- Use a generic sound or randomly select from different sets
        random = "nativevillages_grasslandmale",
        attack = "nativevillages_grasslandmale2",
    },
    walk_velocity = 1,
    run_velocity = 2,
    jump = true,
    drops = {},
    water_damage = 0,
    lava_damage = 4,
    light_damage = 0,
    follow = {},
    view_range = 15,
    owner = "",
    order = "follow",
    fear_height = 3,
    animation = {
        speed_normal = 30,
        stand_start = 0,
        stand_end = 79,
        walk_start = 168,
        walk_end = 187,
        run_start = 168,
        run_end = 187,
        punch_start = 200,
        punch_end = 219,
    },
    do_custom = function(self, dtime)
        self.nv_trade_items = {"farming:bread", "default:diamond"}
        nativevillages.mood.update_mood(self, dtime)
        return true
    end,
    -- Standard interaction callbacks here
})
```

### Step 3: Update Spawn Decorations

Modify spawning to use the consolidated mob but preserve biome characteristics:

```lua
-- Grassland spawns
mobs:spawn({
    name = "nativevillages:villager_male",
    nodes = {"default:dirt_with_grass"},
    max_light = 14,
    min_light = 0,
    chance = 50000,
    active_object_count = 2,
    min_height = 0,
    max_height = 200,
})

-- Desert spawns (same mob, different location)
mobs:spawn({
    name = "nativevillages:villager_male",
    nodes = {"default:desert_sand"},
    max_light = 14,
    min_light = 0,
    chance = 50000,
    active_object_count = 2,
    min_height = 0,
    max_height = 200,
})

-- Continue for all biomes...
```

### Step 4: Handle Biome-Specific Behavior (Optional)

If certain villagers need biome-specific traits, add logic to `do_custom`:

```lua
do_custom = function(self, dtime)
    -- Detect biome on first spawn
    if not self.biome_type then
        local pos = self.object:get_pos()
        local biome_data = minetest.get_biome_data(pos)
        local biome_name = minetest.get_biome_name(biome_data.biome)

        if string.find(biome_name, "desert") then
            self.biome_type = "desert"
            self.nv_trade_items = {"default:cactus", "default:sand"}
        elseif string.find(biome_name, "grassland") then
            self.biome_type = "grassland"
            self.nv_trade_items = {"farming:bread", "farming:wheat"}
        elseif string.find(biome_name, "savanna") then
            self.biome_type = "savanna"
            self.nv_trade_items = {"default:dry_grass_1", "default:gold_lump"}
        -- ... etc
        else
            self.biome_type = "generic"
            self.nv_trade_items = {"default:diamond"}
        end
    end

    nativevillages.mood.update_mood(self, dtime)
    return true
end
```

## Performance Impact

### Before Consolidation
- 10+ separate male villager mob definitions
- 10+ separate female villager mob definitions
- Each loads separately into memory
- Total: ~20+ mob types just for villagers

### After Consolidation
- 1 male villager mob definition
- 1 female villager mob definition
- Texture variants handled by array
- Total: 2 mob types with variants

**Estimated Performance Gain:**
- 90% reduction in villager mob registrations
- Reduced memory footprint
- Simpler codebase maintenance
- All functionality preserved

## Implementation Checklist

- [ ] Create `villagermale.b3d` model (already done)
- [ ] Create `villagerfemale.b3d` model (already done)
- [ ] Gather all male villager textures into array
- [ ] Gather all female villager textures into array
- [ ] Create consolidated male villager mob
- [ ] Create consolidated female villager mob
- [ ] Update all spawn decorations
- [ ] Test in-game spawning in all biomes
- [ ] Verify texture variants display correctly
- [ ] Test trading and interactions
- [ ] Test mood system still works
- [ ] Remove old mob definitions
- [ ] Clean up unused code

## Files to Modify

1. **grasslandcreatures.lua** - Contains grassland male/female
2. **lakecreatures.lua** - Contains lake male/female
3. **savannacreatures.lua** - Contains savanna male/female
4. **arcticcreatures.lua** - Contains ice male/female
5. **desertcreatures.lua** - Contains desert male/female
6. **junglecreatures.lua** - Check for jungle villagers

## Special Considerations

### Sounds
Different biomes currently have different sound sets. Options:
1. **Random Selection**: Pick random sound from all sets
2. **Biome Detection**: Use biome-specific sounds based on spawn location
3. **Generic Sounds**: Use one sound set for all

### Trading Items
Each villager type has different trade items. Options:
1. **Biome Detection**: Set trade items based on spawn biome (recommended)
2. **Random**: All villagers can trade all items
3. **Player Distance**: Change items based on nearby biome blocks

### Animation
Ensure the new `villagermale.b3d` and `villagerfemale.b3d` models have compatible animation frames with the existing models, or update animation definitions accordingly.

## Example: Complete Male Consolidation

See `/tmp/cc-agent/59525646/project/EXAMPLE_CONSOLIDATED_MALE.lua` (to be created) for a complete working example.

## Testing

After consolidation:
1. Visit each biome type
2. Verify villagers spawn
3. Check textures display correctly
4. Test trading
5. Test mood system
6. Test combat
7. Verify sounds play
8. Check performance improvement

## Rollback Plan

Keep backup copies of original creature files before consolidation. If issues arise, can revert to biome-specific mobs.
