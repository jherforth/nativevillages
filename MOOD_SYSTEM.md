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

**NPCs:**
- Ranger (trades accepted: stick, wood planks, bread) (Trade drops: cooked meat, random sword)
- Jeweler (trades accepted: gold ingot, bread) (Trade drops: diamond (rare chance), mese_crystal, too_many_stones.quartz_crystal)
- Farmer (trades accpeted: any seeds, bread) (Trade drops: anamilia.lasso, leather, nametag)
- Blacksmith (trades accepted: any ingot, coal_lump, bread) (Trade drops: steel_bucket, any sword (diamond rare), any pickaxe (diamond rare))
- Fisherman (trades accepted: stick, farming.string, bread) (Trade drops: ethereal.fishing_rod, any fish)
- Cleric (trades accepted: book, gold_ingot, bread) (Trade drops: mese_crystal, people.firstaidkit)
- Bum (trades accepted: bread) (Trade drops: any flower)
- Entertainer (trades accepted: none) (Trade drops: none)
- Witch (trades accepted: too_many_stones.crystal (any kind), herbs (any), bread) (Trade drops: bottle (any), ethereal.flight_potion (rare)

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

