local S = minetest.get_translator("nativevillages")

nativevillages = nativevillages or {}
nativevillages.mood = {}

nativevillages.mood.moods = {
	happy = {texture = "nativevillages_mood_happy.png"},
	content = {texture = "nativevillages_mood_content.png"},
	neutral = {texture = "nativevillages_mood_neutral.png"},
	sad = {texture = "nativevillages_mood_sad.png"},
	angry = {texture = "nativevillages_mood_angry.png"},
	hungry = {texture = "nativevillages_mood_hungry.png"},
	lonely = {texture = "nativevillages_mood_lonely.png"},
	scared = {texture = "nativevillages_mood_scared.png"},
}

nativevillages.mood.desires = {
	food = {texture = "nativevillages_desire_food.png", priority = 1},
	trade = {texture = "nativevillages_desire_trade.png", priority = 2},
	companionship = {texture = "nativevillages_desire_companionship.png", priority = 3},
	safety = {texture = "nativevillages_desire_safety.png", priority = 4},
	rest = {texture = "nativevillages_desire_rest.png", priority = 5},
}

function nativevillages.mood.init_npc(self)
	if not self.nv_mood then
		self.nv_mood = "neutral"
		self.nv_mood_value = 50
		self.nv_hunger = 50
		self.nv_loneliness = 0
		self.nv_fear = 0
		self.nv_last_fed = 0
		self.nv_last_interaction = 0
		self.nv_current_desire = nil
		self.nv_mood_timer = 0
	end
end

function nativevillages.mood.get_mood_from_value(value)
	if value >= 80 then
		return "happy"
	elseif value >= 60 then
		return "content"
	elseif value >= 40 then
		return "neutral"
	elseif value >= 20 then
		return "sad"
	else
		return "angry"
	end
end

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

	if self.owner and self.owner ~= "" and math.random(100) < 20 then
		table.insert(desires, {name = "trade", urgency = 30})
	end

	if #desires == 0 then
		return nil
	end

	table.sort(desires, function(a, b) return a.urgency > b.urgency end)
	return desires[1].name
end

function nativevillages.mood.update_mood(self, dtime)
	nativevillages.mood.init_npc(self)

	self.nv_mood_timer = (self.nv_mood_timer or 0) + dtime

	if self.nv_mood_timer < 5 then
		return
	end

	self.nv_mood_timer = 0

	local time_factor = 5
	self.nv_hunger = math.min(100, (self.nv_hunger or 50) + time_factor * 0.5)
	self.nv_last_fed = (self.nv_last_fed or 0) + time_factor
	self.nv_last_interaction = (self.nv_last_interaction or 0) + time_factor

	if self.nv_last_interaction > 120 then
		self.nv_loneliness = math.min(100, (self.nv_loneliness or 0) + 5)
	else
		self.nv_loneliness = math.max(0, (self.nv_loneliness or 0) - 2)
	end

	if self.state == "attack" or (self.following and self.following ~= self.owner) then
		self.nv_fear = math.min(100, (self.nv_fear or 0) + 10)
	else
		self.nv_fear = math.max(0, (self.nv_fear or 0) - 5)
	end

	local mood_value = 50
	mood_value = mood_value - (self.nv_hunger - 50) * 0.5
	mood_value = mood_value - (self.nv_loneliness - 30) * 0.3
	mood_value = mood_value - self.nv_fear * 0.4

	if self.owner and self.owner ~= "" then
		mood_value = mood_value + 10
	end

	if self.health then
		mood_value = mood_value + (self.health - 50) * 0.2
	end

	self.nv_mood_value = math.max(0, math.min(100, mood_value))

	local old_mood = self.nv_mood
	self.nv_mood = nativevillages.mood.get_mood_from_value(self.nv_mood_value)

	if self.nv_hunger > 80 then
		self.nv_mood = "hungry"
	elseif self.nv_fear > 70 then
		self.nv_mood = "scared"
	elseif self.nv_loneliness > 80 then
		self.nv_mood = "lonely"
	end

	self.nv_current_desire = nativevillages.mood.calculate_desire(self)

	nativevillages.mood.update_indicator(self)
end

function nativevillages.mood.update_indicator(self)
	if not self.object then return end

	if self.nv_mood_indicator then
		self.nv_mood_indicator:remove()
		self.nv_mood_indicator = nil
	end

	local pos = self.object:get_pos()
	if not pos then return end

	pos.y = pos.y + 2.2

	local mood_data = nativevillages.mood.moods[self.nv_mood] or nativevillages.mood.moods.neutral
	local desire_data = self.nv_current_desire and nativevillages.mood.desires[self.nv_current_desire]

	local texture = mood_data.texture
	if desire_data and math.random(100) < 60 then
		texture = desire_data.texture
	end

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
	end
end

function nativevillages.mood.on_feed(self, clicker)
	self.nv_hunger = math.max(0, (self.nv_hunger or 50) - 30)
	self.nv_last_fed = 0
	self.nv_mood_value = math.min(100, (self.nv_mood_value or 50) + 15)
	self.nv_last_interaction = 0
	nativevillages.mood.update_mood(self, 0)
end

function nativevillages.mood.on_interact(self, clicker)
	self.nv_last_interaction = 0
	self.nv_loneliness = math.max(0, (self.nv_loneliness or 0) - 20)
	self.nv_mood_value = math.min(100, (self.nv_mood_value or 50) + 5)
	nativevillages.mood.update_mood(self, 0)
end

function nativevillages.mood.on_trade(self, clicker)
	self.nv_last_interaction = 0
	self.nv_loneliness = math.max(0, (self.nv_loneliness or 0) - 25)
	self.nv_mood_value = math.min(100, (self.nv_mood_value or 50) + 20)
	nativevillages.mood.update_mood(self, 0)
end

function nativevillages.mood.get_staticdata_extra(self)
	return {
		nv_mood = self.nv_mood,
		nv_mood_value = self.nv_mood_value,
		nv_hunger = self.nv_hunger,
		nv_loneliness = self.nv_loneliness,
		nv_fear = self.nv_fear,
		nv_last_fed = self.nv_last_fed,
		nv_last_interaction = self.nv_last_interaction,
		nv_current_desire = self.nv_current_desire,
	}
end

function nativevillages.mood.on_activate_extra(self, data)
	if data then
		self.nv_mood = data.nv_mood or "neutral"
		self.nv_mood_value = data.nv_mood_value or 50
		self.nv_hunger = data.nv_hunger or 50
		self.nv_loneliness = data.nv_loneliness or 0
		self.nv_fear = data.nv_fear or 0
		self.nv_last_fed = data.nv_last_fed or 0
		self.nv_last_interaction = data.nv_last_interaction or 0
		self.nv_current_desire = data.nv_current_desire
	end
end

minetest.register_entity("nativevillages:mood_indicator", {
	initial_properties = {
		physical = false,
		collisionbox = {0, 0, 0, 0, 0, 0},
		visual = "sprite",
		visual_size = {x=0.5, y=0.5},
		textures = {"nativevillages_mood_neutral.png"},
		is_visible = true,
		pointable = false,
		static_save = false,
		glow = 5,
	},

	on_step = function(self, dtime)
		local parent = self.object:get_attach()
		if not parent then
			self.object:remove()
		end
	end,

	on_activate = function(self, staticdata)
	end,
})
