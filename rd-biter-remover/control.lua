local pollution = require("pollution")
local biters = require("biters")


script.on_init(
    function()
        global.base_size = {}
        for _, surface in pairs(game.surfaces) do
            local mgs = surface.map_gen_settings
            if mgs.autoplace_controls and mgs.autoplace_controls["enemy-base"] then
                global.base_size[surface.name] = mgs.autoplace_controls["enemy-base"].size
            end
        end
        game.forces["player"].technologies["rd-biter-biter-enable"].enabled = false
        local currently_enabled = game.map_settings.pollution.enabled
        game.forces["player"].technologies["rd-biter-pollution-enable"].enabled = not currently_enabled
        game.forces["player"].technologies["rd-biter-pollution-disable"].enabled = currently_enabled
    end
)

script.on_event(
    defines.events.on_research_finished,
    function(event)
        if event.research.name == "rd-biter-biter-disable" then
            biters.disable_biters(event.research.force)
            if settings.startup["rd-biter-combine-research"].value then
                biters.clear_biters(event.research.force)
            end
        elseif event.research.name == "rd-biter-pollution-disable" then
            pollution.toggle_pollution(event.research.force, false)
            if settings.startup["rd-biter-combine-research"].value then
                pollution.clear_pollution()
            end
        elseif event.research.name == "rd-biter-biter-enable" then
            biters.enable_biters(event.research.force)
        elseif event.research.name == "rd-biter-pollution-enable" then
            pollution.toggle_pollution(event.research.force, true)
        elseif event.research.name == "rd-biter-biter-clear" then
            biters.clear_biters(event.research.force)
        elseif event.research.name == "rd-biter-pollution-clear" then
            pollution.clear_pollution()
        end
    end
)

