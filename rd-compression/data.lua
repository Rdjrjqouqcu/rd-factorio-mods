local recipe_category_compression = {
  type = "recipe-category",
  name = "rd-compression"
}

local recipe_category_decompression = {
  type = "recipe-category",
  name = "rd-decompression"
}

local item_group_compressed = {
  type = "item-group",
  name = "rd-compressed",
  icon = "__rd-compression__/graphics/compressor.png",
  icon_size = 64,
  icon_mipmaps = 4,
}

local item_subgroup_compressed = {
  type = "item-subgroup",
  name = "rd-compressed",
  group = "rd-compressed",
}

local item_compressor = {
  type = "item",
  name = "rd-compressor",
  icon = "__rd-compression__/graphics/compressor.png",
  icon_size = 64,
  subgroup = "smelting-machine",
  order = "z",
  place_result = "rd-compressor",
  stack_size = 50,
}

local item_decompressor = {
  type = "item",
  name = "rd-decompressor",
  icon = "__rd-compression__/graphics/decompressor.png",
  icon_size = 64,
  subgroup = "smelting-machine",
  order = "z",
  place_result = "rd-decompressor",
  stack_size = 50,
}

local entity_compressor = {
  -- PrototypeBase
  name = "rd-compressor",
  type = "furnace",

  -- Prototype/FurnacePrototype
  result_inventory_size = 2,
  source_inventory_size = 1,
  cant_insert_at_source_message_key ="inventory-restriction.cant-be-compressed",

  -- Prototype/CraftingMachine
  crafting_categories = { "rd-compression" },
  crafting_speed = 1,
  show_recipe_icon = false,
  show_recipe_icon_on_map = false,
  energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    drain = "1kW",
  },
  energy_usage = "29kW",
  allowed_effects = { "pollution", "consumption" },
  animation = {
    layers = {
      {
        filename = "__rd-compression__/graphics/compressor.png",
        frame_count = 1,
        width = 64,
        height = 64,
        scale = 32 / 64,
      },
    }
  },

  -- Prototype/EntityWithHealth
  max_health = 150,
  corpse = "big-remnants",
  dying_explosion = "medium-explosion",

  -- Prototype/Entity
  icon = "__rd-compression__/graphics/compressor.png",
  icon_size = 64,
  minable = { mining_time = 0.2, result = "rd-compressor" },
  placeable_by = {item = "rd-compressor", count = 1},
  collision_box = { { -0.4, -0.4, }, { 0.4, 0.4 } },
  drawing_box = {{-0.5, -0.5}, {0.5, 0.5}},
  flags = {
    "placeable-neutral",
    "placeable-player",
    "player-creation",
  },
  selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
  working_sound = {
    sound = {
      filename = "__base__/sound/burner-mining-drill.ogg",
      volume = 0.5
    }
  },
}

local entity_decompressor = {
  -- PrototypeBase
  name = "rd-decompressor",
  type = "furnace",

  -- Prototype/FurnacePrototype
  result_inventory_size = 2,
  source_inventory_size = 1,
  cant_insert_at_source_message_key ="inventory-restriction.cant-be-decompressed",

  -- Prototype/CraftingMachine
  crafting_categories = { "rd-decompression" },
  crafting_speed = 1,
  show_recipe_icon = false,
  show_recipe_icon_on_map = false,
  energy_source = {
    type = "electric",
    usage_priority = "secondary-input",
    drain = "1kW",
  },
  energy_usage = "29kW",
  allowed_effects = { "pollution", "consumption" },
  animation = {
    layers = {
      {
        filename = "__rd-compression__/graphics/decompressor.png",
        frame_count = 1,
        width = 64,
        height = 64,
        scale = 32 / 64,
      },
    }
  },

  -- Prototype/EntityWithHealth
  max_health = 150,
  corpse = "big-remnants",
  dying_explosion = "medium-explosion",

  -- Prototype/Entity
  icon = "__rd-compression__/graphics/decompressor.png",
  icon_size = 64,
  minable = { mining_time = 0.2, result = "rd-decompressor" },
  placeable_by = {item = "rd-decompressor", count = 1},
  collision_box = { { -0.4, -0.4, }, { 0.4, 0.4 } },
  drawing_box = {{-0.5, -0.5}, {0.5, 0.5}},
  flags = {
    "placeable-neutral",
    "placeable-player",
    "player-creation",
  },
  selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
  working_sound = {
    sound = {
      filename = "__base__/sound/burner-mining-drill.ogg",
      volume = 0.5
    }
  },
}

local recipe_compressor = {
  type = "recipe",
  name = "rd-compressor",
  enabled = false,
  energy_required = 4,
  ingredients = {
    {"steel-plate", 10},
    {"assembling-machine-2", 1},
    {"steel-furnace", 1},
  },
  result = "rd-compressor",
}

local recipe_decompressor = {
  type = "recipe",
  name = "rd-decompressor",
  enabled = false,
  energy_required = 4,
  ingredients = {
    {"steel-plate", 10},
    {"assembling-machine-2", 1},
    {"steel-furnace", 1},
  },
  result = "rd-decompressor",
}

local research = {
  -- PrototypeBase
  type = "technology",
  name = "rd-compression",

  -- Prototype/Technology
  icon = "__rd-compression__/graphics/compressor.png",
  icon_size = 64,
  unit = data.raw["technology"]["automation-2"]["unit"],
  effects = {
    {
      type = "unlock-recipe",
      recipe = "rd-compressor",
    },
    {
      type = "unlock-recipe",
      recipe = "rd-decompressor",
    },
  },
  prerequisites = {"automation-2"},
}

if mods["nullius"] then
  recipe_compressor.order = "nullius-" .. recipe_compressor.name
  recipe_decompressor.order = "nullius-" .. recipe_decompressor.name
  recipe_compressor.ingredients = {
    {"nullius-steel-beam", 10},
    {"nullius-medium-assembler-1", 1},
    {"nullius-medium-furnace-1", 1},

  }
  recipe_decompressor.ingredients = recipe_compressor.ingredients
  recipe_compressor.category = "large-crafting"
  recipe_decompressor.category = "large-crafting"
  research.order = "nullius-" .. research.name
  research.unit = data.raw["technology"]["nullius-mass-production-2"].unit
  research.prerequisites = {
    "nullius-mass-production-2",
  }
end

data:extend{
  recipe_category_compression,
  recipe_category_decompression,
  item_group_compressed,
  item_subgroup_compressed,

  item_compressor,
  item_decompressor,
  entity_compressor,
  entity_decompressor,
  recipe_compressor,
  recipe_decompressor,

  research,
}


