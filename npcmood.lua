-- npcmood.lua
local S = minetest.get_translator("nativevillages")

nativevillages.mood = {}

--------------------------------------------------------------------
-- CONFIGURATION SETTINGS
--------------------------------------------------------------------

-- Visual mood indicators (set to true to show sprites above NPCs)
nativevillages.mood.enable_visual_indicators = true

-- Sound timing (seconds between sounds for each NPC)
-- Lower = more frequent sounds, Higher = less frequent sounds
nativevillages.mood.sound_repeat_delay = 14

-- Sound volume settings
-- sound_volume: Master volume for mood sounds (0.0 = silent, 1.0 = full volume)
-- Recommended range: 0.3 to 0.7 for ambient NPC sounds
nativevillages.mood.sound_volume = 0.3

-- Sound distance settings (in nodes/blocks)
-- sound_max_distance: Maximum distance player can hear NPC sounds
-- sound_fade_distance: Distance where sounds start to fade out
-- NPCs beyond max_distance won't be heard at all
nativevillages.mood.sound_max_distance = 8       -- Can hear up to 8 blocks away
nativevillages.mood.sound_fade_distance = 4      -- Starts fading at 4 blocks

--------------------------------------------------------------------

nativevillages.mood.trade_items = {}

nativevillages.mood.moods = {
	happy   = {texture = "nativevillages_mood_happy.png"},
	content = {texture = "nativevillages_mood_content.png"},
	neutral = {texture = "nativevillages_mood_neutral.png"},
	sad     = {texture = "nativevillages_mood_sad.png"},
	angry   = {texture = "nativevillages_mood_angry.png"},
	hungry  = {texture = "nativevillages_mood_hungry.png"},
	lonely  = {texture = "nativevillages_mood_lonely.png"},
	scared  = {texture = "nativevillages_mood_scared.png"},
}

nativevillages.mood.desires = {
	food          = {texture = "nativevillages_desire_food.png",          priority = 1},
	trade         = {texture = "nativevillages_desire_trade.png",         priority = 2},
	companionship = {texture = "nativevillages_desire_companionship.png", priority = 3},
	safety        = {texture = "nativevillages_desire_safety.png",        priority = 4},
	rest          = {texture = "nativevillages_desire_rest.png",          priority = 5},
}

--------------------------------------------------------------------
-- NPC mood initialisation
--------------------------------------------------------------------
function nativevillages.mood.init_npc(self)
	if not self.nv_mood then
		self.nv_mood               = "neutral"
		self.nv_mood_value         = 50
		self.nv_hunger             = 1
		self.nv_loneliness         = 0
		self.nv_fear               = 0
		self.nv_last_fed           = 0
		self.nv_last_interaction   = 0
		self.nv_current_desire     = nil
		self.nv_mood_timer         = 0
		self.nv_mood_indicator     = nil
		self.nv_sound_timer        = 0
	end
end

--------------------------------------------------------------------
-- Helper: get mood name from numeric value
--------------------------------------------------------------------
function nativevillages.mood.get_mood_from_value(value)
	if value >= 80 then return "happy"
	elseif value >= 60 then return "content"
	elseif value >= 40 then return "neutral"
	elseif value >= 20 then return "sad"
	else return "angry" end
end

--------------------------------------------------------------------
-- Desire calculation
--------------------------------------------------------------------
function nativevillages.mood.calculate_desire(self)
	local desires = {}

	if self.nv_hunger > 70 then
		table.insert(desires, {name = "food", urgency = self.nv_hunger})
	end
	if self.nv_loneliness > 60 then
		table.insert(desires, {name = "companionship", urgency = self.nv_loneliness})
	end
	if self.nv_fear > 50 then
		table.insert(desires, {name = "safety", urgency = self.nv_fear})
	end
	if self.health and self.health < 15 then
		table.insert(desires, {name = "rest", urgency = 100 - self.health})
	end
	if self.nv_wants_trade then
		table.insert(desires, {name = "trade", urgency = 85})
	end

	if #desires == 0 then return nil end

	table.sort(desires, function(a, b) return a.urgency > b.urgency end)
	return desires[1].name
end

--------------------------------------------------------------------
-- Check for nearby trade items
--------------------------------------------------------------------
function nativevillages.mood.check_nearby_trade_items(self)
	if not self.object then
		return false
	end

	-- Try to initialize trade items from mob name if not set
	if not self.nv_trade_items or #self.nv_trade_items == 0 then
		-- Try to determine trade items from mob name
		local mob_name = self.name or ""

		-- Extract class from mob name (e.g., "nativevillages:grassland_farmer" -> "farmer")
		local class_name = mob_name:match("_([^_]+)$")
		if class_name then
			-- Map of class to trade items (fallback if not set on spawn)
			local class_trade_items = {
				farmer = {"farming:bread", "farming:wheat"},
				blacksmith = {"farming:bread","default:iron_lump", "default:coal_lump"},
				jeweler = {"farming:bread","default:gold_lump"},
				fisherman = {"farming:bread", "default:paper"},
				ranger = {"farming:bread", "default:apple"},
				cleric = {"farming:bread","default:mese_crystal"},
				entertainer = {"farming:bread","default:gold_lump"},
				witch = {"farming:bread", "default:apple","default:stick"},
				bum = {"farming:bread", "default:apple"},
			}

			if class_trade_items[class_name] then
				self.nv_trade_items = class_trade_items[class_name]
			end
		end
	end

	if not self.nv_trade_items or #self.nv_trade_items == 0 then
		-- Still no trade items - this NPC doesn't trade
		return false
	end

	local pos = self.object:get_pos()
	if not pos then return false end

	local objects = minetest.get_objects_inside_radius(pos, 4)
	for _, obj in ipairs(objects) do
		if obj:is_player() then
			local wielded = obj:get_wielded_item()
			if wielded then
				local name = wielded:get_name()
				if name and name ~= "" then
					for _, trade_item in ipairs(self.nv_trade_items) do
						if name == trade_item then
							return true
						end
					end
				end
			end
		end
	end
	return false
end

--------------------------------------------------------------------
-- Play mood sound if player is nearby (with 3D positional audio)
--------------------------------------------------------------------
function nativevillages.mood.play_sound_if_nearby(self, dtime)
	if not self.object then return end
	local pos = self.object:get_pos()
	if not pos then return end

	self.nv_sound_timer = (self.nv_sound_timer or 0) + dtime
	if self.nv_sound_timer < nativevillages.mood.sound_repeat_delay then
		return
	end

	local nearby_players = minetest.get_connected_players()
	for _, player in ipairs(nearby_players) do
		local player_pos = player:get_pos()
		if player_pos then
			local distance = vector.distance(pos, player_pos)
			-- Only play if within max hearing distance
			if distance <= nativevillages.mood.sound_max_distance then
				local sound_to_play = nil

				if self.nv_wants_trade then
					sound_to_play = "trade"
				elseif self.nv_current_desire == "rest" then
					sound_to_play = "rest"
				elseif self.nv_mood then
					sound_to_play = self.nv_mood
				end

				if sound_to_play then
					-- Calculate distance-based volume falloff with steeper curve
					local distance_ratio = math.min(1, distance / nativevillages.mood.sound_fade_distance)
					-- Use exponential falloff for more rapid sound decay
					local distance_gain = math.max(0, 1.0 - (distance_ratio * distance_ratio * 0.95))
					local final_gain = nativevillages.mood.sound_volume * distance_gain

					minetest.sound_play(sound_to_play, {
						pos = pos,
						max_hear_distance = nativevillages.mood.sound_max_distance,
						gain = final_gain,
						pitch = 1.0,
						loop = false,
					}, true)  -- true = ephemeral (3D positional audio)
					self.nv_sound_timer = 0
				end
				break
			end
		end
	end
end

--------------------------------------------------------------------
-- Mood update (called from do_custom)
--------------------------------------------------------------------
function nativevillages.mood.update_mood(self, dtime)
	nativevillages.mood.init_npc(self)

	-- Mark as fully activated after first update cycle
	self.nv_activation_timer = (self.nv_activation_timer or 0) + dtime
	if self.nv_activation_timer >= 2 then
		self.nv_fully_activated = true
	end

	-- Sound timer runs every frame
	nativevillages.mood.play_sound_if_nearby(self, dtime)

	self.nv_mood_timer = (self.nv_mood_timer or 0) + dtime
	if self.nv_mood_timer < 5 then return end
	self.nv_mood_timer = 0

	-- ---- trade interest -------------------------------------------------
	local player_has_trade_item = nativevillages.mood.check_nearby_trade_items(self)
	if player_has_trade_item then
		self.nv_wants_trade = true
		self.nv_trade_interest_timer = 0
	else
		self.nv_trade_interest_timer = (self.nv_trade_interest_timer or 0) + 5
		if self.nv_trade_interest_timer > 10 then
			self.nv_wants_trade = false
		end
	end

	-- ---- basic needs ---------------------------------------------------
	local time_factor = 5
	self.nv_hunger           = math.min(100, (self.nv_hunger or 1) + time_factor * 0.1)
	self.nv_last_fed         = (self.nv_last_fed or 0) + time_factor
	self.nv_last_interaction = (self.nv_last_interaction or 0) + time_factor

	if self.nv_last_interaction > 120 then
		self.nv_loneliness = math.min(100, (self.nv_loneliness or 0) + 5)
	else
		self.nv_loneliness = math.max(0, (self.nv_loneliness or 0) - 2)
	end

	if self.state == "attack" then
		self.nv_fear = math.min(100, (self.nv_fear or 0) + 15)
	elseif self.attack and self.attack:is_player() then
		self.nv_fear = math.min(100, (self.nv_fear or 0) + 15)
	elseif (self.following and self.following ~= self.owner) then
		self.nv_fear = math.min(100, (self.nv_fear or 0) + 10)
	else
		self.nv_fear = math.max(0, (self.nv_fear or 0) - 5)
	end

	-- ---- mood value ----------------------------------------------------
	local mood_value = 50
	mood_value = mood_value - (self.nv_hunger - 50) * 0.5
	mood_value = mood_value - (self.nv_loneliness - 30) * 0.3
	mood_value = mood_value - self.nv_fear * 0.4

	if self.owner and self.owner ~= "" then mood_value = mood_value + 10 end
	if self.health then mood_value = mood_value + (self.health - 50) * 0.2 end

	self.nv_mood_value = math.max(0, math.min(100, mood_value))

	-- ---- final mood string ---------------------------------------------
	local old_mood = self.nv_mood
	self.nv_mood = nativevillages.mood.get_mood_from_value(self.nv_mood_value)

	if self.nv_hunger > 80 then self.nv_mood = "hungry"
	elseif self.nv_fear > 70 then self.nv_mood = "scared"
	elseif self.nv_loneliness > 80 then self.nv_mood = "lonely" end

	self.nv_current_desire = nativevillages.mood.calculate_desire(self)
	nativevillages.mood.update_indicator(self)
end

--------------------------------------------------------------------
-- Cleanup mood indicator
--------------------------------------------------------------------
function nativevillages.mood.cleanup_indicator(self)
	if self.nv_mood_indicator then
		self.nv_mood_indicator:remove()
		self.nv_mood_indicator = nil
	end
end

--------------------------------------------------------------------
-- Mood indicator (floating icon above head)
--------------------------------------------------------------------
function nativevillages.mood.update_indicator(self)
	if not nativevillages.mood.enable_visual_indicators then return end
	if not self.object then return end
	if not self.nv_fully_activated then return end

	-- Remove old indicator
	if self.nv_mood_indicator then
		self.nv_mood_indicator:remove()
		self.nv_mood_indicator = nil
	end

	local pos = self.object:get_pos()
	if not pos then return end

	local mood_data   = nativevillages.mood.moods[self.nv_mood] or nativevillages.mood.moods.neutral
	local desire_data = self.nv_current_desire and nativevillages.mood.desires[self.nv_current_desire]

	local texture = mood_data.texture
	if desire_data and math.random(100) < 60 then
		texture = desire_data.texture
	end

	-- Create new indicator
	self.nv_mood_indicator = minetest.add_entity(pos, "nativevillages:mood_indicator")
	if self.nv_mood_indicator then
		self.nv_mood_indicator:set_attach(
			self.object,
			"",
			{x=0, y=20, z=0},
			{x=0, y=0, z=0}
		)
		self.nv_mood_indicator:set_properties({
			textures = {texture},
		})

		-- Store reference to parent NPC for info display
		local luaent = self.nv_mood_indicator:get_luaentity()
		if luaent then
			luaent.parent_npc = self
		end
	end
end

--------------------------------------------------------------------
-- Interaction callbacks
--------------------------------------------------------------------
function nativevillages.mood.on_feed(self, clicker, food_value)
	self.nv_hunger           = 1
	self.nv_last_fed         = 0
	self.nv_last_interaction = 0

	if self.health then
		self.health = math.min(self.hp_max or 20, self.health + 5)
	end

	if self.object then
		local pos = self.object:get_pos()
		if pos then
			-- Use higher volume for feeding sound since it's an action feedback
			minetest.sound_play("villager_fed", {
				pos = pos,
				max_hear_distance = nativevillages.mood.sound_max_distance,
				gain = nativevillages.mood.sound_volume * 1.4,  -- 40% louder than mood sounds
				pitch = 1.0,
				loop = false,
			}, true)  -- true = ephemeral (3D positional audio)
		end
	end

	nativevillages.mood.update_mood(self, 0)
end

function nativevillages.mood.on_interact(self, clicker)
	self.nv_last_interaction = 0
	self.nv_loneliness       = math.max(0, (self.nv_loneliness or 0) - 20)
	nativevillages.mood.update_mood(self, 0)
end

function nativevillages.mood.on_trade(self, clicker)
	self.nv_last_interaction = 0
	self.nv_loneliness       = math.max(0, (self.nv_loneliness or 0) - 25)
	self.nv_hunger           = math.max(0, (self.nv_hunger or 50) - 15)

	if self.object then
		local pos = self.object:get_pos()
		if pos then
			minetest.sound_play("trade", {
				pos = pos,
				max_hear_distance = 5,
				gain = 0.7,
			})
		end
	end

	nativevillages.mood.update_mood(self, 0)
end

--------------------------------------------------------------------
-- Serialization (only plain data)
--------------------------------------------------------------------
function nativevillages.mood.get_staticdata_extra(self)
	return {
		nv_mood               = self.nv_mood,
		nv_mood_value         = self.nv_mood_value,
		nv_hunger             = self.nv_hunger,
		nv_loneliness         = self.nv_loneliness,
		nv_fear               = self.nv_fear,
		nv_last_fed           = self.nv_last_fed,
		nv_last_interaction   = self.nv_last_interaction,
		nv_current_desire     = self.nv_current_desire,
		nv_sound_timer        = self.nv_sound_timer,
	}
end

function nativevillages.mood.on_activate_extra(self, data)
	if not data then return end
	self.nv_mood               = data.nv_mood or "neutral"
	self.nv_mood_value         = data.nv_mood_value or 50
	self.nv_hunger             = data.nv_hunger or 1
	self.nv_loneliness         = data.nv_loneliness or 0
	self.nv_fear               = data.nv_fear or 0
	self.nv_last_fed           = data.nv_last_fed or 0
	self.nv_last_interaction   = data.nv_last_interaction or 0
	self.nv_current_desire     = data.nv_current_desire
	self.nv_sound_timer        = data.nv_sound_timer or 0
end

--------------------------------------------------------------------
-- Mood-indicator entity
--------------------------------------------------------------------
minetest.register_entity("nativevillages:mood_indicator", {
	initial_properties = {
		physical      = false,
		collisionbox  = {-0.25, -0.25, -0.25, 0.25, 0.25, 0.25},
		visual        = "sprite",
		visual_size   = {x=0.25, y=0.25},
		textures      = {"nativevillages_mood_neutral.png"},
		is_visible    = true,
		pointable     = true,
		static_save   = false,
		glow          = 5,
	},

	on_step = function(self, dtime)
		if not self.object then return end

		local parent = self.object:get_attach()
		if not parent then
			self.object:remove()
			return
		end

		-- Update infotext when pointed at
		if self.parent_npc then
			local npc = self.parent_npc
			local mood_name = npc.nv_mood or "neutral"
			local hunger = math.floor(npc.nv_hunger or 1)
			local health = math.floor(npc.health or 20)

			local mood_emoji = {
				happy = "😊",
				content = "🙂",
				neutral = "😐",
				sad = "😢",
				angry = "😠",
				hungry = "🍞",
				lonely = "💭",
				scared = "😨"
			}

			local info = string.format("%s HP:%d Hunger:%d",
				mood_emoji[mood_name] or "😐",
				health,
				hunger
			)

			self.object:set_properties({
				infotext = info
			})
		end
	end,

	get_staticdata = function(self)
		return ""
	end,

	on_activate = function(self, staticdata)
	end,
})









