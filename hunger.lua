if minetest.get_modpath("hunger_ng") ~= nil then
hunger_ng.add_hunger_data('lualore:bucket_milk', {
		satiates = 1.0,
	})
	hunger_ng.add_hunger_data('lualore:cheese', {
		satiates = 1.0,
	})
	hunger_ng.add_hunger_data('lualore:catfish_raw', {
		satiates = 1.0,
	})
	hunger_ng.add_hunger_data('lualore:catfish_cooked', {
		satiates = 2.0,
	})
	hunger_ng.add_hunger_data('lualore:chicken_raw', {
		satiates = 1.0,
	})
	hunger_ng.add_hunger_data('lualore:chicken_cooked', {
		satiates = 2.0,
	})
	hunger_ng.add_hunger_data('lualore:chicken_egg_fried', {
		satiates = 1.0,
	})
	hunger_ng.add_hunger_data('lualore:butter', {
		satiates = 1.0,
	})
	hunger_ng.add_hunger_data('lualore:driedhumanmeat', {
		satiates = 2.0,
	})

end
