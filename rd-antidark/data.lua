local light_pick_sound = {
  filename = "__base__/sound/item/electric-small-inventory-pickup.ogg",
  volume = 0.7,
  aggregation = { max_count = 1, remove = true },
}
local light_drop_sound = {
  filename = "__base__/sound/item/electric-small-inventory-move.ogg",
  volume = 1.0,
  aggregation = { max_count = 1, remove = true },
}
local heavy_pick_sound = {
  filename = "__base__/sound/item/metal-large-inventory-pickup.ogg",
  volume = 0.8,
  aggregation = { max_count = 1, remove = true },
}
local heavy_drop_sound = {
  filename = "__base__/sound/item/metal-large-inventory-move.ogg",
  volume = 0.7,
  aggregation = { max_count = 1, remove = true },
}

local separate_research = settings.startup["rd-antidark-separate-research"].value

local research = {
  -- PrototypeBase
  type = "technology",
  name = "ad-anti-dark",

  -- Prototype/Technology
  icon = "__rd-antidark__/graphics/bulb-on.png",
  icon_size = 512,
  unit = data.raw["technology"]["lamp"]["unit"],
  effects = {},
  prerequisites = { "lamp" },
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
    pick_sound = light_pick_sound,
    drop_sound = light_drop_sound,
    weight = 20000,
  }

  local recipe_area_light = {
    type = "recipe",
    name = "ad-area-light",
    enabled = false,
    ingredients = {
      { type = "item", name = "small-lamp",         amount = 4 },
      { type = "item", name = "electronic-circuit", amount = 2 },
    },
    results = { { type = "item", name = "ad-area-light", amount = 1 } },
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

  if mods["pyhightech"] then
    recipe_area_light.ingredients = {
      { type = "item", name = "small-lamp",   amount = 4 },
      { type = "item", name = "copper-cable", amount = 6 },
      { type = "item", name = "iron-plate",   amount = 2 },
      { type = "item", name = "copper-plate", amount = 2 },
    }
  end

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
    pick_sound = light_pick_sound,
    drop_sound = light_drop_sound,
    weight = 20000,
  }

  local recipe_solar_light = {
    type = "recipe",
    name = "ad-solar-light",
    enabled = false,
    ingredients = {
      { type = "item", name = "small-lamp",         amount = 4 },
      { type = "item", name = "electronic-circuit", amount = 4 },
      { type = "item", name = "solar-panel",        amount = 1 },
    },
    results = { { type = "item", name = "ad-solar-light", amount = 1 } },
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
        { type = "item", name = "ad-area-light",      amount = 1 },
        { type = "item", name = "electronic-circuit", amount = 2 },
        { type = "item", name = "solar-panel",        amount = 1 },
      },
      results = { { type = "item", name = "ad-solar-light", amount = 1 } },
    }
  end

  if mods["nullius"] then
    recipe_solar_light.order = "nullius-bda"
    recipe_solar_light.subgroup = "railway"
    recipe_solar_light.ingredients = {
      { type = "item", name = "nullius-lamp-2",     amount = 1 },
      { type = "item", name = "electronic-circuit", amount = 2 },
      { type = "item", name = "solar-panel",        amount = 1 },
    }
  end

  if mods["pyhightech"] then
    if area_enabled then
      recipe_solar_light.ingredients = {
        { type = "item", name = "ad-area-light", amount = 1 },
        { type = "item", name = "copper-cable",  amount = 6 },
        { type = "item", name = "iron-plate",    amount = 2 },
        { type = "item", name = "copper-plate",  amount = 2 },
        { type = "item", name = "solar-panel",   amount = 1 },
      }
    else
      recipe_solar_light.ingredients = {
        { type = "item", name = "small-lamp",   amount = 4 },
        { type = "item", name = "copper-cable", amount = 12 },
        { type = "item", name = "iron-plate",   amount = 4 },
        { type = "item", name = "copper-plate", amount = 4 },
        { type = "item", name = "solar-panel",  amount = 1 },
      }
    end
  end

  if mods["pyalternativeenergy"] then
    for k, v in pairs(recipe_solar_light.ingredients) do
      if v.name == "solar-panel" then
        recipe_solar_light.ingredients[k].name = "multiblade-turbine-mk01"
      end
    end
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
    pick_sound = heavy_pick_sound,
    drop_sound = heavy_drop_sound,
    weight = 20000,
  }

  local recipe_chunk_light = {
    type = "recipe",
    name = "ad-chunk-light",
    enabled = false,
    ingredients = {
      { type = "item", name = "small-lamp",         amount = 10 },
      { type = "item", name = "electronic-circuit", amount = 10 },
    },
    results = { { type = "item", name = "ad-chunk-light", amount = 1 } },
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
      { type = "item", name = "nullius-lamp-2",     amount = 4 },
      { type = "item", name = "electronic-circuit", amount = 10 },
    }
  end

  if mods["pyhightech"] then
    recipe_chunk_light.ingredients = {
      { type = "item", name = "small-lamp",   amount = 10 },
      { type = "item", name = "copper-cable", amount = 30 },
      { type = "item", name = "iron-plate",   amount = 10 },
      { type = "item", name = "copper-plate", amount = 10 },
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
        shift = { -5, -5 }
      },
    },
    subgroup = "circuit-network",
    order = "a[light]-a[small-lamp]-d[ad-radar-light]",
    place_result = "ad-radar-light",
    stack_size = 50,
    pick_sound = heavy_pick_sound,
    drop_sound = heavy_drop_sound,
    weight = 20000,
  }

  local recipe_radar_light = {
    type = "recipe",
    name = "ad-radar-light",
    enabled = false,
    ingredients = {
      { type = "item", name = "small-lamp",         amount = 100 },
      { type = "item", name = "electronic-circuit", amount = 100 },
      { type = "item", name = "radar",              amount = 2 },
    },
    results = { { type = "item", name = "ad-radar-light", amount = 1 } },
  }

  if chunk_enabled then
    recipe_radar_light = {
      type = "recipe",
      name = "ad-radar-light",
      enabled = false,
      ingredients = {
        { type = "item", name = "ad-chunk-light",     amount = 10 },
        { type = "item", name = "electronic-circuit", amount = 10 },
        { type = "item", name = "radar",              amount = 2 },
      },
      results = { { type = "item", name = "ad-radar-light", amount = 1 } },
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
        shift = { -5, -5 }
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

  if mods["pyhightech"] then
    if area_enabled then
      recipe_radar_light.ingredients = {
        { type = "item", name = "ad-chunk-light", amount = 10 },
        { type = "item", name = "copper-cable",   amount = 30 },
        { type = "item", name = "iron-plate",     amount = 10 },
        { type = "item", name = "copper-plate",   amount = 10 },
        { type = "item", name = "radar",          amount = 2 },
      }
    else
      recipe_radar_light.ingredients = {
        { type = "item", name = "small-lamp",   amount = 100 },
        { type = "item", name = "copper-cable", amount = 300 },
        { type = "item", name = "iron-plate",   amount = 100 },
        { type = "item", name = "copper-plate", amount = 100 },
        { type = "item", name = "radar",        amount = 2 },
      }
    end
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
  research.prerequisites = { "nullius-illumination-2" }
  research.unit = data.raw["technology"]["nullius-illumination-2"].unit
end

if separate_research then
  data:extend {
    research,
  }
else
  local base_tech = "lamp"
  if mods["nullius"] then
    base_tech = "nullius-illumination-2"
  end
  for _, v in pairs(research.effects) do
    table.insert(data.raw["technology"][base_tech].effects, v)
  end
end
