local internallog = _log.internal
local testtable = {1, 2}
local shallowcopy = _log.shallowcopy
local new = _log.new
local defaults = _log.default
local rootlogger = _log.root

local label_getlogger = "libmtlog interface.getlogger() "
local msg_getlogger_badname = label_getlogger.."no valid name passed and not running at mod initialisation time, cannot generate a caller name"

return function()
	local modname = minetest.get_current_modname()
	local modname_str = tostring(modname)
	internallog("setting up log access interface for "..modname_str)
	--internallog(tostring(new.logger))

	return {
		new = {
			logger = new.logger,
			appender = shallowcopy(new.appender)
		},
		default = {
			formatter = defaults.formatter
		},
		getlogger = function(callername)
			-- this will be running in mod context,
			-- so we can look at minetest.get_current_modname().
			-- however, it is perfectly concieviable that a mod call the constructor at runtime.
			-- so in that case we must insist they provide a name.
			if type(callername) ~= "string" then
				if modname == nil then
					error(msg_getlogger_badname)
				end
				callername = "mod."..modname
			end
			callername = callername..":log"
			return rootlogger.newchild(callername)
		end,
		-- allow mods to install appenders to the root logger to monitor things.
		-- this is mainly intended to allow server admins to be registered
		root_appender = {
			add = rootlogger.appender_add,
			remove = rootlogger.appender_remove
		}
	}
end
