local S = minetest.get_translator("nativevillages")

local biome_spawn_config = {
	grassland = {
		nodes = {"default:dirt_with_grass", "default:cobble", "default:dirt_with_coniferous_litter", "default:clay"},
		neighbors = {"nativevillages:grasslandbarrel", "default:wood", "default:tree", "doors:door_wood_a"},
		stay_near = {"nativevillages:grasslandbarrel"}
	},
	desert = {
		nodes = {"default:desert_sand", "group:wool"},
		neighbors = {"nativevillages:desertcrpet", "default:wood", "default:desert_stone", "doors:door_wood_a"},
		stay_near = {"nativevillages:hookah", "nativevillages:desertcrpet"}
	},
	savanna = {
		nodes = {"default:dry_dirt_with_dry_grass"},
		neighbors = {"nativevillages:savannashrine", "default:wood", "default:tree", "doors:door_wood_a"},
		stay_near = {"nativevillages:savannashrine"}
	},
	lake = {
		nodes = {"default:dirt", "default:sand"},
		neighbors = {"nativevillages:fishtrap", "default:wood", "doors:door_wood_a"},
		stay_near = {"nativevillages:fishtrap"}
	},
	ice = {
		nodes = {"default:snowblock", "default:ice", "default:snow"},
		neighbors = {"nativevillages:sledge", "default:wood", "doors:door_wood_a"},
		stay_near = {"nativevillages:sledge"}
	},
	cannibal = {
		nodes = {"default:dirt_with_grass", "default:dirt_with_rainforest_litter"},
		neighbors = {"nativevillages:cannibalshrine", "nativevillages:driedpeople"},
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
		collisionbox = {-0.35, -1.0, -0.35, 0.35, 0.8, 0.35},
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
			nativevillages.mood.update_mood(self, dtime)
			return true
		end,

		on_activate = function(self, staticdata, dtime)
			if staticdata and staticdata ~= "" then
				local data = minetest.deserialize(staticdata)
				if data then
					nativevillages.mood.on_activate_extra(self, data)
				end
			end
			nativevillages.mood.init_npc(self)
			if class_def.trade_items and #class_def.trade_items > 0 then
				self.nv_trade_items = class_def.trade_items
			end
		end,

		get_staticdata = function(self)
			local mood_data = nativevillages.mood.get_staticdata_extra(self)
			return minetest.serialize(mood_data)
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

	if not mobs.custom_spawn_nativevillages then
		local spawn_chance = 100
		if class_name == "hostile" or class_name == "raider" then
			spawn_chance = 200
		elseif class_name == "witch" or class_name == "jeweler" then
			spawn_chance = 500
		end

		mobs:spawn({
			name = mob_name,
			nodes = biome_config.nodes,
			neighbors = biome_config.neighbors,
			min_light = 0,
			interval = 30,
			active_object_count = 2,
			chance = spawn_chance,
			min_height = 0,
			max_height = 120,
		})
	end

	mobs:register_egg(mob_name, S(biome_name:gsub("^%l", string.upper) .. " " .. class_name:gsub("^%l", string.upper)), "character.png")
end

for biome_name, biome_config in pairs(biome_spawn_config) do
	for class_name, class_def in pairs(villager_classes) do
		register_villager(class_name, class_def, biome_name, biome_config)
	end
end

print(S("[MOD] Villagers loaded"))
