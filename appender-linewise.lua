-- line-wise text log appender
-- "flattens" incoming log events into a string using the provided formatter,
-- then calls the provided printer function to do something with it (such as log to a console somewhere).
-- there's nothing really preventing the flattened string from being multi-line,
-- but the intended use case is that of printing log events to console or player chat.
-- this function makes the guarantee that printer will see a string as it's sole argument via string coercement,
-- so it is the formatter's responsibility to correctly produce a string.

local check = _log.mkfnexploder("new.appender.text")

_log.new.appender.text = function(formatter, printer)
	check(formatter, "formatter")
	check(printer, "printer")
	return function(caller, logevent)
		-- CHAAAAIIINING AWAAAAAAY
		printer(tostring(formatter(caller, logevent)))
	end
end
