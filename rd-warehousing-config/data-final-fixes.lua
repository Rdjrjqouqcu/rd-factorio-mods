
--
-- PYANODONS COMPAT UNIT
--

if mods["pyindustry"] and settings.startup["rd-warehousing-compat-pyanodons"].value then

  local warehouse = data.raw["technology"]["warehouse-research"]
  local pywarehouse = data.raw["technology"]["py-warehouse-research"]

  warehouse["unit"] = table.deepcopy(pywarehouse["unit"])
  table_remove(warehouse["prerequisites"], "steel-processing")
  for _, v in pairs(pywarehouse["prerequisites"]) do
    table.insert(warehouse["prerequisites"], v)
  end

  local warehousel1 = data.raw["technology"]["warehouse-logistics-research-1"]
  local warehousel2 = data.raw["technology"]["warehouse-logistics-research-2"]
  local pywarehousel = data.raw["technology"]["py-warehouse-logistics-research"]

  warehousel1["unit"] = table.deepcopy(pywarehousel["unit"])
  warehousel1["unit"].count = math.floor(warehousel1["unit"].count * 2 / 3)
  warehousel2["unit"] = table.deepcopy(pywarehousel["unit"])
  warehousel2["unit"].count = math.floor(warehousel2["unit"].count * 4 / 3)
  table_remove(warehousel1["prerequisites"], "robotics")
  table_remove(warehousel2["prerequisites"], "logistic-system")
  for _, v in pairs(pywarehousel["prerequisites"]) do
    table.insert(warehousel1["prerequisites"], v)
    table.insert(warehousel2["prerequisites"], v)
  end
  table_remove(warehousel1["prerequisites"], "py-warehouse-research")
  table_remove(warehousel2["prerequisites"], "py-warehouse-research")

end


