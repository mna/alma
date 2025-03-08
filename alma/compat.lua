local _module_0 = { }
local table = require('table')
local pack
pack = function(...)
	local n = select('#', ...)
	local t = {
		...
	}
	t.n = n
	return t
end
local table_unpack = _G.unpack or table.unpack
_module_0["table_unpack"] = table_unpack
local table_pack = table.pack or pack
_module_0["table_pack"] = table_pack
return _module_0
