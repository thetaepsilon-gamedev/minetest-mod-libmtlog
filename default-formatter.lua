-- default formatter - doesn't do anything smart with the event.
-- more or less dumps a serialisation of a log event (though this is not intended to be stable yet).
-- also serves as the authorative documentation on the structure of a log event.
-- note that this is a table, however it is noted that this can become somewhat cumbersome.
-- the loggers returned to mods have additional factory methods which can help with the boilerplate.

_log.default.formatter = function(logevent)
	-- the event type/name field - always expected to be present.
	-- this should be a machine-parseable identifer as opposed to a human-readable statement.
	-- translators for the message types should be separate from the actual logging statements,
	-- which gives a good-practice basis to easily swap out the translator to implement i18n.
	-- ex. name should be something like "com.example.mymod.somethingregistered",
	-- as opposed to a hard-coded "registered something to core".
	local result = logevent.name

	local sep = " "
	local kvsep = "="
	-- args table, contains any extra info relevant to the event.
	-- translators in particular have access to these fields.
	local args = logevent.args
	if type(args) == "table" then for key, value in pairs(args) do
		result = result..sep..tostring(key)..kvsep..tostring(value)
	end end

	return result
end
