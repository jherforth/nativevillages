-- villager_behaviors.lua
-- Enhanced villager AI: sleep, daily routines, social interactions, food sharing, door usage

local S = minetest.get_translator("nativevillages")

nativevillages.behaviors = {}

--------------------------------------------------------------------
-- CONFIGURATION
--------------------------------------------------------------------
nativevillages.behaviors.config = {
	home_radius = 20,
	sleep_radius = 3,
	door_detection_radius = 2,
	social_detection_radius = 5,
	food_share_detection_radius = 8,
	social_interaction_cooldown = 45,
	food_share_cooldown = 60,
	door_close_delay = 3,
	stuck_teleport_threshold = 300,
}

--------------------------------------------------------------------
-- TIME OF DAY HELPERS
--------------------------------------------------------------------
function nativevillages.behaviors.get_time_of_day()
	return minetest.get_timeofday()
end

function nativevillages.behaviors.get_time_period()
	local tod = nativevillages.behaviors.get_time_of_day()

	if tod >= 0.0 and tod < 0.25 then
		return "night"
	elseif tod >= 0.25 and tod < 0.35 then
		return "morning"
	elseif tod >= 0.35 and tod < 0.65 then
		return "afternoon"
	elseif tod >= 0.65 and tod < 0.75 then
		return "evening"
	else
		return "night"
	end
end

function nativevillages.behaviors.is_night_time()
	local tod = nativevillages.behaviors.get_time_of_day()
	return (tod < 0.25 or tod >= 0.75)
end

function nativevillages.behaviors.is_day_time()
	return not nativevillages.behaviors.is_night_time()
end

--------------------------------------------------------------------
-- HOUSE POSITION MANAGEMENT
--------------------------------------------------------------------
function nativevillages.behaviors.init_house(self)
	if not self.nv_house_pos then
		self.nv_house_pos = nil
		self.nv_home_radius = nativevillages.behaviors.config.home_radius
		self.nv_sleeping = false
		self.nv_stuck_timer = 0
	end
end

function nativevillages.behaviors.get_house_position(self)
	return self.nv_house_pos
end

function nativevillages.behaviors.has_house(self)
	return self.nv_house_pos ~= nil
end

--------------------------------------------------------------------
-- DOOR INTERACTION SYSTEM
--------------------------------------------------------------------
nativevillages.behaviors.door_timers = {}
nativevillages.behaviors.door_states = {}  -- Track last known state of each door

function nativevillages.behaviors.find_nearby_door(self)
	if not self.object then return nil end
	local pos = self.object:get_pos()
	if not pos then return nil end

	local radius = nativevillages.behaviors.config.door_detection_radius
	local doors = minetest.find_nodes_in_area(
		{x = pos.x - radius, y = pos.y - 1, z = pos.z - radius},
		{x = pos.x + radius, y = pos.y + 1, z = pos.z + radius},
		"group:door"
	)

	if #doors == 0 then return nil end

	local closest_door = nil
	local closest_dist = 999
	for _, door_pos in ipairs(doors) do
		local dist = vector.distance(pos, door_pos)
		if dist < closest_dist then
			closest_dist = dist
			closest_door = door_pos
		end
	end

	return closest_door
end

function nativevillages.behaviors.is_door_open(door_pos)
	local node = minetest.get_node(door_pos)
	return string.find(node.name, "_a") or string.find(node.name, "_open")
end

function nativevillages.behaviors.open_door(door_pos, self)
	if nativevillages.behaviors.is_door_open(door_pos) then return end

	local node = minetest.get_node(door_pos)
	if not node or not node.name then return end

	minetest.log("action", "[villagers] Attempting to open door: " .. node.name)

	if minetest.get_item_group(node.name, "door") > 0 then
		local door_def = minetest.registered_nodes[node.name]

		-- Method 1: Try on_rightclick
		if door_def and door_def.on_rightclick then
			minetest.log("action", "[villagers] Trying on_rightclick method")
			local success, err = pcall(function()
				-- Try with nil player first
				door_def.on_rightclick(door_pos, node, nil, nil)
			end)
			if success then
				minetest.log("action", "[villagers] on_rightclick succeeded")
			else
				minetest.log("action", "[villagers] on_rightclick failed: " .. tostring(err))
				-- Method 2: Try doors.door_toggle
				if doors and doors.door_toggle then
					minetest.log("action", "[villagers] Trying doors.door_toggle")
					local toggle_success, toggle_err = pcall(function()
						doors.door_toggle(door_pos, node, nil)
					end)
					if toggle_success then
						minetest.log("action", "[villagers] doors.door_toggle succeeded")
					else
						minetest.log("action", "[villagers] doors.door_toggle failed: " .. tostring(toggle_err))
						-- Method 3: Try swapping node directly
						minetest.log("action", "[villagers] Trying direct node swap")
						local closed_name = node.name
						local open_name = closed_name:gsub("_b$", "_a"):gsub("_c$", "_a")
						if open_name ~= closed_name then
							local success_swap = pcall(function()
								minetest.swap_node(door_pos, {name = open_name, param1 = node.param1, param2 = node.param2})
							end)
							if success_swap then
								minetest.log("action", "[villagers] Direct swap succeeded: " .. closed_name .. " -> " .. open_name)
							else
								minetest.log("action", "[villagers] Direct swap failed")
							end
						end
					end
				end
			end
		elseif doors and doors.door_toggle then
			-- Method 2: Direct doors.door_toggle (no on_rightclick)
			minetest.log("action", "[villagers] No on_rightclick, using doors.door_toggle")
			local success, err = pcall(function()
				doors.door_toggle(door_pos, node, nil)
			end)
			if success then
				minetest.log("action", "[villagers] doors.door_toggle succeeded")
			else
				minetest.log("action", "[villagers] doors.door_toggle failed: " .. tostring(err))
			end
		else
			minetest.log("warning", "[villagers] No door API available for " .. node.name)
		end
	else
		minetest.log("warning", "[villagers] Node is not in door group: " .. node.name)
	end
end

function nativevillages.behaviors.schedule_door_close(door_pos)
	local door_key = minetest.pos_to_string(door_pos)

	if nativevillages.behaviors.door_timers[door_key] then
		return
	end

	nativevillages.behaviors.door_timers[door_key] = true

	minetest.after(nativevillages.behaviors.config.door_close_delay, function()
		nativevillages.behaviors.door_timers[door_key] = nil

		if nativevillages.behaviors.is_door_open(door_pos) then
			local node = minetest.get_node(door_pos)
			minetest.log("action", "[villagers] Closing door: " .. node.name .. " at " .. minetest.pos_to_string(door_pos))

			if minetest.get_item_group(node.name, "door") > 0 then
				local door_def = minetest.registered_nodes[node.name]

				-- Method 1: Try on_rightclick
				if door_def and door_def.on_rightclick then
					minetest.log("action", "[villagers] Trying on_rightclick to close")
					local success, err = pcall(function()
						door_def.on_rightclick(door_pos, node, nil, nil)
					end)
					if success then
						minetest.log("action", "[villagers] on_rightclick close succeeded")
					else
						minetest.log("action", "[villagers] on_rightclick close failed: " .. tostring(err))
						-- Method 2: Try doors.door_toggle
						if doors and doors.door_toggle then
							minetest.log("action", "[villagers] Trying doors.door_toggle to close")
							local toggle_success, toggle_err = pcall(function()
								doors.door_toggle(door_pos, node, nil)
							end)
							if toggle_success then
								minetest.log("action", "[villagers] doors.door_toggle close succeeded")
							else
								minetest.log("action", "[villagers] doors.door_toggle close failed: " .. tostring(toggle_err))
								-- Method 3: Try swapping node directly
								minetest.log("action", "[villagers] Trying direct node swap to close")
								local open_name = node.name
								local closed_name = open_name:gsub("_a$", "_b"):gsub("_open$", "_closed")
								if closed_name ~= open_name then
									local success_swap = pcall(function()
										minetest.swap_node(door_pos, {name = closed_name, param1 = node.param1, param2 = node.param2})
									end)
									if success_swap then
										minetest.log("action", "[villagers] Direct swap to close succeeded: " .. open_name .. " -> " .. closed_name)
									else
										minetest.log("action", "[villagers] Direct swap to close failed")
									end
								end
							end
						end
					end
				elseif doors and doors.door_toggle then
					-- Method 2: Direct doors.door_toggle
					minetest.log("action", "[villagers] Using doors.door_toggle to close")
					local success, err = pcall(function()
						doors.door_toggle(door_pos, node, nil)
					end)
					if success then
						minetest.log("action", "[villagers] doors.door_toggle close succeeded")
					else
						minetest.log("action", "[villagers] doors.door_toggle close failed: " .. tostring(err))
					end
				else
					minetest.log("warning", "[villagers] No door close API available for " .. node.name)
				end
			end
			-- Update state to closed
			nativevillages.behaviors.door_states[door_key] = false
		else
			minetest.log("action", "[villagers] Door already closed at " .. minetest.pos_to_string(door_pos))
			nativevillages.behaviors.door_states[door_key] = false
		end
	end)
end

function nativevillages.behaviors.handle_door_interaction(self)
	-- Only check doors occasionally to reduce spam
	if not self.nv_door_check_timer then
		self.nv_door_check_timer = 0
	end

	self.nv_door_check_timer = self.nv_door_check_timer + 1
	if self.nv_door_check_timer < 10 then
		return
	end
	self.nv_door_check_timer = 0

	local door_pos = nativevillages.behaviors.find_nearby_door(self)
	if not door_pos then
		self.nv_last_door_pos = nil
		return
	end

	local door_key = minetest.pos_to_string(door_pos)
	local is_open = nativevillages.behaviors.is_door_open(door_pos)

	-- Get last known state for this door
	local last_state = nativevillages.behaviors.door_states[door_key]

	-- If we don't know the state, or state changed, take action
	if last_state == nil or last_state ~= is_open then
		nativevillages.behaviors.door_states[door_key] = is_open

		if not is_open then
			-- Door is closed, open it
			local node = minetest.get_node(door_pos)
			minetest.log("action", "[villagers] Opening door: " .. node.name .. " at " .. door_key)
			nativevillages.behaviors.open_door(door_pos, self)
			nativevillages.behaviors.door_states[door_key] = true
			nativevillages.behaviors.schedule_door_close(door_pos)
		end
	end

	self.nv_last_door_pos = door_pos
end

--------------------------------------------------------------------
-- SLEEP SYSTEM
--------------------------------------------------------------------
function nativevillages.behaviors.should_sleep(self)
	return nativevillages.behaviors.is_night_time() and nativevillages.behaviors.has_house(self)
end

function nativevillages.behaviors.is_at_house(self)
	if not nativevillages.behaviors.has_house(self) then return false end
	if not self.object then return false end

	local pos = self.object:get_pos()
	if not pos then return false end

	local house_pos = nativevillages.behaviors.get_house_position(self)
	local dist = vector.distance(pos, house_pos)

	return dist <= nativevillages.behaviors.config.sleep_radius
end

function nativevillages.behaviors.enter_sleep_state(self)
	if self.nv_sleeping then return end

	self.nv_sleeping = true

	-- Stop movement completely
	self.state = "stand"
	if self.object then
		self.object:set_velocity({x=0, y=0, z=0})
	end

	-- Find the actual bed and position on it
	local house_pos = nativevillages.behaviors.get_house_position(self)
	if house_pos and self.object then
		local pos = self.object:get_pos()
		if pos then
			-- Search for bed node near house position
			local bed_pos = nil
			for dx = -3, 3 do
				for dy = -1, 2 do
					for dz = -3, 3 do
						local check_pos = {
							x = house_pos.x + dx,
							y = house_pos.y + dy,
							z = house_pos.z + dz
						}
						local node = minetest.get_node(check_pos)
						if minetest.get_item_group(node.name, "bed") > 0 then
							bed_pos = check_pos
							goto bed_found
						end
					end
				end
			end
			::bed_found::

			-- Position villager on bed if found
			if bed_pos then
				-- Position slightly above bed surface
				local sleep_pos = {
					x = bed_pos.x,
					y = bed_pos.y + 0.5,
					z = bed_pos.z
				}
				self.object:set_pos(sleep_pos)
				minetest.log("action", "[villagers] Villager sleeping on bed at " .. minetest.pos_to_string(bed_pos))
			end
		end
	end

	-- Set sleeping animation
	self:set_animation("lay")
end

function nativevillages.behaviors.exit_sleep_state(self)
	if not self.nv_sleeping then return end

	self.nv_sleeping = false
	self:set_animation("stand")
end

function nativevillages.behaviors.handle_sleep(self)
	if not nativevillages.behaviors.should_sleep(self) then
		nativevillages.behaviors.exit_sleep_state(self)
		return false
	end

	if nativevillages.behaviors.is_at_house(self) then
		nativevillages.behaviors.enter_sleep_state(self)
		return true
	else
		local house_pos = nativevillages.behaviors.get_house_position(self)
		if house_pos and self.object then
			local pos = self.object:get_pos()
			if pos then
				if self.order ~= "stand" and not self.following then
					local dist = vector.distance(pos, house_pos)
					if dist > 1 then
						-- Use mobs_redo pathfinding by setting the _target
						-- The mob's AI will automatically pathfind to it
						self._target = house_pos
						self.state = "walk"
						self:set_animation("walk")

						-- Face the target
						local dir = vector.direction(pos, house_pos)
						local yaw = minetest.dir_to_yaw(dir)
						self.object:set_yaw(yaw)
					end
				end
			end
		end
	end

	return false
end

--------------------------------------------------------------------
-- DAILY ROUTINE & MOVEMENT
--------------------------------------------------------------------
function nativevillages.behaviors.get_activity_radius(self)
	local period = nativevillages.behaviors.get_time_period()
	local base_radius = self.nv_home_radius or nativevillages.behaviors.config.home_radius

	if period == "morning" then
		return base_radius * 0.5
	elseif period == "afternoon" then
		return base_radius * 1.2
	elseif period == "evening" then
		return base_radius * 0.7
	else
		return nativevillages.behaviors.config.sleep_radius
	end
end

function nativevillages.behaviors.update_movement_target(self)
	if not nativevillages.behaviors.has_house(self) then return end
	if not self.object then return end

	local period = nativevillages.behaviors.get_time_period()

	if period == "night" then
		if not self.nv_sleeping and not nativevillages.behaviors.is_at_house(self) then
			return nativevillages.behaviors.get_house_position(self)
		end
	end

	return nil
end

function nativevillages.behaviors.check_stuck_and_recover(self, dtime)
	if not nativevillages.behaviors.has_house(self) then return end
	if not self.object then return end

	local pos = self.object:get_pos()
	if not pos then return end

	local house_pos = nativevillages.behaviors.get_house_position(self)
	local dist = vector.distance(pos, house_pos)
	local max_radius = nativevillages.behaviors.get_activity_radius(self) * 1.5

	if dist > max_radius then
		self.nv_stuck_timer = (self.nv_stuck_timer or 0) + dtime

		if self.nv_stuck_timer >= nativevillages.behaviors.config.stuck_teleport_threshold then
			local teleport_pos = {
				x = house_pos.x + math.random(-3, 3),
				y = house_pos.y,
				z = house_pos.z + math.random(-3, 3)
			}
			self.object:set_pos(teleport_pos)
			self.nv_stuck_timer = 0
		end
	else
		self.nv_stuck_timer = 0
	end
end

function nativevillages.behaviors.flee_to_house_on_low_health(self)
	if not self.health then return false end
	if not nativevillages.behaviors.has_house(self) then return false end

	if self.health < (self.hp_max or 20) * 0.3 then
		if self.object then
			local house_pos = nativevillages.behaviors.get_house_position(self)
			return house_pos
		end
	end

	return false
end

--------------------------------------------------------------------
-- SOCIAL INTERACTIONS (Villager-to-Villager)
--------------------------------------------------------------------
function nativevillages.behaviors.find_nearby_villagers(self)
	if not self.object then return {} end
	local pos = self.object:get_pos()
	if not pos then return {} end

	local radius = nativevillages.behaviors.config.social_detection_radius
	local objects = minetest.get_objects_inside_radius(pos, radius)
	local nearby_villagers = {}

	for _, obj in ipairs(objects) do
		if obj ~= self.object then
			local ent = obj:get_luaentity()
			if ent and ent.name and string.match(ent.name, "nativevillages:") and ent.type == "npc" then
				table.insert(nearby_villagers, ent)
			end
		end
	end

	return nearby_villagers
end

function nativevillages.behaviors.should_socialize(self)
	if not self.nv_last_social_time then
		self.nv_last_social_time = 0
	end

	local current_time = minetest.get_gametime()
	return (current_time - self.nv_last_social_time) >= nativevillages.behaviors.config.social_interaction_cooldown
end

function nativevillages.behaviors.emit_social_particles(pos1, pos2)
	local mid_pos = {
		x = (pos1.x + pos2.x) / 2,
		y = (pos1.y + pos2.y) / 2 + 1,
		z = (pos1.z + pos2.z) / 2,
	}

	minetest.add_particlespawner({
		amount = 40,
		time = 1,
		minpos = {x = mid_pos.x - 0.3, y = mid_pos.y, z = mid_pos.z - 0.3},
		maxpos = {x = mid_pos.x + 0.3, y = mid_pos.y + 0.5, z = mid_pos.z + 0.3},
		minvel = {x = 0, y = 0.5, z = 0},
		maxvel = {x = 0, y = 1.0, z = 0},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minexptime = 1,
		maxexptime = 2,
		minsize = 0.25,
		maxsize = 0.5,
		texture = "nativevillages_mood_happy.png",
		glow = 5,
	})
end

function nativevillages.behaviors.handle_social_interactions(self)
	if not nativevillages.behaviors.should_socialize(self) then return end

	local nearby = nativevillages.behaviors.find_nearby_villagers(self)
	if #nearby == 0 then return end

	local pos1 = self.object:get_pos()
	if not pos1 then return end

	for _, other in ipairs(nearby) do
		if other.object then
			local pos2 = other.object:get_pos()
			if pos2 then
				nativevillages.behaviors.emit_social_particles(pos1, pos2)

				if self.nv_mood == "happy" or self.nv_mood == "content" then
					if other.nv_mood_value then
						other.nv_mood_value = math.min(100, (other.nv_mood_value or 50) + 5)
					end
				end

				if self.nv_loneliness then
					self.nv_loneliness = math.max(0, self.nv_loneliness - 15)
				end

				break
			end
		end
	end

	self.nv_last_social_time = minetest.get_gametime()
end

--------------------------------------------------------------------
-- FOOD SHARING SYSTEM
--------------------------------------------------------------------
function nativevillages.behaviors.find_hungry_villager_nearby(self)
	if not self.object then return nil end
	local pos = self.object:get_pos()
	if not pos then return nil end

	local radius = nativevillages.behaviors.config.food_share_detection_radius
	local objects = minetest.get_objects_inside_radius(pos, radius)

	for _, obj in ipairs(objects) do
		if obj ~= self.object then
			local ent = obj:get_luaentity()
			if ent and ent.name and string.match(ent.name, "nativevillages:") and ent.type == "npc" then
				if ent.nv_hunger and ent.nv_hunger > 85 then
					return ent
				end
			end
		end
	end

	return nil
end

function nativevillages.behaviors.should_share_food(self)
	if not self.nv_last_food_share_time then
		self.nv_last_food_share_time = 0
	end

	if not self.nv_hunger or self.nv_hunger > 30 then
		return false
	end

	local current_time = minetest.get_gametime()
	return (current_time - self.nv_last_food_share_time) >= nativevillages.behaviors.config.food_share_cooldown
end

function nativevillages.behaviors.emit_food_share_particles(pos1, pos2)
	local mid_pos = {
		x = (pos1.x + pos2.x) / 2,
		y = (pos1.y + pos2.y) / 2 + 1,
		z = (pos1.z + pos2.z) / 2,
	}

	minetest.add_particlespawner({
		amount = 64,
		time = 1.5,
		minpos = {x = mid_pos.x - 0.3, y = mid_pos.y, z = mid_pos.z - 0.3},
		maxpos = {x = mid_pos.x + 0.3, y = mid_pos.y + 0.5, z = mid_pos.z + 0.3},
		minvel = {x = 0, y = 0.3, z = 0},
		maxvel = {x = 0, y = 0.8, z = 0},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minexptime = 1,
		maxexptime = 2,
		minsize = 0.2,
		maxsize = 0.4,
		texture = "default_cloud.png^[colorize:blue:100",
		glow = 3,
	})
end

function nativevillages.behaviors.handle_food_sharing(self)
	if not nativevillages.behaviors.should_share_food(self) then return end

	local hungry_villager = nativevillages.behaviors.find_hungry_villager_nearby(self)
	if not hungry_villager then return end

	local pos1 = self.object:get_pos()
	local pos2 = hungry_villager.object:get_pos()
	if not pos1 or not pos2 then return end

	self.nv_hunger = math.min(100, (self.nv_hunger or 1) + 15)
	hungry_villager.nv_hunger = math.max(1, (hungry_villager.nv_hunger or 1) - 30)

	if hungry_villager.health and hungry_villager.hp_max then
		hungry_villager.health = math.min(hungry_villager.hp_max, hungry_villager.health + 3)
	end

	nativevillages.behaviors.emit_food_share_particles(pos1, pos2)

	if hungry_villager.nv_mood_value then
		hungry_villager.nv_mood_value = math.min(100, (hungry_villager.nv_mood_value or 50) + 10)
	end

	self.nv_last_food_share_time = minetest.get_gametime()
end

--------------------------------------------------------------------
-- GREETING PARTICLES
--------------------------------------------------------------------
function nativevillages.behaviors.emit_greeting_particles(self, player_pos)
	local pos = self.object:get_pos()
	if not pos then return end

	local color = "green"
	if self.state == "attack" or self.type == "monster" then
		color = "red"
	end

	minetest.add_particlespawner({
		amount = 24,
		time = 0.5,
		minpos = {x = pos.x - 0.3, y = pos.y + 1.5, z = pos.z - 0.3},
		maxpos = {x = pos.x + 0.3, y = pos.y + 2.0, z = pos.z + 0.3},
		minvel = {x = 0, y = 0.2, z = 0},
		maxvel = {x = 0, y = 0.5, z = 0},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minexptime = 0.5,
		maxexptime = 1,
		minsize = 0.25,
		maxsize = 0.4,
		texture = "default_cloud.png^[colorize:" .. color .. ":150",
		glow = 8,
	})
end

function nativevillages.behaviors.check_nearby_players(self)
	if not self.object then return end
	local pos = self.object:get_pos()
	if not pos then return end

	if not self.nv_last_player_greeting_time then
		self.nv_last_player_greeting_time = 0
	end

	local current_time = minetest.get_gametime()
	if (current_time - self.nv_last_player_greeting_time) < 30 then
		return
	end

	local players = minetest.get_connected_players()
	for _, player in ipairs(players) do
		local player_pos = player:get_pos()
		if player_pos then
			local dist = vector.distance(pos, player_pos)
			if dist < 3 and dist > 1 then
				nativevillages.behaviors.emit_greeting_particles(self, player_pos)
				self.nv_last_player_greeting_time = current_time
				break
			end
		end
	end
end

--------------------------------------------------------------------
-- MAIN UPDATE FUNCTION
--------------------------------------------------------------------
function nativevillages.behaviors.update(self, dtime)
	nativevillages.behaviors.init_house(self)

	if nativevillages.behaviors.handle_sleep(self) then
		return
	end

	nativevillages.behaviors.handle_door_interaction(self)

	nativevillages.behaviors.check_stuck_and_recover(self, dtime)

	if math.random() < 0.05 then
		nativevillages.behaviors.handle_social_interactions(self)
	end

	if math.random() < 0.03 then
		nativevillages.behaviors.handle_food_sharing(self)
	end

	if math.random() < 0.02 then
		nativevillages.behaviors.check_nearby_players(self)
	end

	local flee_target = nativevillages.behaviors.flee_to_house_on_low_health(self)
	if flee_target then
	end
end

--------------------------------------------------------------------
-- SERIALIZATION HELPERS
--------------------------------------------------------------------
function nativevillages.behaviors.get_save_data(self)
	return {
		nv_house_pos = self.nv_house_pos,
		nv_home_radius = self.nv_home_radius,
		nv_sleeping = self.nv_sleeping,
		nv_stuck_timer = self.nv_stuck_timer,
		nv_last_social_time = self.nv_last_social_time,
		nv_last_food_share_time = self.nv_last_food_share_time,
		nv_last_player_greeting_time = self.nv_last_player_greeting_time,
	}
end

function nativevillages.behaviors.load_save_data(self, data)
	if not data then return end

	self.nv_house_pos = data.nv_house_pos
	self.nv_home_radius = data.nv_home_radius
	self.nv_sleeping = data.nv_sleeping
	self.nv_stuck_timer = data.nv_stuck_timer or 0
	self.nv_last_social_time = data.nv_last_social_time or 0
	self.nv_last_food_share_time = data.nv_last_food_share_time or 0
	self.nv_last_player_greeting_time = data.nv_last_player_greeting_time or 0
end

print(S("[MOD] Native Villages - Enhanced villager behaviors loaded"))
