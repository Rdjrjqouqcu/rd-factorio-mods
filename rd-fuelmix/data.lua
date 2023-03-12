

local recipe_category_fuel_processing = {
  type = "recipe-category",
  name = "fuel-mixing"
}

local display_outoffuel = settings.startup["rd-fuelmix-display-out-of-fuel"].value
local separate_research = settings.startup["rd-fuelmix-separate-research"].value

data:extend{
  recipe_category_fuel_processing
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
  prerequisites = {"fluid-handling"},
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
  fuel_value = settings.startup["rd-fuelmix-solid-fuelvalue"].value .. "MJ",
  subgroup = "raw-material",
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
  icon_mipmaps = 1,
  subgroup = "smelting-machine",
  order = "z",
  place_result = "fuelmixer-solid",
  stack_size = 50,
}

local recipe_solid_mixer = {
  type = "recipe",
  name = "fuelmixer-solid",
  -- TODO add research
  enabled = true, 
  energy_required = 4,
  ingredients = {
    {"steel-plate", 10},
    {"stone-brick", 10},
    {"stone-furnace", 1},
  },
  result = "fuelmixer-solid",
}

local recipe_solid_mix = {
  type = "recipe",
  name = "fuel-mixing-solid",
  enabled = false,
  energy_required = 1,
  ingredients = {},
  category = "fuel-mixing",
  result = "fuelmix-solid",
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
    emissions_per_minute = 4,
    fuel_inventory_size = 4,
    fuel_category = "chemical",
    light_flicker = {
      minimum_light_size = 1,
      light_intensity_to_size_coefficient = 0.2,
      color = {1,0.6,0},
      minimum_intensity = 0.05,
      maximum_intensity = 0.2
    },
  },
  energy_usage = (solid_mix_amount * settings.startup["rd-fuelmix-solid-fuelrequired"].value) .. "MW",
  allowed_effects = { "pollution"},
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
    }
  },

  -- Prototype/EntityWithOwner

  -- Prototype/EntityWithHealth
  max_health = 150,
  corpse = "big-remnants",
  dying_explosion = "medium-explosion",

  -- Prototype/Entity
  icon = "__rd-fuelmix__/graphics/mixer-solid.png",
  icon_size = 40,
  minable = { mining_time = 0.2, result = "fuelmixer-solid" },
  placeable_by = {item = "fuelmixer-solid", count = 1},
  collision_box = { { -1.4, -1.4, }, { 1.4, 1.4 } },
  drawing_box = {{-1.5, -1.5}, {1.5, 1.5}},
  flags = {
    "placeable-neutral",
    "placeable-player",
    "player-creation",
  },
  selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
  working_sound = {
    sound = {
      filename = "__base__/sound/burner-mining-drill.ogg",
      volume = 0.8
    }
  },
}

if include_solid_mixer then
  table.insert(research.effects,{type = "unlock-recipe",recipe = "fuelmixer-solid"})
  data:extend{
    item_solid_fuel_mix,
    item_solid_fuel_mixer,
    recipe_solid_mixer,
    recipe_solid_mix,
    entity_solid_mixer,
  }
end

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
  base_color = {r=160, g=32, b=240, a=1},
  flow_color = {r=160, g=32, b=240, a=1},
}

local item_fluid_fuel_mixer = {
  type = "item",
  name = "fuelmixer-fluid",
  icon = "__rd-fuelmix__/graphics/mixer-fluid.png",
  icon_size = 512,
  icon_mipmaps = 1,
  subgroup = "smelting-machine",
  order = "z",
  place_result = "fuelmixer-fluid",
  stack_size = 50,
}

local recipe_fluid_mixer = {
  type = "recipe",
  name = "fuelmixer-fluid",
  -- TODO add research
  enabled = true, 
  energy_required = 4,
  ingredients = {
    {"steel-plate", 10},
    {"stone-brick", 10},
    {"boiler", 1},
  },
  result = "fuelmixer-fluid",
}

local recipe_fluid_mix = {
  type = "recipe",
  name = "fuel-mixing-fluid",
  enabled = false,
  energy_required = 1,
  ingredients = {},
  category = "fuel-mixing",
  results = {{type="fluid", name="fuelmix-fluid", amount=1}},
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
      base_area = 1,
      base_level = -1,
      pipe_connections = {{ type="input", position = {0, -2} }},
      secondary_draw_orders = { north = -1 }
    },
    emissions_per_minute = 4,
    burns_fluid = true,
    scale_fluid_usage = true,
    light_flicker = {
      minimum_light_size = 1,
      light_intensity_to_size_coefficient = 0.2,
      color = {1,0.6,0},
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
      base_area = 1,
      base_level = 1,
      pipe_connections = {{ type="output", position = {0, 2} }},
      secondary_draw_orders = { north = -1 }
    },

  },
  allowed_effects = { "pollution"},
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
    }
  },

  -- Prototype/EntityWithOwner

  -- Prototype/EntityWithHealth
  max_health = 150,
  corpse = "big-remnants",
  dying_explosion = "medium-explosion",

  -- Prototype/Entity
  icon = "__rd-fuelmix__/graphics/mixer-fluid.png",
  icon_size = 40,
  minable = { mining_time = 0.2, result = "fuelmixer-fluid" },
  placeable_by = {item = "fuelmixer-fluid", count = 1},
  collision_box = { { -1.4, -1.4, }, { 1.4, 1.4 } },
  drawing_box = {{-1.5, -1.5}, {1.5, 1.5}},
  flags = {
    "placeable-neutral",
    "placeable-player",
    "player-creation",
  },
  selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
  working_sound = {
    sound = {
      filename = "__base__/sound/burner-mining-drill.ogg",
      volume = 0.8
    }
  },
}

if include_fluid_mixer then
  table.insert(research.effects,{type = "unlock-recipe",recipe = "fuelmixer-fluid"})
  data:extend{
    fluid_fluid_fuel_mix,
    item_fluid_fuel_mixer,
    recipe_fluid_mixer,
    recipe_fluid_mix,
    entity_fluid_mixer,
  }
  
end

--
--  RESEARCH
--

if separate_research then
  data:extend{
    research,
  }
else
  for k, v in pairs(research.effects) do
    table.insert(data.raw["technology"]["fluid-handling"].effects, v)
  end
end
