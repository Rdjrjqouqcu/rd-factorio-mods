

local separate_research = settings.startup["rd-antidark-separate-research"].value

local research = {
  -- PrototypeBase
  type = "technology",
  name = "ad-anti-dark",
  
  -- Prototype/Technology
  icon = "__rd-antidark__/graphics/bulb-on.png",
  icon_size = 512,
  unit = data.raw["technology"]["optics"]["unit"],
  effects = {},
  prerequisites = {"optics"},
}

--
--  AREA LIGHT
--

local item_area_light = {
  type = "item",
  name = "ad-area-light",
  icon = "__rd-antidark__/graphics/bulb-on.png",
  icon_size = 512,
  subgroup = "circuit-network",
  order = "a[light]-a[small-lamp]-a[ad-area-light]",
  place_result = "ad-area-light",
  stack_size = 50,
}

local recipe_area_light = {
  type = "recipe",
  name = "ad-area-light",
  enabled = false,
  ingredients = {
    {"small-lamp", 10},
    {"electronic-circuit", 2},
    {"iron-stick", 4},
    {"iron-plate", 2}
  },
  result = "ad-area-light",
}

local entity_area_light = {
  -- PrototypeBase
  name = "ad-area-light",
  type = "lamp",

  -- Prototype/Lamp
  energy_source = {
    type = "electric",
    usage_priority = "lamp",
  },
  energy_usage_per_tick = "25kW",
  light = {
    intensity = 0.95,
    size = settings.startup["rd-antidark-arealight-radius"].value,
  },
  picture_off = { filename = "__rd-antidark__/graphics/bulb-off.png", size =  512, scale = 32 / 512 },
  picture_on = { filename = "__rd-antidark__/graphics/bulb-on.png", size =  512, scale = 32 / 512 },

  -- Prototype/EntityWithOwner

  -- Prototype/EntityWithHealth
  max_health = 90,
  corpse = "small-remnants",

  -- Prototype/Entity
  icon = "__rd-antidark__/graphics/bulb-on.png",
  icon_size = 512,
  minable = { mining_time = 0.1, result = "ad-area-light" },
  placeable_by = {item = "ad-area-light", count = 1},
  collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  fast_replaceable_group = "lamp-small",
  flags = {
    "placeable-neutral",
    "placeable-player",
    "player-creation",
  },
}

if not settings.startup["rd-antidark-arealight-usepower"].value then
  entity_area_light.energy_source = { type = "void" }
end

data.raw["lamp"]["small-lamp"].next_upgrade = "ad-area-light"
data.raw["lamp"]["small-lamp"].fast_replaceable_group = "lamp-small"

table.insert(research.effects,{type = "unlock-recipe",recipe = "ad-area-light"})
data:extend{
  item_area_light,
  recipe_area_light,
  entity_area_light,
}

--
--  SOLAR AREA LIGHT
--

local solar_enabled = settings.startup["rd-antidark-solarlight-enabled"].value

if solar_enabled then

   local item_solar_light = {
    type = "item",
    name = "ad-solar-light",
    icon = "__rd-antidark__/graphics/bulb-off.png",
    icon_size = 512,
    subgroup = "circuit-network",
    order = "a[light]-a[small-lamp]-b[ad-solar-light]",
    place_result = "ad-solar-light",
    stack_size = 50,
  }

  local recipe_solar_light = {
    type = "recipe",
    name = "ad-solar-light",
    enabled = false,
    ingredients = {
      {"ad-area-light", 1},
      {"electronic-circuit", 1},
      {"solar-panel", 1},
    },
    result = "ad-solar-light",
  }

  local entity_solar_light = {
    -- PrototypeBase
    name = "ad-solar-light",
    type = "lamp",

    -- Prototype/Lamp
    energy_source = { type = "void" },
    energy_usage_per_tick = "1W",
    light = {
      intensity = 0.95,
      size = settings.startup["rd-antidark-arealight-radius"].value,
    },
    picture_off = { filename = "__rd-antidark__/graphics/bulb-off.png", size =  512, scale = 32 / 512 },
    picture_on = { filename = "__rd-antidark__/graphics/bulb-on.png", size =  512, scale = 32 / 512 },

    -- Prototype/EntityWithOwner

    -- Prototype/EntityWithHealth
    max_health = 90,
    corpse = "small-remnants",

    -- Prototype/Entity
    icon = "__rd-antidark__/graphics/bulb-off.png",
    icon_size = 512,
    minable = { mining_time = 0.1, result = "ad-solar-light" },
    placeable_by = {item = "ad-solar-light", count = 1},
    collision_box = {{-0.15, -0.15}, {0.15, 0.15}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    fast_replaceable_group = "lamp-small",
    flags = {
      "placeable-neutral",
      "placeable-player",
      "player-creation",
    },
  }

  item_area_light.next_upgrade = "ad-solar-light"

  table.insert(research.effects,{type = "unlock-recipe",recipe = "ad-solar-light"})
  data:extend{
    item_solar_light,
    recipe_solar_light,
    entity_solar_light,
  }

end

--
--  CHUNK AREA LIGHT
--

local chunk_enabled = settings.startup["rd-antidark-chunklight-enabled"].value

if chunk_enabled then

   local item_chunk_light = {
    type = "item",
    name = "ad-chunk-light",
    icon = "__rd-antidark__/graphics/bulb-blue.png",
    icon_size = 512,
    subgroup = "circuit-network",
    order = "a[light]-a[small-lamp]-b[ad-chunk-light]",
    place_result = "ad-chunk-light",
    stack_size = 50,
  }

  local recipe_chunk_light = {
    type = "recipe",
    name = "ad-chunk-light",
    enabled = false,
    ingredients = {
      {"ad-area-light", 1},
      {"electronic-circuit", 10},
    },
    result = "ad-chunk-light",
  }

  local entity_chunk_light = {
    -- PrototypeBase
    name = "ad-chunk-light",
    type = "electric-energy-interface",

    -- Prototype/ElectricEnergyInterface
    energy_source	= {
      type = "electric",
      buffer_capacity = "100J",
      usage_priority = "secondary-input"
    },
    energy_production = "0W",
    energy_usage = "0W",
    picture = { filename = "__rd-antidark__/graphics/bulb-blue.png", size =  512, scale = 64 / 512 },

    -- Prototype/EntityWithOwner

    -- Prototype/EntityWithHealth
    max_health = 90,
    corpse = "small-remnants",

    -- Prototype/Entity
    icon = "__rd-antidark__/graphics/bulb-off.png",
    icon_size = 512,
    minable = { mining_time = 0.1, result = "ad-chunk-light" },
    placeable_by = {item = "ad-solar-light", count = 1},
    collision_box = {{-0.95, -0.95}, {0.95, 0.95}},
    selection_box = {{-1, -1}, {1, 1}},
    fast_replaceable_group = "lamp-small",
    flags = {
      "placeable-neutral",
      "placeable-player",
      "player-creation",
    },
  }

  table.insert(research.effects,{type = "unlock-recipe",recipe = "ad-chunk-light"})
  data:extend{
    item_chunk_light,
    recipe_chunk_light,
    entity_chunk_light,
  }

end

--
-- REGISTER
--

if separate_research then
  data:extend{
    research,
  }
else
  for k, v in pairs(research.effects) do
    table.insert(data.raw["technology"]["optics"].effects, v)
  end
end
