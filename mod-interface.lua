-- constructor called by modns, and therefore called when another mod is "current"
local internallog = _log.internal
local testtable = {1, 2}
local shallowcopy = _log.shallowcopy

return function()
	local modname = tostring(minetest.get_current_modname())
	internallog("setting up log access interface for "..modname)

	return {
		test = function()
			internallog("hi! from "..modname)
		end,
		testtable = shallowcopy(testtable),
		new = {
			logger = _log.new.logger,
			appender = shallowcopy(_log.new.appender)
		},
	}
end
