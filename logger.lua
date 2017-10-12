-- logger
-- acts as a multiplexer to all attached appenders.
-- events will be forwarded to each in turn.
-- may itself also act as an appender for another logger.

local mkset = _log.mkset
local mkexploder = _log.mkfnexploder

-- copies logger origin metadata for internal use.
-- also used to copy metadata between levels non-destructively while allowing it to remain a table.
local copy_caller_metadata = function(origin)
	local result = {}

	if type(origin) ~= "table" then origin = {} end
	result.name = tostring(origin.name)

	return result
end

local construct = function(opts)
	local caller = {}
	local typecheck = type(opts)
	if typecheck == "table" then
		-- this is fine
	elseif opts == nil then
		opts = {}
	else
		error("options argument for logger constructor expected to be a table or nil, got "..typecheck)
	end

	local check = mkexploder("new.logger")

	local name = opts.name
	if type(name) ~= "string" then name = "" end
	-- no private variable access for you!
	local self = {
		appenders = mkset()
	}
	local dolog = function(event)
		for appender in self.appenders.iterator() do appender(caller, event) end
	end
	local interface = {
		name = function() return name end,
		appender_add = function(appender)
			check(appender, "log appender")
			return self.appenders.add(appender)
		end,
		-- oh, I love closures...
		-- and being able to pass functions as values when they closure over themselves.
		appender_remove = self.appenders.remove,
		log = dolog,
	}
	return interface
end

_log.new.logger = construct
