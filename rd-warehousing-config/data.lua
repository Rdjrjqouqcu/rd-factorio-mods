local function table_remove(tbl, val)
  for i=#tbl,1,-1 do
    if tbl[i] == val then
        table.remove(tbl, i)
    end
  end
end

--
--  SLOT COUNT MODIFICATIONS
--

if settings.startup["rd-warehousing-override-slots"].value then
  local warehouse_slots = settings.startup["rd-warehousing-count-warehouse-slots"].value
  local storage_warehouse_slots = settings.startup["rd-warehousing-count-storage-warehouse-slots"].value

  local storehouse_slots = settings.startup["rd-warehousing-count-storehouse-slots"].value
  local storage_storehouse_slots = settings.startup["rd-warehousing-count-storage-storehouse-slots"].value

  data.raw["container"]["warehouse-basic"].inventory_size = warehouse_slots
  data.raw["container"]["storehouse-basic"].inventory_size = storehouse_slots

  for i, val in pairs({
    "-active-provider",
    "-passive-provider",
    "-buffer",
    "-requester",
  }) do
    data.raw["logistic-container"]["warehouse"..val].inventory_size = warehouse_slots
    data.raw["logistic-container"]["storehouse"..val].inventory_size = storehouse_slots
  end

  data.raw["logistic-container"]["warehouse-storage"].inventory_size = storage_warehouse_slots
  data.raw["logistic-container"]["storehouse-storage"].inventory_size = storage_storehouse_slots

  data.raw["linked-container"]["linked-warehouse"].inventory_size = warehouse_slots
  data.raw["linked-container"]["linked-storehouse"].inventory_size = storehouse_slots
end

--
-- PYANODONS COMPAT
--
if mods["pyindustry"] and settings.startup["rd-warehousing-compat-pyanodons"].value then

  local warehouse = data.raw["technology"]["warehouse-research"]
  local pywarehouse = data.raw["technology"]["py-warehouse-research"]

  table_remove(warehouse["prerequisites"], "steel-processing")
  for _, v in pairs(pywarehouse["prerequisites"]) do
    table.insert(warehouse["prerequisites"], v)
  end

  local warehousel1 = data.raw["technology"]["warehouse-logistics-research-1"]
  local warehousel2 = data.raw["technology"]["warehouse-logistics-research-2"]
  local pywarehousel = data.raw["technology"]["py-warehouse-logistics-research"]

  table_remove(warehousel1["prerequisites"], "robotics")
  table_remove(warehousel2["prerequisites"], "logistic-system")
  for _, v in pairs(pywarehousel["prerequisites"]) do
    table.insert(warehousel1["prerequisites"], v)
    table.insert(warehousel2["prerequisites"], v)
  end
  table_remove(warehousel1["prerequisites"], "py-warehouse-research")
  table_remove(warehousel2["prerequisites"], "py-warehouse-research")

end


