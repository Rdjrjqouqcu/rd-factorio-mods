data:extend({
	{
		type = "bool-setting",
		name = "rd-antidark-separate-research",
		setting_type = "startup",
		default_value = true,
		order = "a-a",
	},
	{
		type = "bool-setting",
		name = "rd-antidark-arealight-enabled",
		setting_type = "startup",
		default_value = true,
		order = "b-a",
	},
	{
		type = "int-setting",
		name = "rd-antidark-arealight-radius",
		setting_type = "startup",
		default_value = 80,
		minimum_value = 0,
		order = "b-b",
	},
	{
		type = "bool-setting",
		name = "rd-antidark-arealight-usepower",
		setting_type = "startup",
		default_value = true,
		order = "b-c",
	},
	{
		type = "bool-setting",
		name = "rd-antidark-solarlight-enabled",
		setting_type = "startup",
		default_value = true,
		order = "c-a",
	},
	{
		type = "int-setting",
		name = "rd-antidark-phantom-drain",
		setting_type = "startup",
		default_value = 10000,
		minimum_value = 0,
		order = "d-a",
	},
	{
		type = "int-setting",
		name = "rd-antidark-phantom-drain-mult",
		setting_type = "startup",
		default_value = 100,
		minimum_value = 0,
		order = "d-b",
	},
	{
		type = "double-setting",
		name = "rd-antidark-charge-mult",
		setting_type = "startup",
		default_value = 1.0,
		minimum_value = 1.0,
		order = "d-c",
	},
	{
		type = "bool-setting",
		name = "rd-antidark-chunklight-enabled",
		setting_type = "startup",
		default_value = true,
		order = "e-a",
	},
	{
		type = "bool-setting",
		name = "rd-antidark-radarlight-enabled",
		setting_type = "startup",
		default_value = true,
		order = "f-a",
	},
	{
		type = "int-setting",
		name = "rd-antidark-radarlight-chunkradius",
		setting_type = "startup",
		default_value = 3,
		minimum_value = 0,
		order = "f-b",
	},
})
