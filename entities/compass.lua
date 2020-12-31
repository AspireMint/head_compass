local current_modname = minetest.get_current_modname()

local entity_name = current_modname..":compass"

minetest.register_entity(entity_name, {
	initial_properties = {
		visual = "mesh",
		visual_size = {x=4.5, y=4.5},
		mesh = "compass.obj",
		textures = {"compass.png"},
		pointable = false,
		static_save = false
	}
})

return entity_name
