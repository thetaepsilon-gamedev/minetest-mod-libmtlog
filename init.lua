-- temp. global for passing references to dofile() scripts
_log = {}
_log.internal = function(msg)
	print("# [libmtlog] "..msg)
end

-- we need a "currentmod" global per mod to avoid this boilerplate line
-- maybe even a currentmod.dofile("relative-file.lua"), though that's not less chars to type...
local modpath = minetest.get_modpath(minetest.get_current_modname())

local parts = {
	"external-dependencies.lua",
}
for _, part in ipairs(parts) do dofile(modpath.."/"..part) end

local interface = dofile(modpath.."/mod-interface.lua")
modns.register("com.github.thetaepsilon.minetest.libmtlog", interface)

_log = nil
