-- logger
-- acts as a multiplexer to all attached appenders.
-- events will be forwarded to each in turn.
-- may itself also act as an appender for another logger.

local mkset = _log.mkset
local mkexploder = _log.mkfnexploder

local childsep = "."

local validatename = function(name)
	local prefix = "libmtlog.new.logger() "
	if type(name) ~= "string" then
		error(prefix.."name must be a string!")
	end
	-- TODO: maybe make this restrict the charset at some point.
end

local checkappender = mkexploder("logger.appender_add()")

local construct
construct = function(opts)
	local caller = {}
	local typecheck = type(opts)
	if typecheck == "table" then
		-- this is fine
	else
		error("options argument for logger constructor expected to be a table, got "..typecheck)
	end

	local name = opts.name
	validatename(name)
	caller.name = name

	-- no private variable access for you!
	local self = {
		appenders = mkset()
	}
	local dolog = function(caller, event)
		for appender in self.appenders.iterator() do appender(caller, event) end
	end
	local interface = {
		name = function() return name end,
		appender_add = function(appender)
			checkappender(appender, "log appender")
			return self.appenders.add(appender)
		end,
		-- oh, I love closures...
		-- and being able to pass functions as values when they closure over themselves.
		appender_remove = self.appenders.remove,
		log = function(event) dolog(caller, event) end,
		newchild = function(suffix)
			local childname = name..childsep..suffix
			local child = construct({name=childname})
			-- child will now handle calling with the complete name.
			-- so allow it direct access to dolog() as an appender.
			child.appender_add(dolog)
			return child
		end
	}
	return interface
end

_log.new.logger = construct
