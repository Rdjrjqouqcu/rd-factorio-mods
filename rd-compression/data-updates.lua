
local function stack_setting(stack_size)
  local mode = settings.startup["rd-compression-mode"].value
  local value = settings.startup["rd-compression-mode-value"].value
  if mode == "value" then
    return math.floor(value)
  end
  if mode == "stack" then
    return stack_size
  end
  if mode == "stack/value" then
    return math.floor(stack_size / value)
  end
end

local shift = 6
local levels = settings.startup["rd-compression-levels"].value
local speed_growth = settings.startup["rd-compression-speed-multiplier"].value
local speed_base = settings.startup["rd-compression-speed-base"].value / speed_growth

-- For debugging
local hide_from_player = true

local function build_items(item_name)
  local item = data.raw["item"][item_name]
  if item == nil then
    error("Unable to load item '"..item_name.."'")
  end
  local results = {}
  for i = 1, levels do
    local icons = {{
      icon = "__rd-compression__/graphics/empty.png",
      icon_size = 32,
    }}
    local shift_amount = math.floor(-i / 2) * shift
    if i % 2 == 1 then
      shift_amount = shift_amount + shift / 2
    end
    if item.icon ~= nil then
      for ic = 0, i do
        table.insert(icons, {
          icon = item.icon,
          icon_size = item.icon_size,
          icon_mipmaps = item.icon_mipmaps,
          scale = 32 / item.icon_size * 0.75,
          shift = {shift_amount + ic * shift, 0},
        })
      end
    end
    if item.icons ~= nil then
      for ic = 0, i do
        for _, iconLayer in pairs(item.icons) do
          local scale = 32 / iconLayer.icon_size * 0.75
          if iconLayer.scale ~= nil then
            scale = iconLayer.scale * 0.75
          end
          local lshift = {shift_amount + ic * shift, 0}
          if iconLayer.shift ~= nil then
            lshift = {iconLayer.shift.x + shift_amount + ic * shift, iconLayer.shift.y}
          end
          table.insert(icons, {
            icon = iconLayer.icon,
            icon_size = iconLayer.icon_size,
            icon_mipmaps = iconLayer.icon_mipmaps,
            tint = iconLayer.tint,
            scale = scale,
            shift = lshift,
          })
        end
      end
    end
    -- Add compressed item
    local count = stack_setting(item.stack_size)
    table.insert(results, {
      type = "item",
      name = "rd-compressed-"..i.."-"..item_name,
      icons = icons,
      group = "rd-compressed",
      order = "z",
      stack_size = count,
      localised_name = {"meta.rd-compression", i, item.localised_name or {"item-name."..item_name}},
      localised_description = {"meta.rd-compression-desc", count^i, item.localised_name or {"item-name."..item_name}},
    })
    if i == 1 then
      -- Add recipes converting to source item
      table.insert(results, {
        type = "recipe",
        name = "rd-compress-"..i.."-"..item_name,
        enabled = true,
        hide_from_player_crafting = hide_from_player,
        energy_required = speed_base * (speed_growth^i),
        ingredients = {
          {type = "item", name = item_name, amount = count}
        },
        category = "rd-compression",
        results = {{type = "item", name = "rd-compressed-"..i.."-"..item_name, amount = 1}},
      })
      table.insert(results, {
        type = "recipe",
        name = "rd-decompress-"..i.."-"..item_name,
        main_product = item_name,
        enabled = true,
        hide_from_player_crafting = hide_from_player,
        energy_required = speed_base * (speed_growth^i),
        ingredients = {
          {type = "item", name = "rd-compressed-"..i.."-"..item_name, amount = 1}
        },
        category = "rd-decompression",
        results = {
          {type = "item", name = item_name, amount = math.ceil(count / 2)},
          {type = "item", name = item_name, amount = math.floor(count / 2)},
        },
      })
    else
      -- Add recipes converting between compression tiers
      table.insert(results, {
        type = "recipe",
        name = "rd-compress-"..i.."-"..item_name,
        enabled = true,
        hide_from_player_crafting = hide_from_player,
        energy_required = speed_base * (speed_growth^i),
        ingredients = {
          {type = "item", name = "rd-compressed-"..(i-1).."-"..item_name, amount = count}
        },
        category = "rd-compression",
        results = {{type = "item", name = "rd-compressed-"..i.."-"..item_name, amount = 1}},
      })
      table.insert(results, {
        type = "recipe",
        name = "rd-decompress-"..i.."-"..item_name,
        main_product = "rd-compressed-"..(i-1).."-"..item_name,
        enabled = true,
        hide_from_player_crafting = hide_from_player,
        energy_required = speed_base * (speed_growth^i),
        ingredients = {
          {type = "item", name = "rd-compressed-"..i.."-"..item_name, amount = 1}
        },
        category = "rd-decompression",
        results = {
          {type = "item", name = "rd-compressed-"..(i-1).."-"..item_name, amount = math.ceil(count / 2)},
          {type = "item", name = "rd-compressed-"..(i-1).."-"..item_name, amount = math.floor(count / 2)},
        },
      })
    end
  end
  return results
end

local items_string = settings.startup["rd-compression-items"].value

if items_string == "" then
  if mods["nullius"] then
    items_string = "iron-ore, nullius-bauxite, nullius-limestone, nullius-sandstone"
  else
    items_string = "coal, stone, iron-ore, copper-ore, uranium-ore"
  end
end

for item in string.gmatch(items_string, "([^,;]+)", 0) do
    if item ~= "" then
      item = string.match(item, "^%s*(.-)%s*$" )
      local items = build_items(item)
      if mods["nullius"] then
        for _, item in pairs(items) do
          if item.type == "recipe" then
            item.order = "nullius-include"
          end
        end
      end
      data:extend(items)
    end
end



