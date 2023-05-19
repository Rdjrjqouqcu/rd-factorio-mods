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



