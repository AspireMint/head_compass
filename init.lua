local current_modname = minetest.get_current_modname()
local path = minetest.get_modpath(current_modname)

local mod_util = dofile(path.."/utils/mod.lua")
local mod = mod_util.export({}).from(current_modname)

mod.controller = dofile(path.."/controller/compass.lua")

minetest.register_on_leaveplayer(function(player)
	mod.controller.remove(player)
end)

minetest.register_chatcommand("compass", {
    privs = {},
    func = function(name, param)
		local player_name = name
		if param ~= "" and minetest.check_player_privs(name, "give") then
			player_name = param
		end
		
		local player = minetest.get_player_by_name(player_name)
		
		if not player then
			return false, "Player '"..player_name.."' does not exist"
		end
		
		local visible = mod.controller.toggle(player)
		local message = visible and "Compass added" or "Compass removed"
		local suffix = ""
		if name ~= param and player_name == param then
			suffix = " for player '"..player_name.."'"
			minetest.chat_send_player(player_name, message)
		end
        return true, message..suffix
    end
})

--(move to entity def)
minetest.register_globalstep(function(dtime)
	mod.controller.update()
end)
