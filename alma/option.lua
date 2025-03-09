local _module_0 = { }
local Option
Option = {
	__name = 'Option',
	__call = function(self, default)
		return or_else(self, default)
	end,
	or_else = function(opt, default)
		return opt[1] == nil and default or opt[1]
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
