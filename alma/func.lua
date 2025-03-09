local _module_0 = { }
local is_callable, type
do
	local _obj_0 = require('alma.types')
	is_callable, type = _obj_0.is_callable, _obj_0.type
end
local map
map = function(d, fn)
	local m = getmetatable(d)
	if not (m and is_callable(m.__map)) then
		local t1, t2 = type(d)
		error("value of type " .. tostring(t1) .. tostring(t2 and ' (' .. t2 .. ')' or '') .. " does not support the map operation")
	end
	return m.__map(d, fn)
end
_module_0["map"] = map
return _module_0
