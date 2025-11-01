# NPC Mood & Desire System

This mod now includes a mood and desire system for NPCs, inspired by emoji indicators.

## Features

### Moods
NPCs display their current emotional state through emoji-style indicators above their heads:

- **Happy** 😊 - High mood value (80+)
- **Content** 🙂 - Good mood (60-79)
- **Neutral** 😐 - Average mood (40-59)
- **Sad** 😢 - Low mood (20-39)
- **Angry** 😠 - Very low mood (0-19)
- **Hungry** 🍖 - When hunger exceeds 80
- **Lonely** 💔 - When loneliness exceeds 80
- **Scared** 😨 - When fear exceeds 70

### Desires
NPCs will also occasionally show what they need:

- **Food** 🍞 - When hungry (hunger > 70)
- **Trade** 💰 - Random desire from owned NPCs
- **Companionship** 👥 - When lonely (loneliness > 60)
- **Safety** 🛡️ - When scared (fear > 50)
- **Rest** 💤 - When health is low (< 15)

## How It Works

### Mood Calculation
The mood system tracks several internal values that affect NPC mood:

1. **Hunger** - Increases over time, decreases when fed
2. **Loneliness** - Increases without interaction, decreases with player contact
3. **Fear** - Increases during combat, decreases when safe
4. **Health** - Affects overall mood
5. **Ownership** - Owned/tamed NPCs get a mood bonus

### Interaction Effects

- **Feeding** - Reduces hunger by 30, resets interaction timer (mood improves automatically from reduced hunger)
- **Right-clicking** - Reduces loneliness by 20 (mood improves automatically from reduced loneliness)
- **Trading** - Reduces loneliness by 25 and hunger by 15, resets interaction timer (best overall mood improvement)
- **Combat** - Increases fear significantly (reduces mood)

### Trading

NPCs have a trading system that significantly improves their mood:
- **Grassland Female**: Give bread (any type) to receive random items from their drop list
- Trading reduces both loneliness (-25) and hunger (-15), providing the best overall mood improvement
- Shows the "trade" desire icon when mood calculation suggests they want to trade
- Use trading to quickly improve a sad or angry NPC's mood

**Note:** Mood is calculated automatically from underlying stats (hunger, loneliness, fear, health). When you reduce hunger or loneliness through interactions, the mood updates accordingly.

### Persistence
All mood data is saved when NPCs are unloaded and restored when they reload, ensuring NPCs remember their emotional state.

## Implementation Status

The mood system is implemented on all NPCs with trading:

**Grassland NPCs:**
- Grassland Female (trades bread)
- Grassland Male (trades bread)
- Grassland Witch (trades diamond)

**Savanna NPCs:**
- Savanna Doctor (trades graves for tame zombies)
- Savanna Queen (trades diamond)
- Savanna King (trades diamond)
- Savanna Female (trades pearl)

**Lake NPCs:**
- Lake Fisher (trades gold_lump for catfish)

**Desert NPCs:**
- Desert Villager Male (trades stick)
- Desert Villager Female (trades stick)
- Desert Slave Trader (trades gold_ingot)

**Slave NPCs:**
- Slave Lion Trainer (trades gold_lump for lions)
- Slave Female Dancer (trades gold_lump)
- Slave Male Dancer (trades gold_lump)

**Note:** Jungle/Cannibal NPCs do not have trading mechanics, so the mood system is not applicable to them.

**Textures:** Basic placeholder textures are included for testing. For better visuals, replace the texture files in `/textures/` with custom designs (see TEXTURE_LIST.md for specifications and design tips).

## Extending to Other NPCs

To add mood tracking to other NPC types, add these callbacks to the mob definition:

```lua
do_custom = function(self, dtime)
    nativevillages.mood.update_mood(self, dtime)
    return true
end,

on_activate = function(self, staticdata, dtime)
    if staticdata and staticdata ~= "" then
        local data = minetest.deserialize(staticdata)
        if data then
            nativevillages.mood.on_activate_extra(self, data)
        end
    end
    nativevillages.mood.init_npc(self)
end,

get_staticdata = function(self)
    local mood_data = nativevillages.mood.get_staticdata_extra(self)
    return minetest.serialize(mood_data)
end,
```

And update interaction handlers:

```lua
on_rightclick = function(self, clicker)
    nativevillages.mood.on_interact(self, clicker)

    -- After successful feeding:
    if mobs:feed_tame(self, clicker, 8, true, true) then
        nativevillages.mood.on_feed(self, clicker)
        return
    end

    -- After successful trading:
    -- (check for trade item and complete trade, then:)
    nativevillages.mood.on_trade(self, clicker)

    -- Rest of your existing code...
end,
```

## Technical Details

The system uses:
- Entity attachment for visual indicators (sprite entities attached above NPC heads)
- Minetest's get_staticdata/on_activate for persistence
- Texture-based mood/desire icons (20x20 pixels)
- 5-second update intervals for performance
- Icon size: 0.5x0.5 visual_size for subtle display

## Available Mood Functions

- `nativevillages.mood.init_npc(self)` - Initialize mood system for an NPC
- `nativevillages.mood.update_mood(self, dtime)` - Update mood state (call in do_custom)
- `nativevillages.mood.on_interact(self, clicker)` - Call when player right-clicks NPC (-20 loneliness)
- `nativevillages.mood.on_feed(self, clicker)` - Call after successful feeding (-30 hunger)
- `nativevillages.mood.on_trade(self, clicker)` - Call after successful trade (-25 loneliness, -15 hunger)
- `nativevillages.mood.on_activate_extra(self, data)` - Restore mood data from staticdata
- `nativevillages.mood.get_staticdata_extra(self)` - Get mood data for saving

**Important:** These functions modify the underlying stats (hunger, loneliness, fear). Mood value is automatically calculated from these stats every 5 seconds.
