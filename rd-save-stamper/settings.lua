data:extend({
	{
		type = "int-setting",
		name = "rd-save-stamper-delay",
		setting_type = "startup",
		default_value = 15,
		minimum_value = 1,
		order = "a-a",
	},
	{
		type = "bool-setting",
		name = "rd-save-stamper-autosave",
		setting_type = "startup",
		default_value = true,
		order = "a-b",
	},
	{
		type = "bool-setting",
		name = "rd-save-stamper-seed",
		setting_type = "startup",
		default_value = true,
		order = "a-c",
	},
	{
		type = "string-setting",
		name = "rd-save-stamper-name",
		setting_type = "startup",
		default_value = "auto/%d_%s",
		order = "a-d",
	},
	{
		type = "int-setting",
		name = "rd-save-stamper-padding",
		setting_type = "startup",
		default_value = 6,
		minimum_value = 0,
		order = "a-e",
	},
})
