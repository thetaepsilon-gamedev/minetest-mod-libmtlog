-- logger
-- acts as a multiplexer to all attached appenders.
-- events will be forwarded to each in turn.
-- may itself also act as an appender for another logger.
-- call ancestor_logger.forward() to retrieve an appropriate appender closure function.

local mkset = _log.mkset

local construct = function(opts)
	local typecheck = type(opts)
	if typecheck == "table" then
		-- this is fine
	elseif opts == nil then
		opts = {}
	else
		error("options argument for logger constructor expected to be a table or nil, got "..typecheck)
	end

	local name = opts.name
	if type(name) ~= "string" then name = "" end
	-- no private variable access for you!
	local self = {
		appenders = mkset()
	}
	local dolog = function(event)
		for appender in self.appenders.iterator() do appender(event) end
	end
	return {
		name = function() return name end
		appender_add = function(appender)
			if type(appender) ~= "function" then
				error("appender must be a function!")
			end
			return self.appenders.add(appender)
		end,
		-- oh, I love closures...
		appender_remove = self.appenders.remove,
		log = dolog,
		forward = function() return dolog end
	}
end

return construct
