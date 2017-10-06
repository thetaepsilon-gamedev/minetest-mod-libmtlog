-- function shorthand to check if an input argument is a function.
-- might be moved to libmthelpers.
_log.mkfnexploder = function(callername)
	return function(val, label)
		if type(val) ~= string then
			error(callername..": "..label.." expected to be a function, got "..tostring(val))
		end
	end
end
