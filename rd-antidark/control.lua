local ticks_per_second = 60

local seconds_per_update = 1

local quality_discount = 0.75

local energy_J_s = settings.startup["rd-antidark-phantom-drain"].value
local initial_energy_multiplier = settings.startup["rd-antidark-phantom-drain-mult"].value
local darkness_cutoff = 0.3

local chunk_radius = settings.startup["rd-antidark-radarlight-chunkradius"].value


local chunk_offsets = {
    { 8,  8 },
    { 8,  24 },
    { 24, 8 },
    { 24, 24 },
}

local function lamp_position_string(pos)
    return pos.t .. "|" .. pos.s .. "|" .. pos.x .. "|" .. pos.y
end

local function render_position_string(pos)
    return pos.s .. "|" .. pos.x .. "|" .. pos.y
end

local function create_light(loc_str, loc)
    storage.rd_antidark.lamp_renders[loc_str] = rendering.draw_light({
        sprite = "utility/light_medium",
        time_to_live = 2 * seconds_per_update * ticks_per_second,
        target = loc,
        surface = loc.s,
        intensity = 1,
        scale = 8,
    }).id
end

local function get_lamp(lamp_loc)
    local lamp = game.surfaces[lamp_loc.s].find_entity(lamp_loc.t, lamp_loc)

    if script.active_mods["quality"] then
        lamp = lamp or game.surfaces[lamp_loc.s].find_entity({ name = lamp_loc.t, quality = "uncommon" }, lamp_loc)
        lamp = lamp or game.surfaces[lamp_loc.s].find_entity({ name = lamp_loc.t, quality = "rare" }, lamp_loc)
        lamp = lamp or game.surfaces[lamp_loc.s].find_entity({ name = lamp_loc.t, quality = "epic" }, lamp_loc)
        lamp = lamp or game.surfaces[lamp_loc.s].find_entity({ name = lamp_loc.t, quality = "legendary" }, lamp_loc)
    end

    if lamp == nil then return nil end
    if not lamp.valid then return nil end
    return lamp
end

local function drain_energy(lamp, sec)
    if lamp == nil then
        return false
    end
    local drain_amount = sec * energy_J_s

    if script.active_mods["quality"] then
        local quality = lamp.quality.level
        -- game.print(quality .. " " .. (quality_discount ^ quality))
        drain_amount = drain_amount * (quality_discount ^ quality)
    end
    if lamp.energy < drain_amount then
        return false
    end
    lamp.energy = lamp.energy - drain_amount
    return true
end

local function handle_chunk(lamp, chunk_pos)
    for _, offset in pairs(chunk_offsets) do
        local loc = {
            x = chunk_pos.x * 32 + offset[1],
            y = chunk_pos.y * 32 + offset[2],
            s = chunk_pos.s
        }
        local loc_str = render_position_string(loc)
        -- game.print("    " .. loc_str)
        if storage.rd_antidark.lamp_renders[loc_str] == nil then
            if drain_energy(lamp, 1 + seconds_per_update * initial_energy_multiplier) then
                create_light(loc_str, loc)
            end
        else
            local rId = storage.rd_antidark.lamp_renders[loc_str]
            local renders = rendering.get_object_by_id(rId)
            if renders == nil then
                if drain_energy(lamp, 1 + seconds_per_update * initial_energy_multiplier) then
                    create_light(loc_str, loc)
                end
            else
                local ttl = renders.time_to_live
                if ttl < 2 * seconds_per_update * ticks_per_second then
                    if drain_energy(lamp, seconds_per_update) then
                        -- add more time
                        renders.time_to_live = ttl + seconds_per_update * ticks_per_second
                    end
                end
            end
        end
    end
end

local function update_lights()
    for _, lamp_loc in pairs(storage.rd_antidark.chunk_lamps) do
        -- game.print("HANDLING: " .. helpers.table_to_json(lamp_loc))
        if game.surfaces[lamp_loc.s].darkness > darkness_cutoff then
            local lamp = get_lamp(lamp_loc)
            if lamp == nil then
                storage.rd_antidark.chunk_lamps[lamp_position_string(lamp_loc)] = nil
            else
                if lamp_loc.t == "ad-chunk-light" then
                    handle_chunk(lamp, {
                        x = math.floor(lamp_loc.x / 32),
                        y = math.floor(lamp_loc.y / 32),
                        s = lamp_loc.s,
                    })
                end
                if lamp_loc.t == "ad-radar-light" then
                    local quality_radius = chunk_radius + lamp.quality.level
                    for j = -quality_radius, quality_radius do
                        for k = -quality_radius, quality_radius do
                            handle_chunk(lamp, {
                                x = math.floor(lamp_loc.x / 32) + j,
                                y = math.floor(lamp_loc.y / 32) + k,
                                s = lamp_loc.s,
                            })
                        end
                    end
                end
            end
        end
    end
end

local function add_light_to_tracking(event)
    local entity = event.entity
    if not entity then return end
    local position = entity.position
    if not position then return end
    local surface = entity.surface.name
    local lightLocation = {
        t = entity.name,
        s = surface,
        x = position.x,
        y = position.y,
    }
    game.print("ADDING: " .. lamp_position_string(lightLocation))
    storage.rd_antidark.chunk_lamps[lamp_position_string(lightLocation)] = lightLocation
    -- game.print("TRACKING: " .. helpers.table_to_json(storage.rd_antidark.chunk_lamps))
end

local function remove_light_from_tracking(event)
    local entity = event.entity
    if not entity then return end
    local position = entity.position
    if not position then return end
    local surface = entity.surface.name
    local lightLocation = {
        t = entity.name,
        s = surface,
        x = position.x,
        y = position.y,
    }
    game.print("REMOVING: " .. lamp_position_string(lightLocation))
    storage.rd_antidark.chunk_lamps[lamp_position_string(lightLocation)] = nil
    -- game.print("TRACKING: " .. helpers.table_to_json(storage.rd_antidark.chunk_lamps))
end

script.on_nth_tick(seconds_per_update * ticks_per_second, update_lights)

-- local chunk_enabled = settings.startup["rd-antidark-chunklight-enabled"].value
-- local radar_enabled = settings.startup["rd-antidark-radarlight-enabled"].value

local filters = { { filter = "name", name = "ad-chunk-light" }, { filter = "name", name = "ad-radar-light" } }

script.on_event(defines.events.on_built_entity, add_light_to_tracking, filters)
script.on_event(defines.events.on_robot_built_entity, add_light_to_tracking, filters)

script.on_event(defines.events.on_player_mined_entity, remove_light_from_tracking, filters)
script.on_event(defines.events.on_robot_mined_entity, remove_light_from_tracking, filters)
script.on_event(defines.events.on_entity_died, remove_light_from_tracking, filters)

script.on_init(
    function()
        storage.rd_antidark = {}
        storage.rd_antidark.chunk_lamps = {}
        storage.rd_antidark.lamp_qualities = {}
        storage.rd_antidark.lamp_renders = {}
    end
)
