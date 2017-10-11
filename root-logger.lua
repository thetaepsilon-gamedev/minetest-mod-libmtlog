-- root logger which (hopefully) other mods will use (via their own loggers/subloggers).
-- at some point minetest.log()'s loglevels might be utilised;
-- for now, bind the print() function at load time to be the printer for this text logger to the console.

local printer = print
-- placeholder - translation facility would be useful here
-- need to look into whether locale say can be detected from intllib if present.
local formatter = _log.default.formatter
