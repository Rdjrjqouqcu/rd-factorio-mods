
--
-- PYANODONS COMPAT SPENT FUEL
--

if mods["pyrawores"] and not settings.startup["rd-fuelmix-research-pyanodons"].value then
  data.raw["item"]["fuelmix-solid"].burnt_result = ""
end


