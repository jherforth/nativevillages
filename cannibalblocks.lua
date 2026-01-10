local S = minetest.get_translator("lualore")

minetest.register_node("lualore:driedpeople", {
	description = S"Dried Human Remains",
	tiles = {
		"lualore_driedpeople_top.png",
		"lualore_driedpeople_bottom.png",
		"lualore_driedpeople_right.png",
		"lualore_driedpeople_left.png",
		"lualore_driedpeople_back.png",
		"lualore_driedpeople_front.png"
	},
	groups = {crumbly = 3},
	drop = "lualore:driedhumanmeat 9",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
	output = "lualore:driedpeople",
	recipe = {
		{"lualore:driedhumanmeat", "lualore:driedhumanmeat", "lualore:driedhumanmeat"},
		{"lualore:driedhumanmeat", "lualore:driedhumanmeat", "lualore:driedhumanmeat"},
		{"lualore:driedhumanmeat", "lualore:driedhumanmeat", "lualore:driedhumanmeat"},
	}
})


minetest.register_craftitem(":lualore:driedhumanmeat", {
	description = S("Dried Human Meat"),
	inventory_image = "lualore_driedhumanmeat.png",
	on_use = minetest.item_eat(2),
	groups = {mushroom = 1, snappy = 3, attached_node = 1, flammable = 1},
})


minetest.register_node("lualore:cannibalshrine", {
    description = S"Cannibal Shrine",
    visual_scale = 1,
    mesh = "Cannibalshrine.b3d",
    tiles = {"texturecannibalshrine.png"},
    inventory_image = "acannibalshrine.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    walkable = false,
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            --[[{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "cooking",
	output = "default:bronzeblock",
	recipe = "lualore:cannibalshrine",

})
