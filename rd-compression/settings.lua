data:extend({
	{
		type = "string-setting",
		name = "rd-compression-items",
		setting_type = "startup",
		allow_blank = true,
		default_value = "",
		order = "aa",
	},

	{
		type = "string-setting",
		name = "rd-compression-mode",
		setting_type = "startup",
		default_value = "value",
		allowed_values = {"stack", "stack/value", "value"},
		order = "ba",
	},
	{
		type = "double-setting",
		name = "rd-compression-mode-value",
		setting_type = "startup",
		default_value = 100,
		min_value = 0,
		order = "bb",
	},

	{
		type = "int-setting",
		name = "rd-compression-levels",
		setting_type = "startup",
		default_value = 4,
		min_value = 1,
		order = "ca",
	},

	{
		type = "double-setting",
		name = "rd-compression-speed-base",
		setting_type = "startup",
		default_value = 0.5,
		order = "da",
	},
	{
		type = "double-setting",
		name = "rd-compression-speed-multiplier",
		setting_type = "startup",
		default_value = 2,
		order = "db",
	},
})
