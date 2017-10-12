-- constructor called by modns, and therefore called when another mod is "current"
local internallog = _log.internal
local testtable = {1, 2}
local shallowcopy = _log.shallowcopy
local new = _log.new
local defaults = _log.default

return function()
	local modname = tostring(minetest.get_current_modname())
	internallog("setting up log access interface for "..modname)
	--internallog(tostring(new.logger))

	return {
		test = function()
			internallog("hi! from "..modname)
		end,
		testtable = shallowcopy(testtable),
		new = {
			logger = new.logger,
			appender = shallowcopy(new.appender)
		},
		default = {
			formatter = defaults.formatter
		}
	}
end
