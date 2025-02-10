local chest_item = "wooden-chest"
if settings.startup["rd-waterbox-iron-chest"].value then
  chest_item = "iron-chest"
end

local entity = {
  -- PrototypeBase
  name = "waterbox",
  type = "simple-entity-with-owner",
  -- Prototype/Entity
  icon = "__rd-waterbox__/graphics/waterbox.png",
  icon_size = 40,
  allow_copy_paste = true,
  collision_box = { { -0.49, -0.49 }, { 0.49, 0.49 } },
  flags = { "player-creation" },
  minable = { mining_time = 1, result = "waterbox", count = 1, mining_particle = "wooden-particle" },
  placeable_by = { item = "waterbox", count = 1 },
  remove_decoratives = "true",
  selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
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
  pick_sound = {
    filename = "__base__/sound/item/wood-inventory-pickup.ogg",
    volume = 0.6,
    aggregation = { max_count = 1, remove = true },
  },
  drop_sound = {
    filename = "__base__/sound/item/wood-inventory-move.ogg",
    volume = 0.7,
    aggregation = { max_count = 1, remove = true },
  },
  stack_size = 50,
  weight = 5000,
  place_result = "waterbox",
  subgroup = "terrain",
  order = "e",
}

local recipe = {
  -- PrototypeBase
  type = "recipe",
  name = "waterbox",
  order = "z",
  -- Prototype/Recipe
  ingredients = {
    { type = "item", name = "explosives", amount = 10 },
    { type = "item", name = chest_item,   amount = 1 },
    { type = "item", name = "grenade",    amount = 1 },
  },
  category = "crafting",
  enabled = false,
  energy_required = 4,
  results = { { type = "item", name = "waterbox", amount = 1 } },
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

data:extend { entity, item, recipe }
if separate_research then
  data:extend { research }
else
  table.insert(data.raw["technology"]["cliff-explosives"].effects, { type = "unlock-recipe", recipe = "waterbox" })
end
