local M = {}
local util = require "util"

local CRASHSITE_ITEMS = settings.startup["rd-sem-crashsite-items"].value

function M.create_team(player, team_name)
    if player.force.name ~= "player" then
        player.print("You cannot create a team while on a team.")
        return true
    end
    if util.tableLength(game.forces) > 62 then
        util.announce("there can't be more than 30 players due to the factorio force amount limitation! "..player.name.." has to join a team")
        return false
    end
    util.announce((player.name).." just created "..team_name.."! expect some lag")
    remote.call("space-exploration", "setup_multiplayer_test", { force_name = team_name, players = {player}, match_nauvis_seed = false})
    local new_surface = player.surface
    if new_surface.name == "Nauvis" then
        util.admin_announce("unknown issue, aborting create_team")
        return false
    end
	local enemy_force = ('enemy='..(team_name))
	game.create_force(enemy_force)
	local force = game.forces[enemy_force]
	force.ai_controllable = true 
    local player_force_entry = {}
    player_force_entry.players = {player.name}
    player_force_entry.surface = new_surface.name
    player_force_entry.enemy = enemy_force
    player_force_entry.evo = {}
    for k, v in pairs(global.settings.evo) do
        player_force_entry.evo[k] = v
    end
    global.all_player_forces[player.force.name] = player_force_entry
    util.admin_announce("entry: "..game.table_to_json(player_force_entry))
    
    global.surface_enemy_force[new_surface.name] = enemy_force
    util.admin_announce("assigned "..global.surface_enemy_force[new_surface.name].." to "..new_surface.name)
    
    local change_forces = {
        "no_evolution",
        "low_evolution",
        "medium_evolution",
        "high_evolution",
        "max_evolution",
        "enemy",
    }
    for _,tmp_force in pairs(change_forces) do 
        for _,entity in pairs(new_surface.find_entities_filtered({force=tmp_force})) do
            entity.force = enemy_force
        end
    end

    player.force.chart(new_surface, {{x = -256, y = -256}, {x = 256, y = 256}})

    if CRASHSITE_ITEMS then
        if script.active_mods["Krastorio2"] then
            -- usually spawns placed
            player.insert{name="kr-crash-site-assembling-machine-1-repaired", count=2}
            player.insert{name="kr-crash-site-assembling-machine-2-repaired", count=2}
            player.insert{name="kr-crash-site-generator", count=1}
            player.insert{name="kr-crash-site-lab-repaired", count=1}
            -- from containers
            player.insert{name="kr-shelter", count=1}
            player.insert{name="medium-electric-pole", count=10}
            player.insert{name="iron-plate", count=100}
            player.insert{name="copper-cable", count=50}
            player.insert{name="iron-gear-wheel", count=50}
            player.insert{name="electronic-circuit", count=200}
            -- breaking down the rest of the debris
            player.insert{name="iron-plate", count=200}
            player.insert{name="copper-cable", count=200}
            player.insert{name="iron-gear-wheel", count=25}
            player.insert{name="kr-sentinel", count=4}
            -- top up spawning in inv
            player.insert{name="wood", count=99}
            player.insert{name="fuel", count=600}
            player.insert{name="se-medpack", count=5}
        else 
            player.insert{name="automation-science-pack", count=10}
            player.insert{name="iron-plate", count=100}
            player.insert{name="wood", count=10}
            player.insert{name="stone-furnace", count=1}
            player.insert{name="burner-mining-drill", count=1}
            player.insert{name="se-medpack", count=10}
        end
    end

    return true
end




return M