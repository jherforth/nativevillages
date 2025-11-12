local S = minetest.get_translator("nativevillages")

local biome_spawn_config = {
	grassland = {
		nodes = {"default:dirt_with_grass", "default:cobble", "default:dirt_with_coniferous_litter", "default:clay"},
		markers = {"nativevillages:grasslandbarrel"},
		stay_near = {"nativevillages:grasslandbarrel"}
	},
	desert = {
		nodes = {"default:desert_sand", "group:wool"},
		markers = {"nativevillages:hookah", "nativevillages:desertcrpet"},
		stay_near = {"nativevillages:hookah", "nativevillages:desertcrpet"}
	},
	savanna = {
		nodes = {"default:dry_dirt_with_dry_grass"},
		markers = {"nativevillages:savannashrine"},
		stay_near = {"nativevillages:savannashrine"}
	},
	lake = {
		nodes = {"default:dirt", "default:sand"},
		markers = {"nativevillages:fishtrap"},
		stay_near = {"nativevillages:fishtrap"}
	},
	ice = {
		nodes = {"default:snowblock", "default:ice", "default:snow"},
		markers = {"nativevillages:sledge"},
		stay_near = {"nativevillages:sledge"}
	},
	cannibal = {
		nodes = {"default:dirt_with_grass", "default:dirt_with_rainforest_litter"},
		markers = {"nativevillages:cannibalshrine", "nativevillages:driedpeople"},
		stay_near = {"nativevillages:cannibalshrine", "nativevillages:driedpeople"}
	}
}

local villager_classes = {
	hostile = {
		type = "monster",
		passive = false,
		damage = 8,
		hp_min = 70,
		hp_max = 100,
		armor = 100,
		attack_type = "dogfight",
		attacks_monsters = false,
		attack_npcs = true,
		reach = 2,
		drops = {},
		trade_items = {},
	},
	raider = {
		type = "monster",
		passive = false,
		damage = 6,
		hp_min = 60,
		hp_max = 90,
		armor = 100,
		attack_type = "dogfight",
		attacks_monsters = false,
		attack_npcs = true,
		reach = 2,
		drops = {"default:iron_lump"},
		trade_items = {},
	},
	ranger = {
		type = "npc",
		passive = false,
		damage = 5,
		hp_min = 50,
		hp_max = 80,
		armor = 120,
		attack_type = "dogfight",
		attacks_monsters = true,
		attack_npcs = false,
		reach = 2,
		drops = {"default:copper_lump", "default:tin_lump"},
		trade_items = {"farming:bread", "default:apple"},
	},
	jeweler = {
		type = "npc",
		passive = true,
		damage = 2,
		hp_min = 30,
		hp_max = 50,
		armor = 80,
		attack_type = "dogfight",
		attacks_monsters = false,
		attack_npcs = false,
		reach = 1,
		drops = {"default:gold_lump", "default:diamond"},
		trade_items = {"default:gold_lump"},
	},
	farmer = {
		type = "npc",
		passive = true,
		damage = 3,
		hp_min = 40,
		hp_max = 70,
		armor = 100,
		attack_type = "dogfight",
		attacks_monsters = false,
		attack_npcs = false,
		reach = 1,
		drops = {"farming:wheat", "farming:bread"},
		trade_items = {"farming:bread", "farming:wheat"},
	},
	blacksmith = {
		type = "npc",
		passive = false,
		damage = 6,
		hp_min = 70,
		hp_max = 100,
		armor = 150,
		attack_type = "dogfight",
		attacks_monsters = true,
		attack_npcs = false,
		reach = 2,
		drops = {"default:iron_lump", "default:steel_ingot"},
		trade_items = {"default:iron_lump", "default:coal_lump"},
	},
	fisherman = {
		type = "npc",
		passive = true,
		damage = 2,
		hp_min = 35,
		hp_max = 60,
		armor = 90,
		attack_type = "dogfight",
		attacks_monsters = false,
		attack_npcs = false,
		reach = 1,
		drops = {"nativevillages:catfish_raw"},
		trade_items = {"nativevillages:catfish_raw", "nativevillages:catfish_cooked"},
	},
	cleric = {
		type = "npc",
		passive = true,
		damage = 3,
		hp_min = 50,
		hp_max = 75,
		armor = 100,
		attack_type = "dogfight",
		attacks_monsters = true,
		attack_npcs = false,
		reach = 2,
		drops = {"default:mese_crystal"},
		trade_items = {"default:mese_crystal_fragment"},
	},
	bum = {
		type = "npc",
		passive = true,
		damage = 1,
		hp_min = 20,
		hp_max = 40,
		armor = 70,
		attack_type = "dogfight",
		attacks_monsters = false,
		attack_npcs = false,
		reach = 1,
		drops = {"default:stick"},
		trade_items = {"farming:bread", "default:apple"},
	},
	entertainer = {
		type = "npc",
		passive = true,
		damage = 2,
		hp_min = 30,
		hp_max = 55,
		armor = 80,
		attack_type = "dogfight",
		attacks_monsters = false,
		attack_npcs = false,
		reach = 1,
		drops = {"default:gold_lump"},
		trade_items = {"default:gold_lump"},
	},
	witch = {
		type = "npc",
		passive = false,
		damage = 7,
		hp_min = 60,
		hp_max = 90,
		armor = 110,
		attack_type = "dogfight",
		attacks_monsters = true,
		attack_npcs = false,
		reach = 3,
		drops = {"default:mese_crystal", "nativevillages:zombietame"},
		trade_items = {"nativevillages:driedhumanmeat", "default:mese_crystal_fragment"},
	},
}

local class_order = {"hostile", "raider", "ranger", "jeweler", "farmer", "blacksmith", "fisherman", "cleric", "bum", "entertainer", "witch"}

local function register_villager(class_name, class_def, biome_name, biome_config)
	local mob_name = "nativevillages:" .. biome_name .. "_" .. class_name

	mobs:register_mob(mob_name, {
		type = class_def.type,
		passive = class_def.passive,
		damage = class_def.damage,
		attack_type = class_def.attack_type,
		attacks_monsters = class_def.attacks_monsters,
		attack_npcs = class_def.attack_npcs,
		owner_loyal = true,
		pathfinding = true,
		hp_min = class_def.hp_min,
		hp_max = class_def.hp_max,
		armor = class_def.armor,
		reach = class_def.reach,
		collisionbox = {-0.35, 0.0, -0.35, 0.35, 1.8, 0.35},
		visual = "mesh",
		mesh = "character.b3d",
		textures = {
			{class_name .. "1.png"},
			{class_name .. "2.png"},
		},
		visual_size = {x=1, y=1},
		makes_footstep_sound = true,
		sounds = {},
		walk_velocity = 1,
		walk_chance = 15,
		run_velocity = 3,
		jump = true,
		drops = class_def.drops,
		water_damage = 0,
		lava_damage = 2,
		light_damage = 0,
		follow = {},
		stay_near = {biome_config.stay_near, 5},
		view_range = 15,
		owner = "",
		order = "follow",
		fear_height = 3,
		animation = {
			speed_normal = 30,
			stand_start = 0,
			stand_end = 79,
			walk_start = 168,
			walk_end = 187,
			punch_start = 189,
			punch_end = 198,
			die_start = 162,
			die_end = 166,
			die_speed = 15,
			die_loop = false,
			die_rotate = true,
		},

		do_custom = function(self, dtime)
			if class_def.trade_items and #class_def.trade_items > 0 then
				self.nv_trade_items = class_def.trade_items
			end

			if not self.nv_hp_max then
				self.nv_hp_max = class_def.hp_max
			end

			if self.health and self.health > 0 and self.nv_hp_max then
				local health_percent = (self.health / self.nv_hp_max) * 100

				if health_percent < 30 then
					self.nv_mood = "sad"
					self.passive = true
					self.attack = nil
				elseif self.nv_recently_damaged and health_percent > 30 then
					self.nv_mood = "angry"
					if class_def.type ~= "npc" or class_def.attacks_monsters then
						self.passive = false
					end
				end
			end

			nativevillages.mood.update_mood(self, dtime)
			return true
		end,

		on_activate = function(self, staticdata, dtime)
			if staticdata and staticdata ~= "" then
				local tmp = minetest.deserialize(staticdata)

				if tmp then
					for tag, stat in pairs(tmp) do
						self[tag] = stat
					end
				end
			end

			nativevillages.mood.init_npc(self)
			if class_def.trade_items and #class_def.trade_items > 0 then
				self.nv_trade_items = class_def.trade_items
			end
		end,

		get_staticdata = function(self)
			if self.nv_mood_indicator then
				self.nv_mood_indicator:remove()
				self.nv_mood_indicator = nil
			end

			self.attack = nil

			local function is_serializable(value)
				local t = type(value)

				if t == "function" or t == "userdata" or t == "thread" then
					return false
				end

				if t == "table" then
					for k, v in pairs(value) do
						if not is_serializable(k) or not is_serializable(v) then
							return false
						end
					end
				end

				return true
			end

			local tmp = {}

			for tag, stat in pairs(self) do
				if tag ~= "object"
				and tag ~= "_cmi_components"
				and is_serializable(stat) then
					tmp[tag] = stat
				end
			end

			return minetest.serialize(tmp)
		end,

		on_die = function(self, pos)
			if self.nv_mood_indicator then
				self.nv_mood_indicator:remove()
				self.nv_mood_indicator = nil
			end
		end,

		on_punch = function(self, hitter, tflp, tool_capabilities, dir)
			if not self.health then return end

			if not self.nv_hp_max then
				self.nv_hp_max = class_def.hp_max
			end

			self.nv_recently_damaged = true
			self.nv_damage_timer = 0

			minetest.after(5, function()
				if self and self.object then
					self.nv_recently_damaged = false
				end
			end)

			if self.health and self.health > 0 and self.nv_hp_max then
				local health_percent = (self.health / self.nv_hp_max) * 100

				if health_percent < 30 then
					self.nv_mood = "sad"
					self.nv_mood_value = 10
					self.passive = true
					self.attack = nil
					self.state = "runaway"
				else
					self.nv_mood = "angry"
					self.nv_mood_value = 5
					self.nv_fear = 80

					if class_def.type == "monster" or class_def.attacks_monsters then
						self.passive = false
						if hitter and hitter:is_player() then
							self.attack = hitter
						end
					else
						self.state = "runaway"
					end
				end
			end

			nativevillages.mood.update_indicator(self)
		end,

		on_rightclick = function(self, clicker)
			nativevillages.mood.on_interact(self, clicker)

			if mobs:feed_tame(self, clicker, 8, true, true) then
				nativevillages.mood.on_feed(self, clicker)
				return
			end

			if mobs:capture_mob(self, clicker, 0, 15, 25, false, nil) then return end
			if mobs:protect(self, clicker) then return end

			local item = clicker:get_wielded_item()
			local name = clicker:get_player_name()

			if class_def.trade_items and #class_def.trade_items > 0 then
				local trade_item = class_def.trade_items[1]
				if item:get_name() == trade_item then
					if not mobs.is_creative(name) then
						item:take_item()
						clicker:set_wielded_item(item)
					end

					local pos = self.object:get_pos()
					pos.y = pos.y + 0.5

					local drops = class_def.drops
					if #drops > 0 then
						minetest.add_item(pos, {
							name = drops[math.random(1, #drops)]
						})
					end

					minetest.chat_send_player(name, S("Villager traded with you!"))
					nativevillages.mood.on_trade(self, clicker)
					return
				end
			end

			if self.owner and self.owner == name then
				if self.order == "follow" then
					self.attack = nil
					self.order = "stand"
					self.state = "stand"
					self:set_animation("stand")
					self:set_velocity(0)
					minetest.chat_send_player(name, S("Villager stands still."))
				else
					self.order = "follow"
					minetest.chat_send_player(name, S("Villager will follow you."))
				end
			end
		end,
	})

	mobs:register_egg(mob_name, S(biome_name:gsub("^%l", string.upper) .. " " .. class_name:gsub("^%l", string.upper)), "character.png")
end

for biome_name, biome_config in pairs(biome_spawn_config) do
	for class_name, class_def in pairs(villager_classes) do
		register_villager(class_name, class_def, biome_name, biome_config)
	end
end

local villages_spawned = {}

local function find_village_center(pos, biome_markers, radius)
	local marker_positions = minetest.find_nodes_in_area(
		{x=pos.x-radius, y=pos.y-10, z=pos.z-radius},
		{x=pos.x+radius, y=pos.y+10, z=pos.z+radius},
		biome_markers
	)

	if #marker_positions > 0 then
		local center = {x=0, y=0, z=0, count=0}
		for _, mpos in ipairs(marker_positions) do
			center.x = center.x + mpos.x
			center.y = center.y + mpos.y
			center.z = center.z + mpos.z
			center.count = center.count + 1
		end

		center.x = math.floor(center.x / center.count)
		center.y = math.floor(center.y / center.count)
		center.z = math.floor(center.z / center.count)

		return {x=center.x, y=center.y, z=center.z}
	end

	return nil
end

local function get_village_key(pos)
	return math.floor(pos.x/50) .. "," .. math.floor(pos.z/50)
end

local function spawn_villagers_near(center_pos, biome_name)
	local biome_config = biome_spawn_config[biome_name]
	if not biome_config then return end

	local spawn_radius = 15
	local class_index = 0

	for _, class_name in ipairs(class_order) do
		local mob_name = "nativevillages:" .. biome_name .. "_" .. class_name

		local angle = (class_index / #class_order) * math.pi * 2
		local distance = math.random(5, spawn_radius)

		local spawn_pos = {
			x = center_pos.x + math.cos(angle) * distance,
			y = center_pos.y,
			z = center_pos.z + math.sin(angle) * distance
		}

		local ground_pos = minetest.find_node_near(spawn_pos, 5, biome_config.nodes)
		if ground_pos then
			ground_pos.y = ground_pos.y + 1
			minetest.add_entity(ground_pos, mob_name)
		end

		class_index = class_index + 1
	end
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	for biome_name, biome_config in pairs(biome_spawn_config) do
		local center_pos = find_village_center(
			{x=(minp.x+maxp.x)/2, y=(minp.y+maxp.y)/2, z=(minp.z+maxp.z)/2},
			biome_config.markers,
			40
		)

		if center_pos then
			local village_key = get_village_key(center_pos)

			if not villages_spawned[village_key] then
				villages_spawned[village_key] = true
				minetest.after(2, function()
					spawn_villagers_near(center_pos, biome_name)
				end)
			end
		end
	end
end)

print(S("[MOD] Villagers loaded"))
