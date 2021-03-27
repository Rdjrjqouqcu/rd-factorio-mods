local LOBBY_RADIUS = 42
local LOBBY_WATER_GAP = 10
local LOBBY_LOCATION = {x=0,y=0}
local LOBBY_AREA = {
    left_top = { x = LOBBY_LOCATION["x"] - LOBBY_RADIUS, y = LOBBY_LOCATION["y"] - LOBBY_RADIUS},
    right_bottom = { x = LOBBY_LOCATION["x"] + LOBBY_RADIUS, y = LOBBY_LOCATION["y"] + LOBBY_RADIUS},
}

local ADMIN_DEBUG = settings.startup["rd-sem-admin-debug"].value
local REQUIRE_PERMS = settings.startup["rd-sem-require-perms"].value
local CRASHSITE_ITEMS = settings.startup["rd-sem-crashsite-items"].value
local WORM_KILL_RATE = settings.startup["rd-sem-worm-kill"].value


local function starts_with(base, search)
    return string.sub(base,1,string.len(search))==search
end

local function get_remainder(base, search)
    return string.sub(base, 1 + string.len(search))
end

local function announce(msg)
    game.print(msg)
end

local function admin_announce(msg)
    for _, player in pairs(game.players) do
        if player.admin and ADMIN_DEBUG then
            player.print("[A]: "..msg)
        end
    end
end

local function isFactionActive(faction)
    if type(faction) == "string" then
        faction = game.forces[faction]
    end
    local active = false
    for _,player in pairs(global.all_player_forces[faction.name].players) do
        active = active or game.players[player].connected
    end
    -- return global.debug
    return active
end

local function tableLength(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

local function generate_lobby()
    if global.lobby_generated then
        return
    end
    admin_announce("generating lobby")
    global.lobby_generated = true
    game.map_settings.enemy_evolution.enabled = false

    local surface = game.surfaces['nauvis']
    surface.always_day=true
    surface.destroy_decoratives(LOBBY_AREA)
    for _,entity in pairs(surface.find_entities_filtered({force='enemy'})) do
        entity.destroy()
    end

    game.forces['player'].set_spawn_position(LOBBY_LOCATION, surface)

    -- create planet enemy forces

	game.create_force("no_evolution")
	local force = game.forces["no_evolution"]
    force.ai_controllable = true 
    force.evolution_factor = 0

	game.create_force("low_evolution")
	local force = game.forces["low_evolution"]
    force.ai_controllable = true 
    force.evolution_factor = 0.25

	game.create_force("medium_evolution")
	local force = game.forces["medium_evolution"]
    force.ai_controllable = true 
    force.evolution_factor = 0.5

	game.create_force("high_evolution")
	local force = game.forces["high_evolution"]
    force.ai_controllable = true 
    force.evolution_factor = 0.75

	game.create_force("max_evolution")
	local force = game.forces["max_evolution"]
	force.ai_controllable = true 
    force.evolution_factor = 1.0

	local force = game.forces["enemy"]
    force.evolution_factor = 1.0

    -- Build starting circle
    local start_tiles = {}
    for i=LOBBY_AREA.left_top.x,LOBBY_AREA.right_bottom.x,1 do
        for j=LOBBY_AREA.left_top.y,LOBBY_AREA.right_bottom.y,1 do

            local dist_origin = (LOBBY_LOCATION.x - i) ^ 2 + (LOBBY_LOCATION.y - j) ^ 2

            if (dist_origin <= (LOBBY_RADIUS - LOBBY_WATER_GAP) ^ 2) then
                table.insert(start_tiles, {name = 'tutorial-grid', position ={i,j}})
            end
            if ((LOBBY_RADIUS - LOBBY_WATER_GAP) ^ 2 < dist_origin and dist_origin  < LOBBY_RADIUS ^ 2) then
                table.insert(start_tiles, {name = 'out-of-map', position ={i,j}})
            end
        end
    end
    surface.set_tiles(start_tiles)

    -- clean starting circle
    for key, entity in pairs(surface.find_entities_filtered({area=LOBBY_AREA})) do
        if entity.valid and entity and entity.position then
            if ((LOBBY_LOCATION.x - entity.position.x)^2 + (LOBBY_LOCATION.y - entity.position.y)^2 < LOBBY_RADIUS^2) then
                if entity.type == "character" then
                    -- skip characters
                else
                    entity.destroy()
                end
            end
        end
    end
    admin_announce("lobby generated")
end

local function formattime_hours_mins(ticks)
    local total_seconds = math.floor(ticks / 60)
    local seconds = total_seconds % 60
    local total_minutes = math.floor((total_seconds)/60)
    local minutes = total_minutes % 60
    local hours   = math.floor((total_minutes)/60)

    return string.format("%dh:%02dm:%02ds", hours, minutes, seconds)
end

local function showSpawnGui(player)
	if(player.gui.screen.spawn_gui ~= nil) then
		player.gui.screen.spawn_gui.destroy()
	end
	local widget = player.gui.screen.add({type="frame",direction="vertical",name="spawn_gui", caption="Welcome"})
	widget.add({type="label",caption="You can spawn alone"})
	widget.add({type="button",name="spawn_alone",caption="Create a new spawn"})
	widget.add({type="label",caption=" "})
	local widgetInner = widget.add({type="frame",direction="horizontal"})
	widgetInner.add({type="label",caption="or ask someone to join their Factory"})
	widgetInner.add({type="label",caption=" "})
	for _,p in pairs(game.connected_players) do
		if(p.force.name ~= 'player') then
			widgetInner.add({type="button",name=("join="..(p.name)),caption=("team up with "..(p.name))})
		end
	end
    widget.force_auto_center()
end

local function createContainer(player)
	if(player.gui.top.rd_container == nil) then
		local container = player.gui.top.add{name="rd_container",type="frame", direction="vertical"}
        container.style["top_margin"]=10
        container.style["padding"]=2

		local button_menu = container.add{name="button_menu",type="flow",direction="horizontal"}
        button_menu.style["padding"]=0
        button_menu.style["vertical_align"]="center"

        local forces_list = button_menu.add{name="toggle_forces",type="button", caption="Forces"}
        forces_list.style["padding"]=0
        
        local start_gui = button_menu.add{name="toggle_spawn_gui",type="button", caption="Start"}
        start_gui.style["padding"]=0
        
        if not player.force.name == "player" then
            player.gui.top.rd_container.button_menu.toggle_spawn_gui.visible = false
        end

        if ADMIN_DEBUG and player.admin then
            local debug = button_menu.add{name="debug",type="button", caption="Debug"}
            debug.style["padding"]=0
        end
	end
end

local function on_create_player(event)
    generate_lobby()
    local player = game.players[event.player_index]
    global.death_counter[player.name] = 0
	player.teleport(LOBBY_LOCATION, game.surfaces['nauvis'])
    announce((player.name).." just spawned!")
    createContainer(player)
end

local function on_chunk_gen(e)
    local surface = e.surface
    if surface.name == "nauvis" then
        for _,entity in pairs(surface.find_entities_filtered({force='enemy',area=e.area})) do
            entity.destroy()
        end
        return
    elseif global.surface_enemy_force[surface.name] == nil then
        local forces = {
            "no_evolution",
            "low_evolution",
            "medium_evolution",
            "high_evolution",
            "max_evolution",
        }
        global.surface_enemy_force[surface.name] = forces[math.floor(math.random() * 5) + 1]
        admin_announce("assigned "..global.surface_enemy_force[surface.name].." to "..surface.name)
    end
    for _,entity in pairs(surface.find_entities_filtered({force='enemy',area=e.area})) do
        entity.force = global.surface_enemy_force[surface.name]
    end
end

local function askToJoin(player, playerAsking)
	local widget = player.gui.screen.add({type="frame",direction="vertical",name="askToJoin", caption="Join Request"})
	widget.add({type="label",caption=((playerAsking.name.." wants to join you"))})
	local widgetInner = widget.add({type="frame",direction="horizontal"})
	widgetInner.add({type="button",caption="accept",name=("acceptJoinRequest="..(playerAsking.name))})
	widgetInner.add({type="button",caption="refuse",name=("refuseJoinRequest="..(playerAsking.name))})
end

local function addPlayerToEmpire(player, playerForce)
    player.gui.top.rd_container.button_menu.toggle_spawn_gui.visible = false
    announce(player.name.." joined team "..playerForce.name)
    player.force = playerForce
    local force_info = global.all_player_forces[playerForce.name]
    table.insert(force_info.players, player.name)
    player.teleport(player.force.get_spawn_position(force_info.surface), force_info.surface)
end

local function createPlayerEmpire(player)
    if player.force.name ~= "player" then
        admin_announce("empire already created")
        return true
    end
    if tableLength(game.forces) > 62 then
        announce("there can't be more than 30 players due to the factorio force amount limitation! "..player.name.." has to join a team")
        return false
    end
    announce((player.name).." just created a new Empire! expect some lag")
    remote.call("space-exploration", "setup_multiplayer_test", { force_name = player.name, players = {player}, match_nauvis_seed = false})
    local new_surface = player.surface
    if new_surface.name == "Nauvis" then
        admin_announce("unknown issue, aborting")
        return false
    end
	local enemy_force = ('enemy='..(player.name))
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
    admin_announce("entry: "..game.table_to_json(player_force_entry))
    
    global.surface_enemy_force[new_surface.name] = enemy_force
    admin_announce("assigned "..global.surface_enemy_force[new_surface.name].." to "..new_surface.name)
    
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

local function updateEvolution(playerForce)
    local biter_nest_kill = 0
    local spitter_nest_kill = 0
    if playerForce.kill_count_statistics ~= nil then
        biter_nest_kill = playerForce.kill_count_statistics.get_flow_count{name="biter-spawner", input="input_counts", precision_index = defines.flow_precision_index.one_minute, count=true}
        spitter_nest_kill = playerForce.kill_count_statistics.get_flow_count{name="spitter-spawner", input="input_counts", precision_index = defines.flow_precision_index.one_minute, count=true}
    end
    local behemoth_worm_turret_kill = 0
    local big_worm_turret_kill = 0
    local medium_worm_turret_kill = 0
    local small_worm_turret_kill = 0
    if playerForce.entity_build_count_statistics ~= nil then
        behemoth_worm_turret_kill = playerForce.entity_build_count_statistics.get_flow_count{name="behemoth-worm-turret", input="output_counts", precision_index = defines.flow_precision_index.one_minute, count=true}
        big_worm_turret_kill = playerForce.entity_build_count_statistics.get_flow_count{name="big-worm-turret", input="output_counts", precision_index = defines.flow_precision_index.one_minute, count=true}
        medium_worm_turret_kill = playerForce.entity_build_count_statistics.get_flow_count{name="medium-worm-turret", input="output_counts", precision_index = defines.flow_precision_index.one_minute, count=true}
        small_worm_turret_kill = playerForce.entity_build_count_statistics.get_flow_count{name="small-worm-turret", input="output_counts", precision_index = defines.flow_precision_index.one_minute, count=true}
    end

    local force_info = global.all_player_forces[playerForce.name]
    local enemy = game.forces[force_info.enemy]
    local worm_kills = behemoth_worm_turret_kill + big_worm_turret_kill + medium_worm_turret_kill + small_worm_turret_kill
    local nest_kills = biter_nest_kill + spitter_nest_kill

    local surface_pollution = game.surfaces[force_info.surface].get_total_pollution() / 20

    if isFactionActive(playerForce) then
        enemy.evolution_factor_by_time = enemy.evolution_factor_by_time + 60*force_info.evo.time
        enemy.evolution_factor_by_pollution = enemy.evolution_factor_by_pollution + surface_pollution * force_info.evo.pollution
    end
    enemy.evolution_factor_by_killing_spawners = enemy.evolution_factor_by_killing_spawners + (nest_kills * force_info.evo.nest) + (worm_kills * force_info.evo.worm)

    enemy.evolution_factor = 1 - (1 - enemy.evolution_factor_by_time) * (1 - enemy.evolution_factor_by_pollution) * (1 - enemy.evolution_factor_by_killing_spawners)
end

local function protectForce(playerForce)
    if type(playerForce) == "string" then
        playerForce = game.forces[playerForce]
    end
    if playerForce.name == "player" then
        return
    end
    local force_info = global.all_player_forces[playerForce.name]
    local protect = not isFactionActive(playerForce)
    local surface = game.surfaces[force_info.surface]
    if protect then
        admin_announce("protection for "..playerForce.name.." set to True on "..surface.name)
    else
        admin_announce("protection for "..playerForce.name.." set to False on "..surface.name)
    end
    local enemy_force = game.forces[force_info.enemy]
    enemy_force.set_cease_fire(playerForce, protect)
	for _,build in pairs(surface.find_entities_filtered{force=playerForce.name}) do
		build.destructible = not protect
    end
end

local function preventOfflineActivity(event)
    if event and event.group and event.group.valid then
        local force = event.group.force
        if starts_with(force.name, "enemy=") then
            if not isFactionActive(get_remainder(force.name, "enemy=")) then
                event.group.destroy()
            end
        end
    end
end

local function updateForcesUi(player)
	if(player.gui.screen.rd_forces_ui == nil) then
        return
	end
    -- local disable_modification = global.debug
    local disable_modification = (not player.admin) and REQUIRE_PERMS
    local root = player.gui.screen.rd_forces_ui
    local table_root = root.settings_frame.settings_table

    table_root.playtime_value.caption = formattime_hours_mins(game.tick)
    local settings = global.settings

    if disable_modification then
        table_root.time_input.caption = settings.evo.time
        table_root.nest_input.caption = settings.evo.nest
        table_root.worm_input.caption = settings.evo.worm
        table_root.pollution_input.caption = settings.evo.pollution
    else
        table_root.time_input.text = tostring(settings.evo.time)
        table_root.nest_input.text = tostring(settings.evo.nest)
        table_root.worm_input.text = tostring(settings.evo.worm)
        table_root.pollution_input.text = tostring(settings.evo.pollution)
    end

    for force_name, entry in pairs(global.all_player_forces) do
        -- create new row
        if table_root["time_input="..force_name] == nil then

            if disable_modification then
                table_root.add({type="label", caption=force_name})
                table_root.add({type="label", name="time_input="..force_name, caption=entry.evo.time})
                table_root.add({type="label", name="nest_input="..force_name, caption=entry.evo.nest})
                table_root.add({type="label", name="worm_input="..force_name, caption=entry.evo.worm})
                table_root.add({type="label", name="pollution_input="..force_name, caption=entry.evo.pollution})
            else
                table_root.add({type="label", caption=force_name})
                local tmp = nil
                tmp = table_root.add({type="textfield", name="time_input="..force_name, numeric=true, allow_decimal=true,allow_negative=true, text=tostring(entry.evo.time)})
                tmp.style.width = 100
                tmp = table_root.add({type="textfield", name="nest_input="..force_name, numeric=true, allow_decimal=true,allow_negative=true, text=tostring(entry.evo.nest)})
                tmp.style.width = 100
                tmp = table_root.add({type="textfield", name="worm_input="..force_name, numeric=true, allow_decimal=true,allow_negative=true, text=tostring(entry.evo.worm)})
                tmp.style.width = 100
                tmp = table_root.add({type="textfield", name="pollution_input="..force_name, numeric=true, allow_decimal=true,allow_negative=true, text=tostring(entry.evo.pollution)})
                tmp.style.width = 100
            end
        else
            -- update existing data
            if disable_modification then
                table_root["time_input="..force_name].caption = entry.evo.time
                table_root["nest_input="..force_name].caption = entry.evo.nest
                table_root["worm_input="..force_name].caption = entry.evo.worm
                table_root["pollution_input="..force_name].caption = entry.evo.pollution
            else
                if tonumber(table_root["time_input="..force_name].text) ~= entry.evo.time then
                    table_root["time_input="..force_name].text = tostring(entry.evo.time)
                end
                if tonumber(table_root["nest_input="..force_name].text) ~= entry.evo.nest then
                    table_root["nest_input="..force_name].text = tostring(entry.evo.nest)
                end
                if tonumber(table_root["worm_input="..force_name].text) ~= entry.evo.worm then
                    table_root["worm_input="..force_name].text = tostring(entry.evo.worm)
                end
                if tonumber(table_root["pollution_input="..force_name].text) ~= entry.evo.pollution then
                    table_root["pollution_input="..force_name].text = tostring(entry.evo.pollution)
                end
            end
        end
    end

    -- display player names and evolution info
    for force_name, entry in pairs(global.all_player_forces) do
        local force_root = root["root="..force_name]
        if force_root == nil then
            -- create new table
            root.add({type="frame", name="root="..force_name,direction="vertical", caption=force_name})
            force_root = root["root="..force_name]
        end
        local force_table = force_root["table="..force_name]

        -- add new force table
        if force_table == nil then
            force_root.add({
                type="table",
                name="table="..force_name,
                column_count=5,
                draw_vertical_lines=true,
                draw_horizontal_lines=true,
                style="rd_se_table_style",
            })
            force_table = force_root["table="..force_name]
            -- new row
            force_table.add({type="label", caption="Total Playtime:"})
            force_table.add({type="label", caption="Evolution:"})
            force_table.add({type="label", caption="Time Evo"})
            force_table.add({type="label", caption="Kill Evo"})
            force_table.add({type="label", caption="Pollution Evo"})
            -- new row
            force_table.add({type="label", name="total_playtime", caption="TMP"})
            force_table.add({type="label", name="total_evo", caption="TMP"})
            force_table.add({type="label", name="time_evo", caption="TMP"})
            force_table.add({type="label", name="kill_evo", caption="TMP"})
            force_table.add({type="label", name="pollution_evo", caption="TMP"})
            -- new row
            force_table.add({type="label", caption="Player"})
            force_table.add({type="label", caption="Deaths"})
            force_table.add({type="label", caption=""})
            force_table.add({type="label", caption="Playtime"})
            force_table.add({type="label", caption="Last Seen"})
        end
        local total_player_ticks = 0
        for _, player in pairs(entry.players) do
            total_player_ticks = total_player_ticks + game.players[player].online_time
        end
        local enemy_force = game.forces[entry.enemy]
        force_table.total_playtime.caption = formattime_hours_mins(total_player_ticks)
        force_table.total_evo.caption = string.format("%.4f", enemy_force.evolution_factor * 100).."%"
        force_table.time_evo.caption = string.format("%.4f", enemy_force.evolution_factor_by_time * 100).."%"
        force_table.kill_evo.caption = string.format("%.4f", enemy_force.evolution_factor_by_killing_spawners * 100).."%"
        force_table.pollution_evo.caption = string.format("%.4f", enemy_force.evolution_factor_by_pollution * 100).."%"

        -- display player rows in forces
        for _, player_name in pairs(entry.players) do
            local player = game.players[player_name]
            if force_table["name="..player_name] == nil then
                -- new row
                local tmp = force_table.add({type="label", name="name="..player_name, caption=player_name})
                tmp.style['font_color'] = {r=player.color.r,g=player.color.g,b=player.color.b,a=1}
                tmp.style['font'] = "default-semibold"
                force_table.add({type="label", name="deaths="..player_name, caption="TMP"})
                force_table.add({type="label", name="tmp1="..player_name, caption="TMP"})
                force_table.add({type="label", name="playtime="..player_name, caption="TMP"})
                force_table.add({type="label", name="seen="..player_name, caption="TMP"})
            end
            force_table["deaths="..player_name].caption = tostring(global.death_counter[player.name])
            force_table["tmp1="..player_name].caption = ""
            force_table["playtime="..player_name].caption = formattime_hours_mins(player.online_time)
            if player.connected then
                force_table["seen="..player_name].caption = "Now"
            else
                force_table["seen="..player_name].caption = formattime_hours_mins(game.tick - player.last_online)
            end
        end
    end
end

local function toggleForcesUi(player)
	if(player.gui.screen.rd_forces_ui ~= nil) then
		player.gui.screen.rd_forces_ui.destroy()
        return
	end
	local widget = player.gui.screen.add({type="frame",direction="vertical",name="rd_forces_ui", caption="Forces"})
    local default_settings_group = widget.add({type="frame",name="settings_frame",direction="vertical"})
    local default_settings_info = default_settings_group.add({
        type="table",
        name="settings_table",
        column_count=5,
        draw_vertical_lines=true,
        draw_horizontal_lines=true,
        draw_horizontal_line_after_headers=true,
        style="rd_se_table_style",
    })
    -- row
    default_settings_info.add({type="label", caption="Total Playtime:"})
    default_settings_info.add({type="label", caption=""})
    default_settings_info.add({type="label", caption=""})
    default_settings_info.add({type="label", caption=""})
    default_settings_info.add({type="label", caption=""})
    -- row
    default_settings_info.add({type="label", name="playtime_value", caption="0:0:0"})
    default_settings_info.add({type="label", caption=""})
    default_settings_info.add({type="label", caption=""})
    default_settings_info.add({type="label", caption=""})
    default_settings_info.add({type="label", caption=""})
    -- row
    default_settings_info.add({type="label", caption="Force"})
    default_settings_info.add({type="label", caption="Evo Per Time"})
    default_settings_info.add({type="label", caption="Evo Per Nest"})
    default_settings_info.add({type="label", caption="Evo Per Worm"})
    default_settings_info.add({type="label", caption="Evo Per Pollution"})
    -- row
    -- local disable_modification = global.debug
    local disable_modification = (not player.admin) and REQUIRE_PERMS
    if disable_modification then
        default_settings_info.add({type="label", caption="Default"})
        default_settings_info.add({type="label", name="time_input", caption="TIME_FACTOR"})
        default_settings_info.add({type="label", name="nest_input", caption="NEST_FACTOR"})
        default_settings_info.add({type="label", name="worm_input", caption="WORM_FACTOR"})
        default_settings_info.add({type="label", name="pollution_input", caption="POLLUTION_FACTOR"})
    else
        default_settings_info.add({type="label", caption="Default"})
        local tmp = nil
        tmp = default_settings_info.add({type="textfield", name="time_input", numeric=true, allow_decimal=true,allow_negative=true})
        tmp.style.width = 100
        tmp = default_settings_info.add({type="textfield", name="nest_input", numeric=true, allow_decimal=true,allow_negative=true})
        tmp.style.width = 100
        tmp = default_settings_info.add({type="textfield", name="worm_input", numeric=true, allow_decimal=true,allow_negative=true})
        tmp.style.width = 100
        tmp = default_settings_info.add({type="textfield", name="pollution_input", numeric=true, allow_decimal=true,allow_negative=true})
        tmp.style.width = 100
    end

    updateForcesUi(player)
    widget.force_auto_center()
end

local function on_player_change(event)
    if not (event and event.player_index) then return end
    protectForce(game.players[event.player_index].force)
end

local function get_cause_name(cause, died_player)
    if cause then
        if cause.force then
            if starts_with(cause.force.name,"enemy=")
                or cause.force.name == "no_evolution"
                or cause.force.name == "low_evolution"
                or cause.force.name == "medium_evolution"
                or cause.force.name == "high_evolution"
                or cause.force.name == "max_evolution" then
                return "biters"
            end
            if starts_with(cause.force.name,died_player.force.name) then
                return "friendly fire"
            end
            for force_name, _ in pairs(global.all_player_forces) do
                if cause.force.name == force_name then
                    return "team "..force_name
                end
            end
        end
        -- no force?
    end
    return "something"
end

local function on_init()
    global.debug = false

    -- surface_enemy_force[surface_name] = enemy_name
	global.surface_enemy_force = {}

    -- structured as the following:
    -- all_player_forces[force_name]
    --      ["players"] = {player_names}
    --      ["surface"] = surface_name
    --      ["enemy"] = enemy_name
    --      ["evo"] :=
    --          ["time"] = time_factor
    --          ["nest"] = nest_factor
    --          ["worm"] = worm_factor
    --          ["pollution"] = pollution_factor
    global.all_player_forces = {}

    global.death_counter = {}

    global.settings = {}
    global.settings.evo = {
        time= game.map_settings.enemy_evolution.time_factor,
        nest= game.map_settings.enemy_evolution.destroy_factor,
        worm= WORM_KILL_RATE * game.map_settings.enemy_evolution.destroy_factor,
        pollution= game.map_settings.enemy_evolution.pollution_factor,
    }
    game.map_settings.enemy_evolution.time_factor = 0
    game.map_settings.enemy_evolution.destroy_factor = 0
    game.map_settings.enemy_evolution.pollution_factor = 0

    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)

    if script.active_mods["Krastorio2"] then
        remote.call("kr-crash-site", "crash_site_enabled", false)
    end

    remote.add_interface("rd-sem", { allow_aai_crash_sequence = function(data) return {allow = false, weight = 10} end})
    -- remote.add_interface("rd-tweaks", { allow_aai_crash_sequence = function(data) return {allow = false, weight = 1} end})

end

local function init()
    script.on_init(on_init)

    script.on_event(defines.events.on_player_created, on_create_player)
    script.on_event(defines.events.on_chunk_generated, on_chunk_gen)
    script.on_event(defines.events.on_unit_group_finished_gathering, preventOfflineActivity)
    script.on_event(defines.events.on_player_joined_game, on_player_change)
    script.on_event(defines.events.on_player_left_game, on_player_change)

    script.on_event(defines.events.on_pre_player_died, function(event)
        local died_player = game.players[event.player_index]
        local player_name = died_player.name
        local cause = get_cause_name(event.cause, died_player)
        global.death_counter[player_name] = global.death_counter[player_name] + 1
        if global.death_counter[player_name] == 1 then
            announce("Alert: "..player_name.." died for the first time to "..cause)
        elseif global.death_counter[player_name] == 2 then
            announce("Alert: "..player_name.." died for the second time to "..cause)
        elseif global.death_counter[player_name] == 3 then
            announce("Alert: "..player_name.." died for the third time to "..cause)
        else
            announce("Alert: "..player_name.." died for the "..tostring(global.death_counter[player_name]).."th time to "..cause)
        end
    end)

    script.on_nth_tick(60, function(e)
        -- once a second
        if e.tick % (60*60) == 0 then
            -- every 60 seconds
            for force_name,_ in pairs(global.all_player_forces) do
                updateEvolution(game.forces[force_name])
            end
        end
        if e.tick % (60*10) == 0 then
            -- every 10 seconds
            for _,player in pairs(game.connected_players) do
                updateForcesUi(player)
            end
        end
    end)

    script.on_event(defines.events.on_gui_text_changed, function(event)
        if not (event and event.element and event.element.valid) then return end
        local player = game.players[event.player_index]
        local element = event.element
        local settings = global.settings
        if starts_with(element.name,"time_input") then
            settings.evo.default.time = tonumber(event.text)
        elseif starts_with(element.name,"nest_input") then
            settings.evo.default.nest = tonumber(event.text)
        elseif starts_with(element.name,"worm_input") then
            settings.evo.default.worm = tonumber(event.text)
        elseif starts_with(element.name,"pollution_input") then
            settings.evo.default.pollution = tonumber(event.text)
        elseif starts_with(element.name,"time_input=") then
            local force_name = get_remainder(event.element.name,"time_input=")
            settings.evo[force_name].time = tonumber(event.text)
        elseif starts_with(element.name,"nest_input=") then
            local force_name = get_remainder(event.element.name,"nest_input=")
            settings.evo[force_name].nest = tonumber(event.text)
        elseif starts_with(element.name,"worm_input=") then
            local force_name = get_remainder(event.element.name,"worm_input=")
            settings.evo[force_name].worm = tonumber(event.text)
        elseif starts_with(element.name,"pollution_input=") then
            local force_name = get_remainder(event.element.name,"pollution_input=")
            settings.evo[force_name].pollution = tonumber(event.text)
        end
        admin_announce("settings changed by "..player.name.." to "..game.table_to_json(settings))
    end)

    script.on_event(defines.events.on_gui_click, function(event)
        if not (event and event.element and event.element.valid) then return end
        local player = game.players[event.player_index]
        if event.element.name == 'toggle_forces' then
            toggleForcesUi(player);
        elseif event.element.name == 'toggle_spawn_gui' then
            if(player.gui.screen.spawn_gui ~= nil) then
                player.gui.screen.spawn_gui.destroy()
            else
                showSpawnGui(player)
            end
        elseif event.element.name == 'spawn_alone' then
            local created = createPlayerEmpire(player)
            if(created) then
                player.gui.screen.spawn_gui.destroy()
                player.gui.top.rd_container.button_menu.toggle_spawn_gui.visible = false
            end
        elseif string.sub(event.element.name,1,string.len("join="))=="join=" then
            -- request to join
            local host_player = game.players[string.sub(event.element.name, 1 + string.len("join="))]
			if(host_player ~= nil and host_player.connected) then
				admin_announce((player.name).." wants to join team "..(host_player.force.name))
				askToJoin(host_player, player)
				player.gui.screen.spawn_gui.destroy()
			else
				player.print((host_player.name).." is offline")
            end
        elseif string.sub(event.element.name,1,string.len("acceptJoinRequest="))=="acceptJoinRequest=" then
			local playerJoining = game.players[string.sub(event.element.name,1 + string.len("acceptJoinRequest="))]
			player.gui.screen.askToJoin.destroy()
			if(playerJoining.connected) then
				playerJoining.print((player.name).." allowed you to join")
            end
            addPlayerToEmpire(playerJoining, player.force)
        elseif string.sub(event.element.name,1,string.len("refuseJoinRequest="))=="refuseJoinRequest=" then
			local playerJoining = game.players[string.sub(event.element.name,1 + string.len("refuseJoinRequest="))]
			player.gui.screen.askToJoin.destroy()
			if(playerJoining.connected) then
				playerJoining.print((player.name).." refused to let you join")
				showSpawnGui(playerJoining)
			end
        elseif(event.element.name == 'debug') then
            if player.admin then
                global.debug = not global.debug
                if global.debug then
                    admin_announce("global debug now true")
                else
                    admin_announce("global debug now false")
                end
            end
        else
            -- admin_announce(event.element.name)
        end
    end)
end

init()

