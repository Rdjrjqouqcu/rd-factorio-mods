
-- startup settings

-- data:extend({
-- })

-- runtime-global settings

data:extend({
	{
		type = "int-setting",
		name = "rd-timelapse-map-delay",
		setting_type = "runtime-global",
		default_value = 15,
		minimum_value = 1,
		order = "a-a",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-seed",
		setting_type = "runtime-global",
		default_value = false,
		order = "a-b",
	},
	{
		type = "int-setting",
		name = "rd-timelapse-map-radius",
		setting_type = "runtime-global",
		default_value = 4,
		minimum_value = 0,
		order = "a-c",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-autosave",
		setting_type = "runtime-global",
		default_value = true,
		order = "b-a",
	},
	{
		type = "string-setting",
		name = "rd-timelapse-map-mode",
		setting_type = "runtime-global",
		default_value = "entities",
		allowed_values = {"entities", "charted", "revealed"},
		order = "c-a",
	},
	{
		type = "string-setting",
		name = "rd-timelapse-map-surfaces",
		setting_type = "runtime-global",
		default_value = "nauvis",
		order = "c-b",
	},
	{
		type = "string-setting",
		name = "rd-timelapse-map-forces",
		setting_type = "runtime-global",
		default_value = "player",
		order = "c-c",
	},
	{
		type = "int-setting",
		name = "rd-timelapse-map-resolution",
		setting_type = "runtime-global",
		default_value = 64,
		minimum_value = 1,
		maximum_value = 512,
		order = "d-a",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-screenshot-altmode",
		setting_type = "runtime-global",
		default_value = true,
		order = "d-b",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-screenshot-fix-crash-site",
		setting_type = "runtime-global",
		default_value = true,
		order = "d-c",
	},
	{
		type = "bool-setting",
		name = "rd-timelapse-map-create-site",
		setting_type = "runtime-global",
		default_value = false,
		order = "e-a",
	},
})

-- runtime-per-user settings

data:extend({
	{
		type = "bool-setting",
		name = "rd-timelapse-map-show-timer",
		setting_type = "runtime-per-user",
		default_value = true,
		order = "a-a",
	},
})
