-- smart_doors.lua
-- Makes doors automatically open for NPCs

nativevillages.smart_doors = {}

-- Configuration
local DOOR_CHECK_INTERVAL = 1.0  -- Check for NPCs every second
local DOOR_DETECTION_RADIUS = 2.5  -- How close NPCs need to be
local DOOR_CLOSE_DELAY = 3  -- Seconds to wait before closing

--------------------------------------------------------------------
-- HELPER FUNCTIONS
--------------------------------------------------------------------

-- Check if a node is a door (closed)
local function is_closed_door(node_name)
	return node_name and (
		node_name:match("^doors:door_.*_b$") or
		node_name:match("^doors:hidden$")
	)
end

-- Check if a node is an open door
local function is_open_door(node_name)
	return node_name and node_name:match("^doors:door_.*_a$")
end

-- Get the open version of a door name
local function get_open_door_name(closed_name)
	return closed_name:gsub("_b$", "_a")
end

-- Get the closed version of a door name
local function get_closed_door_name(open_name)
	return open_name:gsub("_a$", "_b")
end

-- Check if there are any NPCs nearby
local function has_nearby_npcs(pos, radius)
	local objects = minetest.get_objects_inside_radius(pos, radius)

	for _, obj in ipairs(objects) do
		if obj and obj:get_luaentity() then
			local entity = obj:get_luaentity()
			-- Check if it's a villager (has the nativevillages marker)
			if entity.name and entity.name:match("^nativevillages:") then
				-- Don't open for hostile mobs
				if entity.type ~= "monster" then
					return true
				end
			end
		end
	end

	return false
end

-- Open a door
local function open_door(pos, node)
	local open_name = get_open_door_name(node.name)

	-- Check if the open door exists
	if minetest.registered_nodes[open_name] then
		minetest.swap_node(pos, {name = open_name, param1 = node.param1, param2 = node.param2})

		-- Play door sound if available
		local def = minetest.registered_nodes[open_name]
		if def and def.sound_open then
			minetest.sound_play(def.sound_open, {pos = pos, gain = 0.3, max_hear_distance = 10})
		end

		-- Set timer to check for closing
		local timer = minetest.get_node_timer(pos)
		timer:start(DOOR_CHECK_INTERVAL)

		return true
	end

	return false
end

-- Close a door
local function close_door(pos, node)
	local closed_name = get_closed_door_name(node.name)

	-- Check if the closed door exists
	if minetest.registered_nodes[closed_name] then
		minetest.swap_node(pos, {name = closed_name, param1 = node.param1, param2 = node.param2})

		-- Play door sound if available
		local def = minetest.registered_nodes[closed_name]
		if def and def.sound_close then
			minetest.sound_play(def.sound_close, {pos = pos, gain = 0.3, max_hear_distance = 10})
		end

		return true
	end

	return false
end

--------------------------------------------------------------------
-- NODE TIMER FOR DOORS
--------------------------------------------------------------------

-- Timer callback for closed doors - check if NPCs are nearby
local function closed_door_timer(pos, elapsed)
	local node = minetest.get_node(pos)

	if not is_closed_door(node.name) then
		return false  -- Stop timer if node changed
	end

	-- Check for nearby NPCs
	if has_nearby_npcs(pos, DOOR_DETECTION_RADIUS) then
		open_door(pos, node)
		return true  -- Continue timer (now as open door)
	end

	return true  -- Keep checking
end

-- Timer callback for open doors - check if NPCs left
local function open_door_timer(pos, elapsed)
	local node = minetest.get_node(pos)

	if not is_open_door(node.name) then
		return false  -- Stop timer if node changed
	end

	-- Check if NPCs are still nearby
	if not has_nearby_npcs(pos, DOOR_DETECTION_RADIUS + 1) then
		-- Get or initialize last_npc_time
		local meta = minetest.get_meta(pos)
		local last_npc_time = meta:get_float("last_npc_time")
		local current_time = minetest.get_gametime()

		if last_npc_time == 0 then
			-- First time with no NPCs nearby
			meta:set_float("last_npc_time", current_time)
		elseif current_time - last_npc_time >= DOOR_CLOSE_DELAY then
			-- Enough time has passed, close the door
			close_door(pos, node)
			meta:set_float("last_npc_time", 0)
			return true  -- Continue timer (now as closed door)
		end
	else
		-- NPCs still nearby, reset timer
		local meta = minetest.get_meta(pos)
		meta:set_float("last_npc_time", 0)
	end

	return true  -- Keep checking
end

--------------------------------------------------------------------
-- OVERRIDE DOOR NODES
--------------------------------------------------------------------

-- Function to make a door smart
local function make_door_smart(door_name, is_open)
	local original_def = minetest.registered_nodes[door_name]
	if not original_def then return end

	-- Override the node definition
	minetest.override_item(door_name, {
		on_timer = is_open and open_door_timer or closed_door_timer,
	})
end

-- Register ABM to start timers on all doors
minetest.register_abm({
	label = "Start door timers for NPC detection",
	nodenames = {"group:door"},
	interval = 10,
	chance = 1,
	catch_up = false,
	action = function(pos, node)
		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(DOOR_CHECK_INTERVAL)
		end
	end,
})

--------------------------------------------------------------------
-- INITIALIZATION
--------------------------------------------------------------------

-- Make all registered doors smart
minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_nodes) do
		if name:match("^doors:door_.*_b$") then
			-- Closed door
			make_door_smart(name, false)
		elseif name:match("^doors:door_.*_a$") then
			-- Open door
			make_door_smart(name, true)
		end
	end

	minetest.log("action", "[nativevillages] Smart doors initialized")
end)

minetest.log("action", "[nativevillages] Smart doors system loaded")
