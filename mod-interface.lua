local internallog = _log.internal
local testtable = {1, 2}
local new = _log.new
local defaults = _log.default
local rootlogger = _log.root

local label_getlogger = "libmtlog interface.getlogger() "
local msg_getlogger_badname = label_getlogger.."no valid name passed and not running at mod initialisation time, cannot generate a caller name"

local interface = {
	new = {
		logger = new.logger,
		appender = new.appender
	},
	default = {
		formatter = defaults.formatter
	},
	-- allow mods to install appenders to the root logger to monitor things.
	-- this is mainly intended to allow server admins to be registered
	root_appender = {
		add = rootlogger.appender_add,
		remove = rootlogger.appender_remove
	},
}



getlogger = function(callername)
	local modname = minetest.get_current_modname()
	local modname_str = tostring(modname)
	--internallog(tostring(new.logger))
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
	--internallog("setting up log access interface for "..modname_str)
	return rootlogger.newchild(callername)
end

interface.getlogger = getlogger

return interface
