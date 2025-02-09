local M = {}

M.LOBBY_RADIUS = 42
M.LOBBY_WATER_GAP = 10
M.LOBBY_LOCATION = {x=0,y=0}
M.LOBBY_AREA = {
    left_top = { x = M.LOBBY_LOCATION["x"] - M.LOBBY_RADIUS, y = M.LOBBY_LOCATION["y"] - M.LOBBY_RADIUS},
    right_bottom = { x = M.LOBBY_LOCATION["x"] + M.LOBBY_RADIUS, y = M.LOBBY_LOCATION["y"] + M.LOBBY_RADIUS},
}


function M.generate_lobby()
    if global.lobby_generated then
        return
    end
    global.lobby_generated = true
    game.map_settings.enemy_evolution.enabled = false

    local surface = game.surfaces['nauvis']
    surface.always_day=true
    surface.destroy_decoratives(M.LOBBY_AREA)
    for _,entity in pairs(surface.find_entities_filtered({force='enemy'})) do
        entity.destroy()
    end

    game.forces['player'].set_spawn_position(M.LOBBY_LOCATION, surface)

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
    for i=M.LOBBY_AREA.left_top.x,M.LOBBY_AREA.right_bottom.x,1 do
        for j=M.LOBBY_AREA.left_top.y,M.LOBBY_AREA.right_bottom.y,1 do

            local dist_origin = (M.LOBBY_LOCATION.x - i) ^ 2 + (M.LOBBY_LOCATION.y - j) ^ 2

            if (dist_origin <= (M.LOBBY_RADIUS - M.LOBBY_WATER_GAP) ^ 2) then
                table.insert(start_tiles, {name = 'tutorial-grid', position ={i,j}})
            end
            if ((M.LOBBY_RADIUS - M.LOBBY_WATER_GAP) ^ 2 < dist_origin and dist_origin  < M.LOBBY_RADIUS ^ 2) then
                table.insert(start_tiles, {name = 'out-of-map', position ={i,j}})
            end
        end
    end
    surface.set_tiles(start_tiles)

    -- clean starting circle
    for key, entity in pairs(surface.find_entities_filtered({area=M.LOBBY_AREA})) do
        if entity.valid and entity and entity.position then
            if ((M.LOBBY_LOCATION.x - entity.position.x)^2 + (M.LOBBY_LOCATION.y - entity.position.y)^2 < M.LOBBY_RADIUS^2) then
                if entity.type == "character" then
                    -- skip characters
                else
                    entity.destroy()
                end
            end
        end
    end
end

return M

