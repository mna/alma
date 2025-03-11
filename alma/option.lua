local _module_0 = { }
local Option
Option = {
	__name = 'Option',
	__call = function(self, default)
		return or_else(self, default)
	end,
	__map = function(self, mapfn)
		if Option.is_none(self) then
			return self
		end
		return Option.of(mapfn(self[1]))
	end,
	or_else = function(self, default)
		return Option.is_none(self) and default or self[1]
	end,
	is_some = function(self)
		return not self:is_none()
	end,
	is_none = function(self)
		return self[1] == nil
	end,
	flatten = function(self)
		if getmetatable(self[1]) == Option then
			return self[1]
		else
			return self
		end
	end,
	of = function(v)
		local t = {
			v
		}
		setmetatable(t, Option)
		return t
	end
}
_module_0["Option"] = Option
return _module_0
