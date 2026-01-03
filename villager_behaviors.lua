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
	door_detection_radius = 2,  -- Used for nearby door scanning
	social_detection_radius = 5,
	food_share_detection_radius = 8,
	social_interaction_cooldown = 45,
	food_share_cooldown = 60,
	door_close_distance = 4,  -- Doors close when NPC is this far away
	door_close_time = 5,  -- Doors close after this many seconds of inactivity
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
-- DOOR INTERACTION SYSTEM (Simplified using doors API)
--------------------------------------------------------------------
nativevillages.behaviors.open_doors = {}  -- Track which doors are open by which NPCs

function nativevillages.behaviors.get_door_at_pos(pos)
	-- Use the doors API to get door object
	if doors and doors.get then
		local success, door = pcall(doors.get, pos)
		if success and door then
			return door
		end
	end
	return nil
end

function nativevillages.behaviors.find_nearby_doors(self)
	if not self.object then return {} end
	local pos = self.object:get_pos()
	if not pos then return {} end

	local radius = nativevillages.behaviors.config.door_detection_radius
	local door_positions = {}

	-- Check positions around the NPC (center, adjacent, and vertical)
	local check_positions = {
		pos,  -- Center
		{x = pos.x + 1, y = pos.y, z = pos.z},
		{x = pos.x - 1, y = pos.y, z = pos.z},
		{x = pos.x, y = pos.y, z = pos.z + 1},
		{x = pos.x, y = pos.y, z = pos.z - 1},
		{x = pos.x, y = pos.y + 1, z = pos.z},  -- Above
		{x = pos.x, y = pos.y - 1, z = pos.z},  -- Below
	}

	for _, check_pos in ipairs(check_positions) do
		local node = minetest.get_node(check_pos)
		if minetest.get_item_group(node.name, "door") > 0 then
			table.insert(door_positions, vector.round(check_pos))
		end
	end

	return door_positions
end

function nativevillages.behaviors.handle_door_interaction(self)
	if not self.object then return end

	-- Initialize NPC door tracking
	if not self.nv_opened_doors then
		self.nv_opened_doors = {}
	end

	local pos = self.object:get_pos()
	if not pos then return end

	-- Find nearby doors
	local nearby_doors = nativevillages.behaviors.find_nearby_doors(self)
	local npc_id = tostring(self.object)

	-- Open nearby closed doors
	for _, door_pos in ipairs(nearby_doors) do
		local door = nativevillages.behaviors.get_door_at_pos(door_pos)
		if door then
			local door_key = minetest.pos_to_string(door_pos)

			-- Check if door is closed
			if not door:state() then
				-- Open the door
				local success = pcall(function()
					door:open(nil)  -- nil player works for NPC access
				end)

				if success then
					-- Track this door as opened by this NPC
					self.nv_opened_doors[door_key] = {
						pos = door_pos,
						time = minetest.get_gametime()
					}

					-- Also track globally for cleanup
					if not nativevillages.behaviors.open_doors[door_key] then
						nativevillages.behaviors.open_doors[door_key] = {}
					end
					nativevillages.behaviors.open_doors[door_key][npc_id] = true
				end
			else
				-- Door is already open, update timer
				if self.nv_opened_doors[door_key] then
					self.nv_opened_doors[door_key].time = minetest.get_gametime()
				end
			end
		end
	end

	-- Close doors that NPC has moved away from
	local current_time = minetest.get_gametime()
	for door_key, door_data in pairs(self.nv_opened_doors) do
		local dist = vector.distance(pos, door_data.pos)
		local time_since = current_time - door_data.time

		-- Close door if NPC is far away or hasn't been near it for a while
		if dist > nativevillages.behaviors.config.door_close_distance or
		   time_since > nativevillages.behaviors.config.door_close_time then
			local door = nativevillages.behaviors.get_door_at_pos(door_data.pos)
			if door and door:state() then  -- If door is open
				-- Check if any other NPCs are near this door
				local other_npcs_nearby = false
				if nativevillages.behaviors.open_doors[door_key] then
					for other_npc_id, _ in pairs(nativevillages.behaviors.open_doors[door_key]) do
						if other_npc_id ~= npc_id then
							other_npcs_nearby = true
							break
						end
					end
				end

				-- Only close if no other NPCs are near
				if not other_npcs_nearby then
					pcall(function()
						door:close(nil)
					end)
				end
			end

			-- Remove from tracking
			self.nv_opened_doors[door_key] = nil
			if nativevillages.behaviors.open_doors[door_key] then
				nativevillages.behaviors.open_doors[door_key][npc_id] = nil
			end
		end
	end
end

--------------------------------------------------------------------
-- NIGHT-TIME BED PATHFINDING (Simplified - no sleeping animation)
--------------------------------------------------------------------
function nativevillages.behaviors.should_go_to_bed(self)
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

function nativevillages.behaviors.handle_night_time_movement(self)
	-- During night, just pathfind to bed - no sleep animation
	if not nativevillages.behaviors.should_go_to_bed(self) then
		return false
	end

	-- If already at house, just stand around
	if nativevillages.behaviors.is_at_house(self) then
		return true
	end

	-- Otherwise, pathfind to house
	local house_pos = nativevillages.behaviors.get_house_position(self)
	if house_pos and self.object then
		local pos = self.object:get_pos()
		if pos then
			if self.order ~= "stand" and not self.following then
				local dist = vector.distance(pos, house_pos)
				if dist > 1 then
					-- Use mobs_redo pathfinding
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

	-- Handle night-time pathfinding to bed (no sleep animation)
	if nativevillages.behaviors.handle_night_time_movement(self) then
		return
	end

	-- Handle door interactions (check every update for responsiveness)
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
		nv_opened_doors = self.nv_opened_doors,
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
	self.nv_opened_doors = data.nv_opened_doors or {}
end

print(S("[MOD] Native Villages - Enhanced villager behaviors loaded"))
