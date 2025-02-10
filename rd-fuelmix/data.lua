--
-- Sounds (if possible figure out how to load from __base__ directly)
--     local item_sounds = require("__base__.prototypes.item_sounds")
--

local sound_resource_pickup = {
  filename = "__base__/sound/item/resource-inventory-pickup.ogg",
  volume = 0.6,
  aggregation = { max_count = 1, remove = true },
}
local sound_resource_move = {
  filename = "__base__/sound/item/resource-inventory-move.ogg",
  volume = 0.8,
  aggregation = { max_count = 1, remove = true },
}
local sound_mechanical_pickup = {
  filename = "__base__/sound/item/mechanical-inventory-pickup.ogg",
  volume = 0.8,
  aggregation = { max_count = 1, remove = true },
}
local sound_mechanical_move = {
  filename = "__base__/sound/item/mechanical-inventory-move.ogg",
  volume = 0.7,
  aggregation = { max_count = 1, remove = true },
}


local recipe_category_fuel_processing = {
  type = "recipe-category",
  name = "fuel-mixing"
}

local display_outoffuel = settings.startup["rd-fuelmix-display-out-of-fuel"].value
local separate_research = settings.startup["rd-fuelmix-separate-research"].value

data:extend {
  recipe_category_fuel_processing,
}

local research = {
  -- PrototypeBase
  type = "technology",
  name = "fuel-mixer",

  -- Prototype/Technology
  icon = "__rd-fuelmix__/graphics/mixer-fluid.png",
  icon_size = 512,
  unit = data.raw["technology"]["fluid-handling"]["unit"],
  effects = {},
  prerequisites = { "fluid-handling" },
}

--
--  SOLID MIXER
--

local include_solid_mixer = settings.startup["rd-fuelmix-solid-enable"].value
local solid_mix_amount = settings.startup["rd-fuelmix-solid-amount"].value

local item_solid_fuel_mix = {
  type = "item",
  name = "fuelmix-solid",
  icon = "__rd-fuelmix__/graphics/fuel-solid.png",
  icon_size = 512,
  pick_sound = sound_resource_pickup,
  drop_sound = sound_resource_move,
  weight = 2000,
  fuel_value = settings.startup["rd-fuelmix-solid-fuelvalue"].value .. "MJ",
  subgroup = "raw-resource",
  order = "m",
  stack_size = 100,
  fuel_category = "chemical",
  fuel_acceleration_multiplier = settings.startup["rd-fuelmix-solid-acceleration"].value,
  fuel_top_speed_multiplier = settings.startup["rd-fuelmix-solid-topspeed"].value,
}

local item_solid_fuel_mixer = {
  type = "item",
  name = "fuelmixer-solid",
  icon = "__rd-fuelmix__/graphics/mixer-solid.png",
  icon_size = 512,
  factoriopedia_description = "fuelmixer-solid",
  pick_sound = sound_mechanical_pickup,
  drop_sound = sound_mechanical_move,
  weight = 20000,
  subgroup = "smelting-machine",
  order = "z-e-a",
  place_result = "fuelmixer-solid",
  stack_size = 50,
}

local recipe_solid_mixer = {
  type            = "recipe",
  name            = "fuelmixer-solid",
  enabled         = false,
  energy_required = 4,
  ingredients     = {
    { type = "item", name = "steel-plate",          amount = 10 },
    { type = "item", name = "assembling-machine-1", amount = 1 },
    { type = "item", name = "steel-furnace",        amount = 1 },
  },
  results         = { { type = "item", name = "fuelmixer-solid", amount = 1 } },
}

local recipe_solid_mix = {
  type = "recipe",
  name = "fuel-mixing-solid",
  enabled = false,
  energy_required = 1,
  hidden = true,
  hidden_in_factoriopedia = true,
  ingredients = {},
  category = "fuel-mixing",
  results = { { type = "item", name = "fuelmix-solid", amount = 1 } },
}

local entity_solid_mixer = {
  -- PrototypeBase
  name = "fuelmixer-solid",
  type = "assembling-machine",

  -- Prototype/AssemblingMachine
  fixed_recipe = "fuel-mixing-solid",

  -- Prototype/CraftingMachine
  crafting_categories = { "fuel-mixing" },
  crafting_speed = solid_mix_amount,
  energy_source = {
    type = "burner",
    render_no_power_icon = display_outoffuel,
    emissions_per_minute = { pollution = 4 },
    fuel_inventory_size = 4,
    fuel_categories = { "chemical" },
    light_flicker = {
      minimum_light_size = 1,
      light_intensity_to_size_coefficient = 0.2,
      color = { 1, 0.6, 0 },
      minimum_intensity = 0.05,
      maximum_intensity = 0.2
    },
  },
  energy_usage = (solid_mix_amount * settings.startup["rd-fuelmix-solid-fuelrequired"].value) .. "MW",
  allowed_effects = { "pollution" },
  graphics_set = {
    animation = {
      layers = {
        {
          filename = "__rd-fuelmix__/graphics/mixer-solid.png",
          frame_count = 1,
          width = 512,
          height = 512,
          -- 3 tiles = 96 pixels
          scale = (96 - 6) / 512,
        },
      },
    },
  },

  -- Prototype/EntityWithOwner

  -- Prototype/EntityWithHealth
  max_health = 150,
  corpse = "big-remnants",
  dying_explosion = "medium-explosion",

  -- Prototype/Entity
  icon = "__rd-fuelmix__/graphics/mixer-solid.png",
  icon_size = 512,
  minable = { mining_time = 0.2, result = "fuelmixer-solid" },
  placeable_by = { item = "fuelmixer-solid", count = 1 },
  collision_box = { { -1.4, -1.4, }, { 1.4, 1.4 } },
  drawing_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
  flags = {
    "placeable-neutral",
    "placeable-player",
    "player-creation",
  },
  selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
  working_sound = {
    sound = {
      filename = "__base__/sound/burner-mining-drill-1.ogg",
      volume = 0.8
    }
  },
}

--
--  FLUID MIXER
--

local include_fluid_mixer = settings.startup["rd-fuelmix-fluid-enable"].value
local fluid_mix_amount = settings.startup["rd-fuelmix-fluid-amount"].value

local fluid_fluid_fuel_mix = {
  type = "fluid",
  name = "fuelmix-fluid",
  icon = "__rd-fuelmix__/graphics/fuel-fluid.png",
  icon_size = 512,
  fuel_value = settings.startup["rd-fuelmix-fluid-fuelvalue"].value .. "MJ",
  default_temperature = 15,
  subgroup = "fluid",
  order = "z",
  base_color = { r = 160, g = 32, b = 240 },
  flow_color = { r = 160, g = 32, b = 240 },
}

local item_fluid_fuel_mixer = {
  type = "item",
  name = "fuelmixer-fluid",
  icon = "__rd-fuelmix__/graphics/mixer-fluid.png",
  pick_sound = sound_mechanical_pickup,
  drop_sound = sound_mechanical_move,
  icon_size = 512,
  weight = 20000,
  subgroup = "smelting-machine",
  order = "z-e-b",
  place_result = "fuelmixer-fluid",
  stack_size = 50,
}

local recipe_fluid_mixer = {
  type = "recipe",
  name = "fuelmixer-fluid",
  enabled = false,
  energy_required = 4,
  ingredients = {
    { type = "item", name = "steel-plate",  amount = 10 },
    { type = "item", name = "storage-tank", amount = 1 },
    { type = "item", name = "boiler",       amount = 1 },
  },
  results = { { type = "item", name = "fuelmixer-fluid", amount = 1 } },
}

local recipe_fluid_mix = {
  type = "recipe",
  name = "fuel-mixing-fluid",
  enabled = false,
  energy_required = 1,
  hidden = true,
  hidden_in_factoriopedia = true,
  ingredients = {},
  category = "fuel-mixing",
  results = { { type = "fluid", name = "fuelmix-fluid", amount = 1 } },
}

local entity_fluid_mixer = {
  -- PrototypeBase
  name = "fuelmixer-fluid",
  type = "assembling-machine",

  -- Prototype/AssemblingMachine
  fixed_recipe = "fuel-mixing-fluid",

  -- Prototype/CraftingMachine
  crafting_categories = { "fuel-mixing" },
  crafting_speed = fluid_mix_amount,
  energy_source = {
    type = "fluid",
    render_no_power_icon = display_outoffuel,
    fluid_box = {
      production_type = "input",
      pipe_picture = assembler2pipepictures(),
      pipe_covers = pipecoverspictures(),
      pipe_connections = { { fluid_direction = "input", position = { 0, -1 }, direction = 0 } },
      secondary_draw_orders = { north = -1 },
      volume = 100,
    },
    emissions_per_minute = { pollution = 4 },
    burns_fluid = true,
    scale_fluid_usage = true,
    light_flicker = {
      minimum_light_size = 1,
      light_intensity_to_size_coefficient = 0.2,
      color = { 1, 0.6, 0 },
      minimum_intensity = 0.05,
      maximum_intensity = 0.2
    },
  },
  energy_usage = (fluid_mix_amount * settings.startup["rd-fuelmix-fluid-fuelrequired"].value) .. "MW",
  fluid_boxes = {
    {
      production_type = "output",
      pipe_picture = assembler2pipepictures(),
      pipe_covers = pipecoverspictures(),
      pipe_connections = { { fluid_direction = "output", position = { 0, 1 }, direction = 8 } },
      secondary_draw_orders = { north = -1 },
      volume = 100,
    },

  },
  allowed_effects = { "pollution" },
  graphics_set = {
    animation = {
      layers = {
        {
          filename = "__rd-fuelmix__/graphics/mixer-fluid.png",
          frame_count = 1,
          width = 512,
          height = 512,
          -- 3 tiles = 96 pixels
          scale = (96 - 6) / 512,
        },
      },
    },
  },

  -- Prototype/EntityWithOwner

  -- Prototype/EntityWithHealth
  max_health = 150,
  corpse = "big-remnants",
  dying_explosion = "medium-explosion",

  -- Prototype/Entity
  icon = "__rd-fuelmix__/graphics/mixer-fluid.png",
  icon_size = 512,
  minable = { mining_time = 0.2, result = "fuelmixer-fluid" },
  placeable_by = { item = "fuelmixer-fluid", count = 1 },
  collision_box = { { -1.4, -1.4, }, { 1.4, 1.4 } },
  drawing_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
  flags = {
    "placeable-neutral",
    "placeable-player",
    "player-creation",
  },
  selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
  working_sound = {
    sound = {
      filename = "__base__/sound/burner-mining-drill-1.ogg",
      volume = 0.8
    }
  },
}

--
--  MOD COMPATIBILTY
--

-- pyanodons
if mods["pycoalprocessing"] and not settings.startup["rd-fuelmix-research-pyanodons"].value then
  local base_material = { type = "item", name = "steel-plate", amount = 20 }
  if mods["pypetroleumhandling"] then
    base_material = { type = "item", name = "small-parts-01", amount = 20 }
  end
  recipe_solid_mixer.ingredients = {
    base_material,
    { type = "item", name = "jaw-crusher",          amount = 1 },
    { type = "item", name = "assembling-machine-1", amount = 1 },
  }
  recipe_fluid_mixer.ingredients = {
    base_material,
    { type = "item", name = "tar-processing-unit", amount = 1 },
    { type = "item", name = "boiler",              amount = 1 },
  }
  research.prerequisites = {
    "crusher",
    "tar-processing",
  }
end

--
--  REGISRATION
--

if include_solid_mixer then
  table.insert(research.effects, { type = "unlock-recipe", recipe = "fuelmixer-solid" })
  data:extend {
    item_solid_fuel_mix,
    item_solid_fuel_mixer,
    recipe_solid_mixer,
    recipe_solid_mix,
    entity_solid_mixer,
  }
end

if include_fluid_mixer then
  table.insert(research.effects, { type = "unlock-recipe", recipe = "fuelmixer-fluid" })
  data:extend {
    fluid_fluid_fuel_mix,
    item_fluid_fuel_mixer,
    recipe_fluid_mixer,
    recipe_fluid_mix,
    entity_fluid_mixer,
  }
end

if separate_research then
  data:extend {
    research,
  }
else
  for _, v in pairs(research.effects) do
    table.insert(data.raw["technology"]["fluid-handling"].effects, v)
  end
end
