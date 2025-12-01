# Chest Formspec Fix

## The Problem
Chests from village schematics showed only the player's inventory (bottom 4 rows) with no chest inventory slots visible. The UI looked broken - just a large empty gray area above the player inventory.

## Root Cause
The LBM was filling the chest inventory with items but wasn't setting the **formspec metadata**.

In Minetest, inventory nodes need TWO things:
1. **Inventory data** - The actual items stored
2. **Formspec metadata** - UI definition telling the game how to display the inventory

Without the formspec metadata, Minetest doesn't know:
- How many slots to show
- Where to position them
- How to layout the UI

The default chest node definition usually handles this on placement, but schematic chests bypass normal placement, so their metadata never gets initialized.

## The Fix

Added formspec and infotext metadata to the LBM:

```lua
local meta = minetest.get_meta(pos)

-- Set formspec (defines the UI layout)
meta:set_string("formspec",
    "size[8,9]" ..                           -- Window size: 8 cols, 9 rows
    "list[context;main;0,0;8,4;]" ..        -- Chest inventory: top 4 rows (32 slots)
    "list[current_player;main;0,5;8,4;]" .. -- Player inventory: bottom 4 rows
    "listring[context;main]" ..             -- Enable shift-click from chest
    "listring[current_player;main]")        -- Enable shift-click to chest

-- Set infotext (hover tooltip)
meta:set_string("infotext", "Chest")
```

## What Each Line Does

### `size[8,9]`
Total window dimensions: 8 columns wide, 9 rows tall

### `list[context;main;0,0;8,4;]`
- `context` = this chest node
- `main` = the "main" inventory list
- `0,0` = position (top-left corner)
- `8,4` = size (8 columns × 4 rows = 32 slots)

This creates the chest's inventory display at the top of the window.

### `list[current_player;main;0,5;8,4;]`
- `current_player` = the player viewing the chest
- `main` = player's main inventory
- `0,5` = position (starting at row 5, below chest inventory)
- `8,4` = size (8 columns × 4 rows = 32 slots)

This creates the player's inventory display at the bottom.

### `listring[context;main]` and `listring[current_player;main]`
These enable shift-clicking to quickly move items between the chest and player inventories.

## Why This Wasn't Needed Before

When a player manually places a chest, the `default:chest` node definition has an `after_place_node` callback that sets up the metadata automatically:

```lua
-- From minetest_game's default:chest definition
after_place_node = function(pos, placer)
    local meta = minetest.get_meta(pos)
    meta:set_string("infotext", "Chest")
    -- Formspec is set in on_construct
end
```

But schematic decorations bypass these callbacks entirely - the nodes just appear during mapgen with no setup. That's why our LBM needs to do the setup manually.

## Expected Result

After this fix, village chests should show:
```
┌─────────────────────────────────┐
│  [Chest Inventory - 32 slots]  │ ← Top 4 rows (chest)
│  [    visible and usable    ]  │
├─────────────────────────────────┤
│ [Player Inventory - 32 slots]  │ ← Bottom 4 rows (player)
│ [    your normal inventory  ]  │
└─────────────────────────────────┘
```

## Testing

1. Generate NEW chunks with villages (old chunks won't have this fix)
2. Find a village building with a chest
3. Right-click the chest
4. You should see:
   - Top 4 rows: Chest inventory with loot items
   - Bottom 4 rows: Your player inventory
   - Ability to click/drag items between them
   - Shift-click works to quick-move items

## Technical Notes

### Why context vs current_player?
- `context` refers to the node being interacted with (the chest)
- `current_player` refers to the player viewing the formspec
- This distinction is important for multiplayer where multiple players might access the same chest

### Inventory Size
- `inv:set_size("main", 8*4)` sets the chest to 32 slots
- This matches the formspec display of `8,4` (8×4 = 32)
- If these don't match, items may be invisible or slots may be empty

### Metadata Persistence
- Metadata is saved with the world
- Once set, it persists even after server restart
- LBM's `run_at_every_load = false` ensures we only set it once

## Related Issues

This fix resolves:
- Empty/broken chest UI
- Invisible inventory slots
- Unable to access chest contents
- Chest appearing to have no storage

## Files Modified
- `loot.lua` - Added formspec metadata setup in fill_chest_with_loot()
- `CRITICAL_FIXES_v2.md` - Documented the metadata requirement
