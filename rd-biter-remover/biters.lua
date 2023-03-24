local tmp = {}

tmp.clear_biters = function (force)
    local hostile = {}
    for _, v in pairs(game.forces) do
        if force.is_enemy(v) then
            table.insert(hostile, v)
        end
    end

    local surfaces = {}
    for _, surface in pairs(game.surfaces) do
        local found = false
        for _, f in pairs(hostile) do
            for _, e in pairs(surface.find_entities_filtered({force = f})) do
                if e.prototype.type == "unit" and (string.find(e.name, "biter") or string.find(e.name, "spitter")) then
                   e.destroy()
                   if not found then
                        found = true
                        table.insert(surfaces, surface.name)
                   end
                elseif e.prototype.type == "unit-spawner" then
                    e.destroy()
                    if not found then
                         found = true
                         table.insert(surfaces, surface.name)
                    end
                elseif e.prototype.type == "turret" and string.find(e.name, "worm") then
                    e.destroy()
                    if not found then
                         found = true
                         table.insert(surfaces, surface.name)
                    end
                end
            end
        end
    end

    table.sort(surfaces)
    game.print({"info.rd-biter-biter-cleared", table.concat(surfaces, ", ")})
end

tmp.disable_biters = function (force)
    for _, surface in pairs(game.surfaces) do
        local mgs = surface.map_gen_settings
        if mgs.autoplace_controls and mgs.autoplace_controls["enemy-base"] then
            mgs.autoplace_controls["enemy-base"].size = 0
            surface.map_gen_settings = mgs
        end
    end
    
    force.technologies["rd-biter-biter-enable"].enabled = true
    force.technologies["rd-biter-biter-disable"].enabled = false

    game.print({"info.rd-biter-biter-disabled"})
end

tmp.enable_biters = function (force)
    for _, surface in pairs(game.surfaces) do
        local mgs = surface.map_gen_settings
        if mgs.autoplace_controls and mgs.autoplace_controls["enemy-base"] then
            if global.base_size[surface.name] ~= nil then
                mgs.autoplace_controls["enemy-base"].size = global.base_size[surface.name]
                surface.map_gen_settings = mgs
            else
                game.print("Failed to find default settings for surface "..surface.name)
            end
        end
    end

    force.technologies["rd-biter-biter-enable"].enabled = false
    force.technologies["rd-biter-biter-disable"].enabled = true

    game.print({"info.rd-biter-biter-enabled"})
end

return tmp

