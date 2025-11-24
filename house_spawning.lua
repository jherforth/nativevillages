-- house_spawning.lua
-- Final polished version — 1 villager per house, realistic occupancy, no spam
-- Works perfectly with rare, beautiful villages

local S = minetest.get_translator("nativevillages")

-- Track which 16×16×16 areas already have a villager (prevents duplicates)
local houses_with_villagers = {}

-- Friendly villager classes (add/remove as you like)
local friendly_classes = {
    "farmer", "blacksmith", "fisherman", "cleric",
    "bum", "entertainer", "witch", "jeweler", "ranger"
}

-- Map every marker node to its biome
local marker_to_biome = {
    -- Grassland
    ["nativevillages:grasslandbarrel"] = "grassland",
    ["nativevillages:grasslandaltar"] = "grassland",
    -- Desert
    ["nativevillages:hookah"] = "desert",
    ["nativevillages:desertcarpet"] = "desert",
    ["nativevillages:desertcage"] = "desert",
    -- Ice
    ["nativevillages:sledge"] = "ice",
    -- Lake
    ["nativevillages:fishtrap"] = "lake",
    ["nativevillages:hangingfish"] = "lake",
    -- Savanna
    ["nativevillages:savannashrine"] = "savanna",
    ["nativevillages:savannathrone"] = "savanna",
    ["nativevillages:savannavessels"] = "savanna",
    -- Jungle
    ["nativevillages:cannibalshrine"] = "cannibal",
    ["nativevillages:driedpeople"] = "cannibal",
}

-- Build the full list of marker nodes for find_nodes_in_area
local marker_list = {}
for node, _ in pairs(marker_to_biome) do
    table.insert(marker_list, node)
end

-- Save/load system
local storage = minetest.get_mod_storage()

local function load_houses()
    local data = storage:get_string("houses_with_villagers")
    if data and data ~= "" then
        houses_with_villagers = minetest.deserialize(data) or {}
    end
end

local save_timer = 0
minetest.register_globalstep(function(dtime)
    save_timer = save_timer + dtime
    if save_timer >= 60 then
        save_timer = 0
        storage:set_string("houses_with_villagers", minetest.serialize(houses_with_villagers))
    end
end)

load_houses()

-- Main villager spawning on chunk generation
minetest.register_on_generated(function(minp, maxp, blockseed)
    minetest.after(5, function()  -- Let schematics finish placing
        local ymin = math.max(minp.y, -10)
        local ymax = math.min(maxp.y, 80)
        local search_min = {x = minp.x, y = ymin, z = minp.z}
        local search_max = {x = maxp.x, y = ymax, z = maxp.z}

        local markers = minetest.find_nodes_in_area(search_min, search_max, marker_list)
        local processed_houses = {}  -- Temporary table for this chunk

        for _, pos in ipairs(markers) do
            local node_name = minetest.get_node(pos).name
            local biome = marker_to_biome[node_name]
            if not biome then goto continue end

            -- Snap to 16×16×16 grid (includes Y level — safe for treehouses!)
            local house_key = string.format("%d,%d,%d",
                math.floor(pos.x / 16) * 16,
                math.floor(pos.y / 16) * 16,
                math.floor(pos.z / 16) * 16
            )

            -- Skip if already spawned in this area (this world session or saved)
            if houses_with_villagers[house_key] or processed_houses[house_key] then
                goto continue
            end

            -- 28% chance the house is empty (feels lived-in, not robotic)
            if math.random() < 0.28 then
                processed_houses[house_key] = true
                goto continue
            end

            -- Find a safe air spot with solid floor
            local spawn_pos = nil
            for dy = -3, 8 do
                local check = {
                    x = pos.x + math.random(-5, 5),
                    y = pos.y + dy,
                    z = pos.z + math.random(-5, 5)
                }
                local node = minetest.get_node(check)
                local below = minetest.get_node({x=check.x, y=check.y-1, z=check.z})

                if node.name == "air" and minetest.get_item_group(below.name, "solid") == 1 then
                    spawn_pos = check
                    break
                end
            end

            if not spawn_pos then
                spawn_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
            end

            -- Spawn the villager
            local class = friendly_classes[math.random(#friendly_classes)]
            local mob_name = "nativevillages:" .. biome .. "_" .. class

            local obj = minetest.add_entity(spawn_pos, mob_name)
            if obj then
                local luaent = obj:get_luaentity()
                if luaent then
                    luaent.nv_house_pos = vector.new(pos)
                    luaent.nv_home_radius = 22
                end
                houses_with_villagers[house_key] = true
                processed_houses[house_key] = true
                minetest.log("action", "[nativevillages] Villager spawned: " .. mob_name ..
                    " at " .. minetest.pos_to_string(spawn_pos))
            end

            ::continue::
        end
    end)
end)

print(S("[MOD] Native Villages - House spawning system loaded (final version)"))
