local _module_0 = { }
local table_pack, table_unpack
do
	local _obj_0 = require('alma.compat')
	table_pack, table_unpack = _obj_0.table_pack, _obj_0.table_unpack
end
local Tuple
Tuple = {
	__name = 'Tuple',
	__call = function(self)
		return table_unpack(self, 1, self.n)
	end,
	__map = function(self, mapfn)
		local vs = { }
		for i in 1, self.n do
			vs[i] = mapfn(self[i])
		end
		return Tuple.of(table_unpack(vs, 1, self.n))
	end,
	of = function(...)
		local t = table_pack(...)
		setmetatable(t, Tuple)
		return t
	end
}
_module_0["Tuple"] = Tuple
return _module_0
