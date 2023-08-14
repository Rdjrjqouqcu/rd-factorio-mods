local index = require("site/lua/index")
local base64 = require("site/lua/base64")
local icon = require("site/lua/icon")
local ticks_per_minute = 60 * 60

local function name_prefix()
    if settings.global["rd-timelapse-map-seed"].value then
        return string.format("%d", global.seed)
    else
        return "timelapse-map"
    end
end

local function do_autosave(current_minute)
    local id = string.format("%09u", current_minute)
    local save_name = string.format("%s/%s", name_prefix(), id)
    game.print({"info.rd-timelapse-map-autosave-message", save_name})
    game.auto_save(save_name)
end

local function expand_area(area)
    local radius = settings.global["rd-timelapse-map-radius"].value
    return {
        left_top = {
            x = area.left_top.x - radius,
            y = area.left_top.y - radius,
        },
        right_bottom  = {
            x = area.right_bottom .x + radius,
            y = area.right_bottom .y + radius,
        },
    }
end

local function fix_crash_site(surface, chunkArea)
    return surface.count_entities_filtered{
        area = chunkArea,
        name = {
            "crash-site-spaceship-wreck-small-1",
            "crash-site-spaceship-wreck-small-2",
            "crash-site-spaceship-wreck-small-3",
            "crash-site-spaceship-wreck-small-4",
            "crash-site-spaceship-wreck-small-5",
            "crash-site-spaceship-wreck-small-6",
            "crash-site-spaceship-wreck-medium-1",
            "crash-site-spaceship-wreck-medium-2",
            "crash-site-spaceship-wreck-medium-3",
            "crash-site-spaceship-wreck-big-1",
            "crash-site-spaceship-wreck-big-2",
            "crash-site-spaceship",
        },
        limit = 1,
    }
end

local function should_screenshot_chunk_entities(surface, chunkPos, forces)
    local chunkArea = expand_area(chunkPos.area)
    local entities = surface.count_entities_filtered{
        area = chunkArea,
        force = forces,
        limit = 1,
    }
    if settings.global["rd-timelapse-map-screenshot-fix-crash-site"].value then
        entities = entities + fix_crash_site(surface, chunkArea)
    end
    return entities > 0
    -- game.print(string.format("checking chunk %d %d %s entites=%d", chunkPos.x, chunkPos.y, game.table_to_json(chunkArea), entities))
end

local function should_screenshot_chunk_charted(surface, chunkPos, forces)
    for _, force in ipairs(forces) do
        if game.forces[force].is_chunk_charted(surface, chunkPos) then
            return true
        end
    end
    return false
end

local function should_screenshot_chunk_revealed(surface, chunkPos, forces)
    for _, force in ipairs(forces) do
        if game.forces[force].is_chunk_visible(surface, chunkPos) then
            return true
        end
    end
    return false
end

local function should_screenshot_chunk(surface, chunkPos, forces)
    if settings.global["rd-timelapse-map-mode"].value == "entities" then
        return should_screenshot_chunk_entities(surface, chunkPos, forces)
    end
    if settings.global["rd-timelapse-map-mode"].value == "charted" then
        return should_screenshot_chunk_charted(surface, chunkPos, forces)
    end
    if settings.global["rd-timelapse-map-mode"].value == "revealed" then
        return should_screenshot_chunk_revealed(surface, chunkPos, forces)
    end
    game.print("Internal setting error, unknown map mode: "..settings.global["rd-timelapse-map-mode"].value)
    return false
end

local function do_screenshot(surface_name, current_minute, forces)
    local surface = game.get_surface(surface_name)
    if surface == nil then
        game.print({"info.rd-timelapse-map-surface-missing", surface_name})
        return
    end
    local chunks = {}
    local chunk_count = 0
    for chunkPos in surface.get_chunks() do
        if should_screenshot_chunk(surface, chunkPos, forces) then
            local screenshot_path = string.format("%s/%d/%s/%d_%d.png", name_prefix(), current_minute, surface_name, chunkPos.x, chunkPos.y)
            local resolution = settings.global["rd-timelapse-map-resolution"].value 
            local scale = resolution / 32
            game.take_screenshot{
                surface = surface_name,
                position = {x = chunkPos.x * 32 + 16, y = chunkPos.y * 32 + 16},
                zoom = scale,
                resolution = {x = 32*resolution, y = 32*resolution},
                path = screenshot_path,
                show_entity_info = settings.global["rd-timelapse-map-screenshot-altmode"].value,
                daytime = 0,
            }
            table.insert(chunks, {chunkPos.x, chunkPos.y})
            chunk_count = chunk_count + 1
        end
    end

    game.set_wait_for_screenshots_to_finish()
    game.print({"info.rd-timelapse-map-snapshot-complete-message", chunk_count, surface_name})
    return chunks
end

local function do_metadata(ctime, surfaces, forces, captured)
    local filename = string.format("%s/%d/metadata.json", name_prefix(), ctime)
    local metadata = {
        tick = game.tick,
        minute = ctime,
        seed = global.seed,
        tracked_surfaces = surfaces,
        tracked_forces = forces,
        captured_chunks = captured,
        pixels_per_tile = settings.global["rd-timelapse-map-resolution"].value,
        entity_radius = settings.global["rd-timelapse-map-radius"].value,
        mods = game.active_mods,
        map_exchange_string = game.get_map_exchange_string(),
    }
    game.write_file(filename, game.table_to_json(metadata))
end

local function load_forces()
    local force_string = settings.global["rd-timelapse-map-forces"].value
    local forces = {}
    for force in string.gmatch(force_string, "([^,;]+)", 0) do
        if force == "ALL" or force == "*" then
            for _, f in pairs(game.forces) do
                table.insert(forces, f.name)
            end
            return forces
        end
    end
    for force in string.gmatch(force_string, "([^,;]+)", 0) do
        if force ~= "" then
            if game.forces[force] ~= nil then
                table.insert(forces, force)
            else
                game.print({"info.rd-timelapse-map-force-missing", force})
            end
        end
    end
    if table_size(forces) == 0 then
        game.print({"info.rd-timelapse-map-force-missing", "ANY"})
    end
    return forces
end

local function load_surfaces()
    local surfaces_string = settings.global["rd-timelapse-map-surfaces"].value
    local surfaces = {}
    for surface in string.gmatch(surfaces_string, "([^,;]+)", 0) do
        if surface == "ALL" or surface == "*" then
            for _, s in pairs(game.surfaces) do
                table.insert(surfaces, s.name)
            end
            return surfaces
        end
    end
    for surface in string.gmatch(surfaces_string, "([^,;]+)", 0) do
        if surface ~= "" then
            if game.surfaces[surface] ~= nil then
                table.insert(surfaces, surface)
            else
                game.print({"info.rd-timelapse-map-surface-missing", surface})
            end
        end
    end
    if table_size(surfaces) == 0 then
        game.print({"info.rd-timelapse-map-surface-missing", "ANY"})
    end
    return surfaces
end

local function do_actions(event)
    local current_minute = event.tick / ticks_per_minute
    game.print({"info.rd-timelapse-map-snapshot-message", current_minute})

    if settings.global["rd-timelapse-map-autosave"].value then
        do_autosave(current_minute)
    end

    local forces = load_forces()
    local surfaces = load_surfaces()

    local captured = {}
    for _, surface in ipairs(surfaces) do
        captured[surface] = do_screenshot(surface, current_minute, forces)
    end

    do_metadata(current_minute, surfaces, forces, captured)
end

local function create_files()
    game.write_file(name_prefix().."/index.html", index.html)
    game.write_file(name_prefix().."/index.css", index.css)
    game.write_file(name_prefix().."/lib/favicon.ico", base64.decode(icon.icon))
end

script.on_nth_tick(settings.global["rd-timelapse-map-delay"].value * ticks_per_minute, do_actions)

script.on_init(
    function()
        global.seed = game.default_map_gen_settings.seed
        if settings.global["rd-timelapse-map-create-site"].value then
            create_files()
        end
    end
)


local GUI_FRAME_NAME = "rd-timelapse-map-frame"
local GUI_LABEL_NAME = "rd-timelapse-map-label"

local function tick_to_countdown(tick)
    local target_second = settings.global["rd-timelapse-map-delay"].value * ticks_per_minute / 60
    local seconds_remaining = target_second - (math.floor(tick / 60) % target_second)
    local seconds = seconds_remaining % 60
    local minutes = seconds_remaining / 60
    return string.format("%02d:%02d", minutes, seconds)
end

local function update_timers(event)
    local new_time = tick_to_countdown(event.tick)
    for _, player in pairs(game.players) do
        if settings.get_player_settings(player)["rd-timelapse-map-show-timer"].value then
            if player.gui.top[GUI_FRAME_NAME] == nil then
                player.gui.top.add{type="frame", name=GUI_FRAME_NAME}
            end
            if player.gui.top[GUI_FRAME_NAME][GUI_LABEL_NAME] == nil then
                player.gui.top[GUI_FRAME_NAME].add{type="label", name=GUI_LABEL_NAME}
            end
            player.gui.top[GUI_FRAME_NAME][GUI_LABEL_NAME].caption = new_time
        end
    end
end

local function reset_timers(event)
    local new_time = tick_to_countdown(event.tick)
    for _, player in pairs(game.players) do
        if not settings.get_player_settings(player)["rd-timelapse-map-show-timer"].value then
            if player.gui.top[GUI_FRAME_NAME][GUI_LABEL_NAME] ~= nil then
                player.gui.top[GUI_FRAME_NAME][GUI_LABEL_NAME].destroy()
            end
            if player.gui.top[GUI_FRAME_NAME] ~= nil then
                player.gui.top[GUI_FRAME_NAME].destroy()
            end
        else
            if player.gui.top[GUI_FRAME_NAME] == nil then
                player.gui.top.add{type="frame", name=GUI_FRAME_NAME}
            end
            if player.gui.top[GUI_FRAME_NAME][GUI_LABEL_NAME] == nil then
                player.gui.top[GUI_FRAME_NAME].add{type="label", name=GUI_LABEL_NAME}
            end
            player.gui.top[GUI_FRAME_NAME][GUI_LABEL_NAME].caption = new_time
        end
    end
end

script.on_nth_tick(60, update_timers)
script.on_configuration_changed(reset_timers)
script.on_event(defines.events.on_runtime_mod_setting_changed, reset_timers)
