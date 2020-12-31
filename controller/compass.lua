local current_modname = minetest.get_current_modname()
local path = minetest.get_modpath(current_modname)

local compass_name = dofile(path.."/entities/compass.lua")

local controller = {}

local attached_compass = {}

controller.attach = function(player)
	local compass = minetest.add_entity(player:get_pos(), compass_name)
	compass:set_attach(player, "Head", vector.new(), vector.new(), true)
	
	local name = player:get_player_name()
	attached_compass[name] = compass
end

controller._remove_by_name = function(name)
	local compass = attached_compass[name]
	if compass then
		compass:remove()
		attached_compass[name] = nil
	end
end

controller.remove = function(player)
	local name = player:get_player_name()
	controller._remove_by_name(name)
end

controller.toggle = function(player)
	local name = player:get_player_name()
	if attached_compass[name] then
		controller.remove(player)
	else
		controller.attach(player)
	end
	return not not attached_compass[name]
end

controller.update = function()
	local remove_players = {}
	for name, compass in pairs(attached_compass) do
		local compass = attached_compass[name]
		local player = minetest.get_player_by_name(name)
		if player then
			local player_yaw = player:get_look_horizontal()
			local degrees = player_yaw*180/math.pi
			compass:set_attach(player, "Head", {x=0, y=4, z=0}, {x=0, y=degrees, z=0}, true)
		else
			table.insert(remove_players, name)
		end
	end
	
	for i,name in ipairs(remove_players) do
		controller._remove_by_name(name)
	end
end

return controller
