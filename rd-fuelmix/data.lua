

local recipe_category_fuel_processing = {
  type = "recipe-category",
  name = "fuel-processing"
}

-- data:extend()

--
--  SOLID MIXER
--

local include_solid_mixer = settings.startup["rd-fuelmix-solid-enable"].value

local item_solid_fuel_mix = {
  type = "item",
  name = "fuelmix-solid",
  icon = "__rd-fuelmix__/graphics/fuel-solid.png",
  icon_size = 512,
  icon_mipmaps = 1,
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
  enabled = false,
  energy_required = 4,
  ingredients = {
    {"iron-plate", 10},
    {"stone-brick", 10},
  },
  result = "fuelmixer-solid",
}

local recipe_solid_mix = {
  type = "recipe",
  name = "fuel-processing-solid",
  enabled = false,
  energy_required = 1,
  ingredients = {},
  category = "fuel-processing",
  result = "fuelmix-solid",
}

local entity_solid_mixer = {
  -- PrototypeBase
  name = "fuelmixer-solid",
  type = "assembling-machine",

  -- Prototype/AssemblingMachine
  fixed_recipe = "fuel-processing-solid",

  -- Prototype/CraftingMachine
  crafting_categories = { "fuel-processing" },
  crafting_speed = 1,
  energy_source = {
    type = "burner",
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
  energy_usage = settings.startup["rd-fuelmix-solid-fuelrequired"].value .. "MW",
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
  data:extend{
    item_solid_fuel_mix,
    item_solid_fuel_mixer,
    recipe_solid_mixer,
    recipe_solid_mix,
    entity_solid_mixer,
    recipe_category_fuel_processing
  }
end
