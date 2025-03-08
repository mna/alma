local _module_0 = { }
local io = require('io')
local math_type
do
	local _obj_0 = require('alma.compat')
	math_type = _obj_0.math_type
end
local is_callable
is_callable = function(v)
	if type(v) == 'function' then
		return true
	end
	if not v then
		return false
	end
	local m = getmetatable(v)
	if m then
		local call = m.__call
		return is_callable(call)
	else
		return false
	end
end
_module_0["is_callable"] = is_callable
local gtype = _G.type
local type
type = function(v)
	local t1 = gtype(v)
	local t2
	if t1 == 'number' then
		t2 = math_type(v)
	else
		t2 = io.type(v)
	end
	if t1 == 'table' and not t2 then
		do
			local m = getmetatable(v)
			if m and m.__name then
				t2 = m.__name
			else
				if m and m.__class then
					t2 = 'instance ' .. m.__class.__name
				else
					if v.__name then
						t2 = 'class ' .. v.__name
					end
				end
			end
		end
	end
	return t1, t2
end
_module_0["type"] = type
return _module_0
