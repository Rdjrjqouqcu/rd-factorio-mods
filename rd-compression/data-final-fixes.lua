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



-- nullius somehow removes the second decompression output stack
-- so we need to add it back in final-fixes
if mods["nullius"] then
    for _, recipe in pairs(data.raw.recipe) do
        if string.sub(recipe.name, 1, 14) == "rd-decompress-" then
            local item_name = recipe.results[1].name
            local item = data.raw["item"][item_name]
            local size = stack_setting(item.stack_size)
            recipe.results = {
                { type = "item", name = item_name, amount = math.ceil(size / 2) },
                { type = "item", name = item_name, amount = math.floor(size / 2) },
            }
        end
    end
end
