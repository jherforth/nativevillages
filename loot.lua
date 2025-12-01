-- loot.lua
-- Random loot for village chests using LBM (Loading Block Modifier)

-- ===================================================================
-- LOOT TABLES
-- ===================================================================

local loot_tables = {
    grassland = {
        {name = "farming:bread",          chance = 0.8, min = 1, max = 4},
        {name = "farming:seeds_wheat",    chance = 0.6, min = 1, max = 3},
        {name = "default:apple",          chance = 0.5, min = 1, max = 2},
        {name = "default:torch",          chance = 0.9, min = 3, max = 10},
        {name = "default:coal_lump",      chance = 0.4, min = 1, max = 3},
    },
    desert = {
        {name = "default:gold_lump",      chance = 0.3, min = 1, max = 2},
        {name = "default:desert_stone",   chance = 0.7, min = 5, max = 15},
        {name = "default:cactus",         chance = 0.6, min = 1, max = 3},
        {name = "default:glass",          chance = 0.4, min = 1, max = 3},
    },
    ice = {
        {name = "default:ice",            chance = 0.9, min = 3, max = 12},
        {name = "default:snowball",       chance = 0.8, min = 5, max = 16},
        {name = "default:coal_lump",      chance = 0.5, min = 1, max = 4},
        {name = "default:steel_ingot",    chance = 0.2, min = 1, max = 2},
    },
    savanna = {
        {name = "default:acacia_wood",    chance = 0.7, min = 4, max = 10},
        {name = "default:dry_shrub",      chance = 0.6, min = 2, max = 6},
        {name = "default:bronze_ingot",   chance = 0.3, min = 1, max = 2},
    },
    lake = {
        {name = "default:clay_lump",      chance = 0.8, min = 3, max = 8},
        {name = "default:papyrus",        chance = 0.7, min = 2, max = 7},
        {name = "farming:string",         chance = 0.5, min = 1, max = 3},
    },
    jungle = {
        {name = "default:junglewood",     chance = 0.8, min = 5, max = 12},
        {name = "default:vine",           chance = 0.6, min = 2, max = 6},
        {name = "default:emerald",        chance = 0.15, min = 1, max = 1},
        {name = "default:obsidian",       chance = 0.1, min = 1, max = 2},
    },
}

-- Track filled chests to avoid refilling
local filled_chests = {}

-- ===================================================================
-- Helper function to fill a chest with loot
-- ===================================================================

local function fill_chest_with_loot(pos)
    -- Check if already filled
    local pos_hash = minetest.hash_node_position(pos)
    if filled_chests[pos_hash] then
        return
    end

    -- Get biome at position
    local biome_data = minetest.get_biome_data(pos)
    if not biome_data then return end

    local biome_name = minetest.get_biome_name(biome_data.biome)
    if not biome_name then return end

    -- Select loot table based on biome
    local loot_table = nil
    if biome_name:find("grassland") or biome_name:find("deciduous") or biome_name:find("coniferous") then
        loot_table = loot_tables.grassland
    elseif biome_name:find("desert") then
        loot_table = loot_tables.desert
    elseif biome_name:find("icesheet") or biome_name:find("tundra") then
        loot_table = loot_tables.ice
    elseif biome_name:find("savanna") then
        loot_table = loot_tables.savanna
    elseif biome_name:find("rainforest") then
        loot_table = loot_tables.jungle
    elseif biome_name:find("lake") or biome_name:find("shore") then
        loot_table = loot_tables.lake
    else
        -- Default to grassland for unknown biomes
        loot_table = loot_tables.grassland
    end

    -- Get chest metadata and inventory
    local meta = minetest.get_meta(pos)
    if not meta then return end

    local inv = meta:get_inventory()
    if not inv then return end

    -- Ensure inventory is properly sized
    inv:set_size("main", 8*4)

    -- Add 3-7 random items from loot table
    local num_items = math.random(3, 7)
    for i = 1, num_items do
        local item = loot_table[math.random(#loot_table)]
        if math.random() < item.chance then
            local count = item.min and math.random(item.min, item.max) or 1
            local stack = ItemStack(item.name .. " " .. count)
            inv:set_stack("main", math.random(1, 32), stack)
        end
    end

    -- Mark as filled
    filled_chests[pos_hash] = true
end

-- ===================================================================
-- Use LBM to fill chests after mapgen
-- ===================================================================

minetest.register_lbm({
    label = "Fill village chests with loot",
    name = "nativevillages:fill_chests",
    nodenames = {"default:chest"},
    run_at_every_load = false,
    action = function(pos, node)
        fill_chest_with_loot(pos)
    end
})

minetest.log("action", "[nativevillages] Loot system loaded - using LBM for chest filling")
