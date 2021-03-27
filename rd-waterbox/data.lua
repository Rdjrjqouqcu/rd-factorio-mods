
local entity = {
  -- PrototypeBase
  name = "waterbox",
  type = "simple-entity-with-owner",
  -- Prototype/Entity
  icon = "__rd-waterbox__/graphics/waterbox.png",
  icon_size = 40,
  allow_copy_paste = true,
  collision_box = {{-0.49, -0.49}, {0.49, 0.49}},
  flags = {"player-creation"},
  minable = { mining_time = 1, result = "waterbox", count = 1, mining_particle = "wooden-particle"},
  placeable_by = {item = "waterbox", count = 1},
  remove_decoratives = true,
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  -- Prototype/EntityWithHealth
  alert_when_damaged = false,
  corpse = nil,
  create_ghost_on_death = false,
  dying_explosion = table.deepcopy(data.raw["container"]["wooden-chest"]["dying_explosion"]),
  max_health = 10,
  -- Prototype/SimpleEntityWithOwner
  picture = {
    filename = "__rd-waterbox__/graphics/waterbox.png",
    size = 40,
  },
}

local item = {
  -- PrototypeBase
  name = "waterbox",
  type = "item",
  -- Prototype/Item
  icon = "__rd-waterbox__/graphics/waterbox.png",
  icon_size = 40,
  stack_size = 50,
  place_result = "waterbox",
}

local chest_item = "wooden-chest"
if settings.startup["rd-waterbox-iron-chest"].value  then
  chest_item = "iron-chest"
end

local recipe = {
  -- PrototypeBase
	type = "recipe",
  name = "waterbox",
	order = "z",
  -- Prototype/Recipe
	ingredients = {
		{"explosives", 10},
		{chest_item, 1},
		{"grenade", 1},
	},
	category = "crafting",
	enabled = "false",
	energy_required = 4,
	result = "waterbox",
	subgroup = "terrain",
}

local research = {
  -- PrototypeBase
  type = "technology",
  name = "waterboxes",
  -- Prototype/Technology
  icon = "__rd-waterbox__/graphics/waterbox-technology.png",
  icon_size = 100,
  unit = data.raw["technology"]["cliff-explosives"]["unit"],
  effects = {
    {
      type = "unlock-recipe",
      recipe = "waterbox"
    }
  },
  prerequisites = data.raw["technology"]["cliff-explosives"]["prerequisites"],
}

local separate_research = settings.startup["rd-waterbox-separate-research"].value

data:extend{entity, item, recipe}
if separate_research then
  data:extend{research}
else
    table.insert(data.raw["technology"]["cliff-explosives"].effects, {type = "unlock-recipe",recipe = "waterbox"})
end
