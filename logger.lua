-- logger
-- acts as a multiplexer to all attached appenders.
-- events will be forwarded to each in turn.
-- may itself also act as an appender for another logger.

local construct = function(opts)
	local typecheck = type(opts)
	if typecheck == "table" then
		-- this is fine
	elseif opts == nil then
		opts = {}
	else
		error("options argument for logger constructor expected to be a table or nil, got "..typecheck)
	end

	-- no private variable access for you!
	local self = {
		-- I miss hashmaps...
		appenders = {}
	}
	return {
		
	}
end
