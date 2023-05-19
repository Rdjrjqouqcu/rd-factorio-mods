
local ticks_per_minute = 60 * 60

local function make_save_stamp(event)
    local raw_name = settings.startup["rd-save-stamper-name"].value
    local id = string.format("%0"..settings.startup["rd-save-stamper-padding"].value.."u", global.stamp_id)
    global.stamp_id = global.stamp_id + 1
    local name = ""
    if settings.startup["rd-save-stamper-seed"].value then
        name = string.format(raw_name, global.seed, id)
    else
        name = string.format(raw_name, id)
    end

    if name == "" then
        game.print(string.format("encountered empty name when attempting to save raw='%s' seed='%d' id='%s'"), raw_name, global.seed, id)
        global.stamp_id = global.stamp_id - 1
        return
    end

    if settings.startup["rd-save-stamper-autosave"].value then
        game.print({"info.rd-save-stamper-autosave", name})
        game.auto_save(name)
    else
        game.print({"info.rd-save-stamper-save", name})
        game.server_save(name)
    end
end

script.on_nth_tick(settings.startup["rd-save-stamper-delay"].value * ticks_per_minute, make_save_stamp)

script.on_init(
    function()
        global.seed = game.default_map_gen_settings.seed
        global.stamp_id = 0
    end
)

