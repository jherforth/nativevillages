local S = minetest.get_translator("lualore")

minetest.register_node("lualore:sledge", {
    description = S"Sledge",
    visual_scale = 1,
    mesh = "Sledge.b3d",
    tiles = {"texturesledge.png"},
    inventory_image = "asledge.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -1.3, 0.5, 0.5, 1.3},
            --[[{-0.5, -0.5, -1.3, 0.5, 0.5, 1.3},
            {-0.5, -0.5, -1.3, 0.5, 0.5, 1.3}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -1.3, 0.5, 0.5, 1.3}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "cooking",
	output = "default:bronzeblock",
	recipe = "lualore:sledge",
})

minetest.register_node("lualore:blanket", {
    description = S"Blanket",
    visual_scale = 1,
    mesh = "Blanket.b3d",
    tiles = {"textureblanket.png"},
    inventory_image = "ablanket.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5},
            --[[{-0.5, -0.5, -0.5, 0.5, -0.45, 0.5},
            {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_craft({
	type = "cooking",
	output = "mobs:leather",
	recipe = "lualore:blanket",

})
