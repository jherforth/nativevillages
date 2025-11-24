-- house_spawning.lua
-- Handles detection of village houses and spawning villagers inside them

local S = minetest.get_translator("nativevillages")

-- Track which houses have already spawned villagers
local houses_with_villagers = {}

-- Define house types and their associated biomes
local house_types = {
	-- Grassland houses
	{pattern = "grasslandhouse", biome = "grassland", size = {x=7, y=9, z=7}},
	{pattern = "grasslandhouse", biome = "grassland", size = {x=6, y=7, z=7}},
	{pattern = "grasslandhouse", biome = "grassland", size = {x=10, y=10, z=9}},
	{pattern = "grasslandhouse", biome = "grassland", size = {x=7, y=7, z=9}},
	{pattern = "grasslandhouse", biome = "grassland", size = {x=6, y=6, z=6}},

	-- Desert houses
	{pattern = "deserthouse", biome = "desert", size = {x=12, y=14, z=9}},
	{pattern = "deserthouse", biome = "desert", size = {x=8, y=7, z=8}},
	{pattern = "deserthouse", biome = "desert", size = {x=8, y=10, z=8}},
	{pattern = "deserthouse", biome = "desert", size = {x=10, y=8, z=7}},
	{pattern = "deserthouse", biome = "desert", size = {x=10, y=6, z=8}},

	-- Ice houses
	{pattern = "icehouse", biome = "ice", size = {x=7, y=9, z=7}},
	{pattern = "icehouse", biome = "ice", size = {x=7, y=7, z=9}},
	{pattern = "icehouse", biome = "ice", size = {x=6, y=6, z=6}},
	{pattern = "icehouse", biome = "ice", size = {x=6, y=7, z=7}},
	{pattern = "icehouse", biome = "ice", size = {x=7, y=4, z=7}},

	-- Lake houses
	{pattern = "lakehouse", biome = "lake", size = {x=12, y=11, z=15}},
	{pattern = "lakehouse", biome = "lake", size = {x=6, y=8, z=8}},
	{pattern = "lakehouse", biome = "lake", size = {x=5, y=9, z=9}},
	{pattern = "lakehouse", biome = "lake", size = {x=5, y=9, z=9}},
	{pattern = "lakehouse", biome = "lake", size = {x=6, y=11, z=10}},

	-- Savanna houses
	{pattern = "savannahouse", biome = "savanna", size = {x=7, y=9, z=7}},
	{pattern = "savannahouse", biome = "savanna", size = {x=9, y=8, z=9}},
	{pattern = "savannahouse", biome = "savanna", size = {x=7, y=5, z=8}},
	{pattern = "savannahouse", biome = "savanna", size = {x=7, y=9, z=9}},
	{pattern = "savannahouse", biome = "savanna", size = {x=7, y=6, z=7}},

	-- Jungle houses
	{pattern = "junglehouse", biome = "cannibal", size = {x=7, y=26, z=7}},
	{pattern = "junglehouse", biome = "cannibal", size = {x=7, y=25, z=7}},
	{pattern = "junglehouse", biome = "cannibal", size = {x=7, y=25, z=7}},
	{pattern = "junglehouse", biome = "cannibal", size = {x=7, y=26, z=7}},
	{pattern = "junglehouse", biome = "cannibal", size = {x=7, y=28, z=7}},
}

-- Villager classes that can spawn in houses (excluding hostile types)
local friendly_classes = {"farmer", "blacksmith", "fisherman", "cleric", "bum", "entertainer", "witch", "jeweler", "ranger"}

-- Get a unique key for a house position
local function get_house_key(pos)
	return math.floor(pos.x) .. "," .. math.floor(pos.y) .. "," .. math.floor(pos.z)
end

-- Check if a position is inside a house structure
local function is_house_position(pos, house_type)
	local half_x = math.floor(house_type.size.x / 2)
	local half_z = math.floor(house_type.size.z / 2)

	-- Check for common house blocks in area
	local search_area = {
		{x=pos.x-half_x, y=pos.y, z=pos.z-half_z},
		{x=pos.x+half_x, y=pos.y+house_type.size.y, z=pos.z+half_z}
	}

	-- Look for solid blocks that would indicate a structure
	local nodes = minetest.find_nodes_in_area(search_area[1], search_area[2],
		{"group:wood", "group:stone", "default:clay", "default:cobble", "default:stonebrick", "default:brick"})

	return #nodes > 20  -- If we find more than 20 structure blocks, it's likely a house
end

-- Find a suitable spawn position inside a house
local function find_spawn_position_in_house(center_pos, house_type)
	local half_x = math.floor(house_type.size.x / 2)
	local half_z = math.floor(house_type.size.z / 2)

	-- Search for air blocks on the ground floor (first 3 blocks of height)
	for x = -half_x+1, half_x-1 do
		for z = -half_z+1, half_z-1 do
			for y = 0, 3 do
				local check_pos = {x=center_pos.x+x, y=center_pos.y+y, z=center_pos.z+z}
				local node = minetest.get_node(check_pos)
				local below = minetest.get_node({x=check_pos.x, y=check_pos.y-1, z=check_pos.z})

				-- Found a good spot: air block with solid floor
				if node.name == "air" and below.name ~= "air" then
					return check_pos
				end
			end
		end
	end

	-- Fallback: just spawn at center + 1 up
	return {x=center_pos.x, y=center_pos.y+1, z=center_pos.z}
end

-- Spawn a random villager in a house
local function spawn_villager_in_house(house_pos, biome)
	local house_key = get_house_key(house_pos)

	-- Don't spawn if already spawned here
	if houses_with_villagers[house_key] then
		return
	end

	-- Pick a random friendly class
	local class_name = friendly_classes[math.random(1, #friendly_classes)]
	local mob_name = "nativevillages:" .. biome .. "_" .. class_name

	-- Find spawn position
	local spawn_pos = find_spawn_position_in_house(house_pos, {size = {x=10, y=10, z=10}})

	-- Spawn the villager
	local entity = minetest.add_entity(spawn_pos, mob_name)

	if entity then
		local luaentity = entity:get_luaentity()
		if luaentity then
			-- Store house position in the villager's data
			luaentity.nv_house_pos = house_pos
			luaentity.nv_home_radius = 20

			minetest.log("action", "[nativevillages] Spawned " .. class_name .. " in " .. biome .. " house at " .. minetest.pos_to_string(house_pos))
		end

		-- Mark this house as occupied
		houses_with_villagers[house_key] = true
	end
end

-- Scan for houses in newly generated chunks
minetest.register_on_generated(function(minp, maxp, blockseed)
	-- Delay the scan to let decorations finish placing
	minetest.after(3, function()
		-- Look for village-specific marker blocks that only appear in buildings
		local village_markers = {
			grassland = {"nativevillages:grasslandbarrel", "nativevillages:grasslandaltar"},
			desert = {"nativevillages:hookah", "nativevillages:desertcarpet", "nativevillages:desertcage"},
			ice = {"nativevillages:sledge"},
			lake = {"nativevillages:fishtrap", "nativevillages:hangingfish"},
			savanna = {"nativevillages:savannashrine", "nativevillages:savannathrone", "nativevillages:savannavessels"},
			cannibal = {"nativevillages:cannibalshrine", "nativevillages:driedpeople"}
		}

		-- Search near surface level only (y between -5 and 60)
		local surface_min = {x=minp.x, y=math.max(minp.y, -5), z=minp.z}
		local surface_max = {x=maxp.x, y=math.min(maxp.y, 60), z=maxp.z}

		-- Check each biome's markers
		for biome_name, markers in pairs(village_markers) do
			local found_markers = minetest.find_nodes_in_area(surface_min, surface_max, markers)

			-- For each marker found, spawn a villager nearby
			for _, marker_pos in ipairs(found_markers) do
				local house_key = get_house_key(marker_pos)

				-- Don't spawn if already spawned near this marker
				if not houses_with_villagers[house_key] then
					-- Find a good spawn position near the marker
					local spawn_pos = nil

					-- Search for air block with floor nearby
					for radius = 1, 8 do
						for dx = -radius, radius do
							for dz = -radius, radius do
								for dy = -2, 3 do
									local check_pos = {
										x = marker_pos.x + dx,
										y = marker_pos.y + dy,
										z = marker_pos.z + dz
									}

									local node = minetest.get_node(check_pos)
									local below = minetest.get_node({x=check_pos.x, y=check_pos.y-1, z=check_pos.z})

									-- Found air with solid floor
									if node.name == "air" and below.name ~= "air" then
										spawn_pos = check_pos
										break
									end
								end
								if spawn_pos then break end
							end
							if spawn_pos then break end
						end
						if spawn_pos then break end
					end

					-- Spawn villager if we found a position
					if spawn_pos then
						local class_name = friendly_classes[math.random(1, #friendly_classes)]
						local mob_name = "nativevillages:" .. biome_name .. "_" .. class_name

						local entity = minetest.add_entity(spawn_pos, mob_name)

						if entity then
							local luaentity = entity:get_luaentity()
							if luaentity then
								luaentity.nv_house_pos = marker_pos
								luaentity.nv_home_radius = 20
								minetest.log("action", "[nativevillages] Spawned " .. class_name .. " in " .. biome_name .. " house at " .. minetest.pos_to_string(spawn_pos))
							end

							houses_with_villagers[house_key] = true
						end
					end
				end
			end
		end
	end)
end)

-- Save/load houses_with_villagers to world storage
local storage = minetest.get_mod_storage()

-- Load on server start
local function load_houses()
	local data = storage:get_string("houses_with_villagers")
	if data and data ~= "" then
		houses_with_villagers = minetest.deserialize(data) or {}
	end
end

-- Save periodically
local save_timer = 0
minetest.register_globalstep(function(dtime)
	save_timer = save_timer + dtime
	if save_timer > 60 then  -- Save every minute
		save_timer = 0
		storage:set_string("houses_with_villagers", minetest.serialize(houses_with_villagers))
	end
end)

-- Load on startup
load_houses()

print(S("[MOD] Luanti Villagers - House spawning loaded"))
