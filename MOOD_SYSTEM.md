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

- **Feeding** - Reduces hunger by 30, boosts mood by 15 points, resets interaction timer
- **Right-clicking** - Reduces loneliness by 20, boosts mood by 5 points
- **Trading** - Reduces loneliness by 25, boosts mood by 20 points, resets interaction timer
- **Combat** - Increases fear significantly

### Trading

NPCs have a trading system that significantly improves their mood:
- **Grassland Female**: Give bread (any type) to receive random items from their drop list
- Trading provides the largest mood boost (+20) compared to feeding (+15) or simple interaction (+5)
- Shows the "trade" desire icon when mood calculation suggests they want to trade
- Use trading to quickly improve a sad or angry NPC's mood

### Persistence
All mood data is saved when NPCs are unloaded and restored when they reload, ensuring NPCs remember their emotional state.

## Implementation Status

Currently implemented on:
- Grassland Female NPCs (nativevillages:grasslandfemale)

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

    -- Rest of your existing code...
end,
```

## Technical Details

The system uses:
- Entity attachment for visual indicators
- Minetest's get_staticdata/on_activate for persistence
- Entity nametags for emoji display
- 5-second update intervals for performance
