-- constructor called by modns, and therefore called when another mod is "current"
local internallog = _log.internal

return function()
	local modname = tostring(minetest.get_current_modname())
	internallog("setting up log access interface for "..modname)

	return {
		test = function()
			internallog("hi! from "..modname)
		end
	}
end