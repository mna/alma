local _module_0 = { }
local table_pack, table_unpack
do
	local _obj_0 = require('alma.compat')
	table_pack, table_unpack = _obj_0.table_pack, _obj_0.table_unpack
end
local is_callable, type
do
	local _obj_0 = require('alma.types')
	is_callable, type = _obj_0.is_callable, _obj_0.type
end
local step
step = function(v)
	local m = getmetatable(v)
	if not (m and is_callable(m.__step)) then
		local t1, t2 = type(v)
		return error("value of type " .. tostring(t1) .. tostring(t2 and ' (' .. t2 .. ')') .. " does not support the step operation")
	end
end
_module_0["step"] = step
local Iter
Iter = {
	__name = 'Iter',
	__call = function(self)
		return table_unpack(self, 1, self.n)
	end,
	__map = function(self, mapfn)
		local f = self[1]
		local ff
		ff = function(s, v)
			local vals = table_pack(f(s, v))
			local val1 = vals[1]
			if val1 == nil then
				return table_unpack(vals, 1, vals.n)
			end
			return mapfn(table_unpack(vals, 1, vals.n))
		end
		return Iter.of(ff, table_unpack(self, 2, self.n))
	end,
	__step = function(self)
		local f, s, v = self[1], self[2], self[3]
		local loop_vals = table_pack(f(s, v))
		local val1 = loop_vals[1]
		self[3] = val1
		return table_unpack(loop_vals, 1, loop_vals.n)
	end,
	of = function(...)
		local t = table_pack(...)
		setmetatable(t, Iter)
		return t
	end
}
_module_0["Iter"] = Iter
return _module_0
