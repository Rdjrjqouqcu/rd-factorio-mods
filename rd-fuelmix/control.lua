
local one_offset_positions = {
	{-1, 0},
	{0, -1},
	{0, 1},
	{1, 0},
	{-1, -1},
	{-1, 1},
	{1, -1},
	{1, 1},
}

local two_offset_positions = {
	-- top
	{-2, 0},
	{-2, -1},
	{-2, 1},
	{-2, 2},
	-- left
	{0, -2},
	{-1, -2},
	{1, -2},
	{-2, -2},
	-- right
	{0, 2},
	{-1, 2},
	{1, 2},
	{2, 2},
	-- bottom
	{2, 0},
	{2, -1},
	{2, 1},
	{2, -2},
}


local function register_boxes(surface, position)
	for _,offset in pairs(one_offset_positions) do
		local entity = surface.find_entity("waterbox", {position.x + offset[2], position.y + offset[1]})
		if entity and entity.valid then
			local last = global.rd_waterbox.detonating_waterboxes["last"] + 1
			global.rd_waterbox.detonating_waterboxes["last"] = last
			global.rd_waterbox.detonating_waterboxes[last] = entity
		end
	end
	for _,offset in pairs(two_offset_positions) do
		local entity = surface.find_entity("waterbox", {position.x + offset[2], position.y + offset[1]})
		if entity and entity.valid then
			local last = global.rd_waterbox.detonating_waterboxes["last"] + 1
			global.rd_waterbox.detonating_waterboxes["last"] = last
			global.rd_waterbox.detonating_waterboxes[last] = entity
		end
	end

	-- for _, box in pairs(surface.find_entities_filtered({name = "waterbox", area = {{position.x - 0.75, position.y - .75}, {position.x + 0.75, position.y + 0.75}}})) do
	-- 	local last = global.rd_waterbox.detonating_waterboxes["last"] + 1
	-- 	global.rd_waterbox.detonating_waterboxes["last"] = last
	-- 	global.rd_waterbox.detonating_waterboxes[last] = box
	-- end
	-- for _, box in pairs(surface.find_entities_filtered({name = "waterbox", area = {{position.x - 1.75, position.y - 1.75}, {position.x + 1.75, position.y + 1.75}}})) do
	-- 	local last = global.rd_waterbox.detonating_waterboxes["last"] + 1
	-- 	global.rd_waterbox.detonating_waterboxes["last"] = last
	-- 	global.rd_waterbox.detonating_waterboxes[last] = box
	-- end
end

local function box_died(event)
	local entity = event.entity
	if not entity then return end
	if not entity.valid then return end	
	local position = entity.position
	if not position then return end	
	local surface = entity.surface
	
	register_boxes(surface, position)
	for _, ore in pairs(surface.find_entities_filtered({type = "resource", area = {{position.x - 0.49, position.y - 0.49}, {position.x + 0.49, position.y + 0.49}}})) do
		ore.destroy()
	end
	surface.set_tiles({{name = "water", position = position}}, true, false, true, false)
	if math.random(1, 64) == 1 then surface.create_entity({name = "fish", position = position}) end
end

local function tick()
	while global.rd_waterbox.detonating_waterboxes["first"] <= global.rd_waterbox.detonating_waterboxes["last"] do
	
		-- pop first entity
		local first = global.rd_waterbox.detonating_waterboxes["first"]
		local entity = global.rd_waterbox.detonating_waterboxes[first]
		global.rd_waterbox.detonating_waterboxes[first] = nil
		global.rd_waterbox.detonating_waterboxes["first"] = first + 1
	
		if entity and entity.valid then
			-- remove first valid entity and quit
			entity.die()
			return
		end
	end
end

local function on_init()
	global.rd_waterbox = {}
	global.rd_waterbox.detonating_waterboxes = {}
	global.rd_waterbox.detonating_waterboxes["first"] = 0
	global.rd_waterbox.detonating_waterboxes["last"] = -1
end

local function init()
	script.on_init(on_init)
	script.on_event(defines.events.on_entity_died, box_died, {{filter="name", name = "waterbox"}})
	script.on_event(defines.events.on_player_rotated_entity, function(event) 
		if event and event.entity and event.entity.valid and event.entity.name == "waterbox" then event.entity.die() end
	end)
	script.on_nth_tick(10, tick)
end

init()
