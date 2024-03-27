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
  prerequisites = { "optics" },
}

--
--  AREA LIGHT
--

local area_enabled = settings.startup["rd-antidark-arealight-enabled"].value
if mods["nullius"] then
  area_enabled = false
end

if area_enabled then
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
      { "small-lamp",         4 },
      { "electronic-circuit", 2 },
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
    picture_off = { filename = "__rd-antidark__/graphics/bulb-off.png", size = 512, scale = 32 / 512 },
    picture_on = { filename = "__rd-antidark__/graphics/bulb-on.png", size = 512, scale = 32 / 512 },

    -- Prototype/EntityWithOwner

    -- Prototype/EntityWithHealth
    max_health = 90,
    corpse = "small-remnants",

    -- Prototype/Entity
    icon = "__rd-antidark__/graphics/bulb-on.png",
    icon_size = 512,
    minable = { mining_time = 0.1, result = "ad-area-light" },
    placeable_by = { item = "ad-area-light", count = 1 },
    collision_box = { { -0.15, -0.15 }, { 0.15, 0.15 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
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

  table.insert(research.effects, { type = "unlock-recipe", recipe = "ad-area-light" })
  data:extend {
    item_area_light,
    recipe_area_light,
    entity_area_light,
  }
end

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
      { "small-lamp",         4 },
      { "electronic-circuit", 4 },
      { "solar-panel",        1 },
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
    picture_off = { filename = "__rd-antidark__/graphics/bulb-off.png", size = 512, scale = 32 / 512 },
    picture_on = { filename = "__rd-antidark__/graphics/bulb-on.png", size = 512, scale = 32 / 512 },

    -- Prototype/EntityWithOwner

    -- Prototype/EntityWithHealth
    max_health = 90,
    corpse = "small-remnants",

    -- Prototype/Entity
    icon = "__rd-antidark__/graphics/bulb-off.png",
    icon_size = 512,
    minable = { mining_time = 0.1, result = "ad-solar-light" },
    placeable_by = { item = "ad-solar-light", count = 1 },
    collision_box = { { -0.15, -0.15 }, { 0.15, 0.15 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    fast_replaceable_group = "lamp-small",
    flags = {
      "placeable-neutral",
      "placeable-player",
      "player-creation",
    },
  }

  if area_enabled then
    data.raw["lamp"]["ad-area-light"].next_upgrade = "ad-solar-light"
    recipe_solar_light = {
      type = "recipe",
      name = "ad-solar-light",
      enabled = false,
      ingredients = {
        { "ad-area-light",      1 },
        { "electronic-circuit", 2 },
        { "solar-panel",        1 },
      },
      result = "ad-solar-light",
    }
  end

  if mods["nullius"] then
    recipe_solar_light.order = "nullius-bda"
    recipe_solar_light.subgroup = "railway"
    recipe_solar_light.ingredients = {
      { "nullius-lamp-2",     1 },
      { "electronic-circuit", 2 },
      { "solar-panel",        1 },
    }
  end

  table.insert(research.effects, { type = "unlock-recipe", recipe = "ad-solar-light" })
  data:extend {
    item_solar_light,
    recipe_solar_light,
    entity_solar_light,
  }
end

--
--  CHUNK AREA LIGHT
--

local lights_per_chunk = 4

local energy_J_s = settings.startup["rd-antidark-phantom-drain"].value
local initial_energy_multiplier = settings.startup["rd-antidark-phantom-drain-mult"].value
local input_multiplier = settings.startup["rd-antidark-charge-mult"].value
local buffer_per_chunk = (lights_per_chunk + 1) * initial_energy_multiplier * energy_J_s
local input_per_chunk = (lights_per_chunk + 1) * energy_J_s * input_multiplier
local chunk_radius = settings.startup["rd-antidark-radarlight-chunkradius"].value
local buffer_per_radar = ((2 * chunk_radius + 1) ^ 2 * lights_per_chunk + 1) * initial_energy_multiplier * energy_J_s
local input_per_radar = ((2 * chunk_radius + 1) ^ 2 * lights_per_chunk + 1) * energy_J_s * input_multiplier

local chunk_enabled = settings.startup["rd-antidark-chunklight-enabled"].value

if chunk_enabled then
  local item_chunk_light = {
    type = "item",
    name = "ad-chunk-light",
    icon = "__rd-antidark__/graphics/bulb-blue.png",
    icon_size = 512,
    subgroup = "circuit-network",
    order = "a[light]-a[small-lamp]-c[ad-chunk-light]",
    place_result = "ad-chunk-light",
    stack_size = 50,
  }

  local recipe_chunk_light = {
    type = "recipe",
    name = "ad-chunk-light",
    enabled = false,
    ingredients = {
      { "small-lamp",         10 },
      { "electronic-circuit", 10 },
    },
    result = "ad-chunk-light",
  }

  local entity_chunk_light = {
    -- PrototypeBase
    name = "ad-chunk-light",
    type = "electric-energy-interface",

    -- Prototype/ElectricEnergyInterface
    energy_source = {
      type = "electric",
      buffer_capacity = buffer_per_chunk .. "J",
      usage_priority = "secondary-input",
      input_flow_limit = input_per_chunk .. "W"
    },
    energy_production = "0W",
    energy_usage = "0W",
    picture = { filename = "__rd-antidark__/graphics/bulb-blue.png", size = 512, scale = 64 / 512 },

    -- Prototype/EntityWithOwner

    -- Prototype/EntityWithHealth
    max_health = 90,
    corpse = "small-remnants",

    -- Prototype/Entity
    icon = "__rd-antidark__/graphics/bulb-blue.png",
    icon_size = 512,
    minable = { mining_time = 0.1, result = "ad-chunk-light" },
    placeable_by = { item = "ad-chunk-light", count = 1 },
    collision_box = { { -0.95, -0.95 }, { 0.95, 0.95 } },
    selection_box = { { -1, -1 }, { 1, 1 } },
    flags = {
      "placeable-neutral",
      "placeable-player",
      "player-creation",
    },
  }

  if mods["nullius"] then
    recipe_chunk_light.order = "nullius-bdb"
    recipe_chunk_light.subgroup = "railway"
    recipe_chunk_light.ingredients = {
      { "nullius-lamp-2",     4 },
      { "electronic-circuit", 10 },
    }
  end

  table.insert(research.effects, { type = "unlock-recipe", recipe = "ad-chunk-light" })
  data:extend {
    item_chunk_light,
    recipe_chunk_light,
    entity_chunk_light,
  }
end

--
--  RADAR AREA LIGHT
--

local radar_enabled = settings.startup["rd-antidark-radarlight-enabled"].value

if radar_enabled then
  local item_radar_light = {
    type = "item",
    name = "ad-radar-light",
    icons = {
      {
        icon = "__rd-antidark__/graphics/bulb-blue.png",
        icon_size = 512,
      },
      {
        icon = "__base__/graphics/icons/radar.png",
        icon_size = 64,
        icon_mipmaps = 4,
        scale = 0.4,
        shift = { x = -5, y = -5 }
      },
    },
    subgroup = "circuit-network",
    order = "a[light]-a[small-lamp]-d[ad-radar-light]",
    place_result = "ad-radar-light",
    stack_size = 50,
  }

  local recipe_radar_light = {
    type = "recipe",
    name = "ad-radar-light",
    enabled = false,
    ingredients = {
      { "small-lamp",         100 },
      { "electronic-circuit", 100 },
      { "radar",              2 },
    },
    result = "ad-radar-light",
  }

  if chunk_enabled then
    recipe_radar_light = {
      type = "recipe",
      name = "ad-radar-light",
      enabled = false,
      ingredients = {
        { "ad-chunk-light",     10 },
        { "electronic-circuit", 10 },
        { "radar",              2 },
      },
      result = "ad-radar-light",
    }
  end

  local entity_radar_light = {
    -- PrototypeBase
    name = "ad-radar-light",
    type = "electric-energy-interface",

    -- Prototype/ElectricEnergyInterface
    energy_source = {
      type = "electric",
      buffer_capacity = buffer_per_radar .. "J",
      usage_priority = "secondary-input",
      input_flow_limit = input_per_radar .. "W"
    },
    energy_production = "0W",
    energy_usage = "0W",
    picture = { filename = "__rd-antidark__/graphics/bulb-blue.png", size = 512, scale = (32 * 3) / 512 },

    -- Prototype/EntityWithOwner

    -- Prototype/EntityWithHealth
    max_health = 90,
    corpse = "small-remnants",

    -- Prototype/Entity
    icons = {
      {
        icon = "__rd-antidark__/graphics/bulb-blue.png",
        icon_size = 512,
      },
      {
        icon = "__base__/graphics/icons/radar.png",
        icon_size = 64,
        icon_mipmaps = 4,
        scale = 0.4,
        shift = { x = -5, y = -5 }
      },
    },
    minable = { mining_time = 0.1, result = "ad-radar-light" },
    placeable_by = { item = "ad-radar-light", count = 1 },
    collision_box = { { -1.45, -1.45 }, { 1.45, 1.45 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    flags = {
      "placeable-neutral",
      "placeable-player",
      "player-creation",
    },
  }

  if mods["nullius"] then
    recipe_radar_light.order = "nullius-bdc"
    recipe_radar_light.subgroup = "railway"
  end

  table.insert(research.effects, { type = "unlock-recipe", recipe = "ad-radar-light" })
  data:extend {
    item_radar_light,
    recipe_radar_light,
    entity_radar_light,
  }
end

--
-- REGISTER
--

if mods["nullius"] then
  research.order = "nullius-" .. research.name
  research.prerequisites = {"nullius-illumination-2"}
  research.unit = data.raw["technology"]["nullius-illumination-2"].unit
end

if separate_research then
  data:extend {
    research,
  }
else
  local base_tech = "optics"
  if mods["nullius"] then
    base_tech = "nullius-illumination-2"
  end
  for _, v in pairs(research.effects) do
    table.insert(data.raw["technology"][base_tech].effects, v)
  end
end
