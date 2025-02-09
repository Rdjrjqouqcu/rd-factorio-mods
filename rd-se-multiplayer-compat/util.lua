local M = {}

M.ADMIN_DEBUG = settings.startup["rd-sem-admin-debug"].value

function M.enemy_from_player(player)
    if type(player) == "string" then
        player = game.player[player]
    end
    return game.forces["enemy="..player.forces]
end

function M.table_length(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

function M.announce(msg)
    game.print(msg)
end

function M.admin_announce(msg)
    for _, player in pairs(game.players) do
        if player.admin and M.ADMIN_DEBUG then
            player.print("[A]: "..msg)
        end
    end
end

function M.starts_with(base, search)
    return string.sub(base,1,string.len(search))==search
end

function M.get_remainder(base, search)
    return string.sub(base, 1 + string.len(search))
end

function M.formattime_hours_mins(ticks)
    local total_seconds = math.floor(ticks / 60)
    local seconds = total_seconds % 60
    local total_minutes = math.floor((total_seconds)/60)
    local minutes = total_minutes % 60
    local hours   = math.floor((total_minutes)/60)

    return string.format("%dh:%02dm:%02ds", hours, minutes, seconds)
end

function M.is_team_active(faction)
    if type(faction) == "string" then
        faction = game.forces[faction]
    end
    local active = false
    for _,player in pairs(global.all_player_forces[faction.name].players) do
        active = active or game.players[player].connected
    end
    return active
end

return M