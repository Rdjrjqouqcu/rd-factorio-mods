data:extend({
	{
		type = "bool-setting",
		name = "rd-sem-require-perms",
		setting_type = "startup",
		default_value = false,
		order = "aa",
	},
	{
		type = "bool-setting",
		name = "rd-sem-admin-debug",
		setting_type = "startup",
		default_value = false,
		order = "ab",
	},
	{
		type = "bool-setting",
		name = "rd-sem-crashsite-items",
		setting_type = "startup",
		default_value = false,
		order = "ba",
	},
	{
		type = "double-setting",
		name = "rd-sem-worm-kill",
		setting_type = "startup",
		default_value = 0.025,
		order = "ea",
	},
})