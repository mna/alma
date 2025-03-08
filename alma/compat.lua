local _module_0 = { }
local table = require('table')
local math = require('math')
local pack
pack = function(...)
	local n = select('#', ...)
	local t = {
		...
	}
	t.n = n
	return t
end
local mtype
mtype = function(n)
	if not (type(n) == 'number') then
		return nil
	end
	if math.floor(n) == n then
		return 'integer'
	else
		return 'float'
	end
end
local table_unpack = _G.unpack or table.unpack
_module_0["table_unpack"] = table_unpack
local table_pack = table.pack or pack
_module_0["table_pack"] = table_pack
local math_type = math.type or mtype
_module_0["math_type"] = math_type
return _module_0
