data:extend({
	{
		type = "int-setting",
		name = "rd-timelapse-map-delay",
		setting_type = "startup",
		default_value = 15,
		minimum_value = 1,
		order = "a-a",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-seed",
		setting_type = "startup",
		default_value = false,
		order = "a-b",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-autosave",
		setting_type = "startup",
		default_value = true,
		order = "b-a",
	},
	{
		type = "string-setting",
		name = "rd-timelapse-map-surfaces",
		setting_type = "startup",
		default_value = "nauvis",
		order = "c-a",
	},
	{
		type = "string-setting",
		name = "rd-timelapse-map-forces",
		setting_type = "startup",
		default_value = "player",
		order = "c-b",
	},
	{
		type = "int-setting",
		name = "rd-timelapse-map-resolution",
		setting_type = "startup",
		default_value = 64,
		minimum_value = 1,
		maximum_value = 512,
		order = "d-a",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-screenshot-altmode",
		setting_type = "startup",
		default_value = true,
		order = "d-b",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-screenshot-fix-crash-site",
		setting_type = "startup",
		default_value = true,
		order = "d-c",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-create-site",
		setting_type = "startup",
		default_value = false,
		order = "e-a",
	},

	{
		type = "bool-setting",
		name = "rd-timelapse-map-show-timer",
		setting_type = "runtime-per-user",
		default_value = true,
		order = "a-a",
	},
})