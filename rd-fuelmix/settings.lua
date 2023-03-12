data:extend({
	{
		type = "bool-setting",
		name = "rd-fuelmix-solid-enable",
		setting_type = "startup",
		default_value = true,
		order = "a",
	},
	{
		type = "int-setting",
		name = "rd-fuelmix-solid-fuelrequired",
		setting_type = "startup",
		default_value = 10,
		order = "b",
	},
	{
		type = "int-setting",
		name = "rd-fuelmix-solid-fuelvalue",
		setting_type = "startup",
		default_value = 10,
		order = "b",
	},
	{
		type = "double-setting",
		name = "rd-fuelmix-solid-acceleration",
		setting_type = "startup",
		default_value = 1.0,
		order = "c",
	},
	{
		type = "double-setting",
		name = "rd-fuelmix-solid-topspeed",
		setting_type = "startup",
		default_value = 1.0,
		order = "d",
	},
})