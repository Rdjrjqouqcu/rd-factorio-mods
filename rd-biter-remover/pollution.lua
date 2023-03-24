local tmp = {}

tmp.clear_pollution = function ()
    local names = {}
    for _, surface in pairs(game.surfaces) do
        if surface.get_total_pollution() > 0 then
            surface.clear_pollution()
            table.insert(names, surface.name)
        end
    end
    game.print({"info.rd-biter-pollution-cleared", table.concat(names, ", ")})
end

tmp.toggle_pollution = function (force, enabled)
    game.map_settings.pollution.enabled = enabled
    force.technologies["rd-biter-pollution-enable"].enabled = not enabled
    force.technologies["rd-biter-pollution-disable"].enabled = enabled
    if enabled then
        game.print({"info.rd-biter-pollution-enabled"})
    else
        game.print({"info.rd-biter-pollution-disabled"})
    end
end

return tmp

