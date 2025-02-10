data:extend({
	{
		type = "bool-setting",
		name = "rd-waterbox-separate-research",
		setting_type = "startup",
		default_value = true,
		order = "a",
	},
	{
		type = "bool-setting",
		name = "rd-waterbox-iron-chest",
		setting_type = "startup",
		default_value = false,
		order = "b",
	},
	{
		type = "string-setting",
		name = "rd-waterbox-valid-surfaces",
		setting_type = "startup",
		default_value = "nauvis, fulgora, vulcanus, gleba, aquilo",
		allow_blank = true,
		order = "c",
	}
})
