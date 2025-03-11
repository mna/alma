local _module_0 = { }
local Result
local Ok, Err = 0, -1
Result = {
	__name = 'Result',
	__call = function(self, default)
		return or_else(self, default)
	end,
	or_else = function(self, default)
		return Result.is_err(self) and default or self[1]
	end,
	is_ok = function(self)
		return self.tag == Ok
	end,
	is_err = function(self)
		return self.tag == Err
	end,
	flatten = function(self)
		if Result.is_ok(self) and getmetatable(self[1]) == Result then
			return self[1]
		else
			return self
		end
	end,
	ok = function(v)
		local t = {
			v,
			tag = Ok
		}
		setmetatable(t, Result)
		return t
	end,
	err = function(v)
		local t = {
			v,
			tag = Err
		}
		setmetatable(t, Result)
		return t
	end
}
_module_0["Result"] = Result
return _module_0
