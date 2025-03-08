local inspect = require('inspect')
local step, Iter
do
	local _obj_0 = require('alma.iter')
	step, Iter = _obj_0.step, _obj_0.Iter
end
local map
do
	local _obj_0 = require('alma.func')
	map = _obj_0.map
end
do
	return describe('Iter', function()
		do
			describe('__call can be used in generic for', function()
				it('works on ipairs', function()
					local ar = {
						1,
						2,
						3
					}
					local iter = Iter.of(ipairs(ar))
					local got = { }
					for i, v in iter() do
						got[i] = v
					end
					return assert.are.same(ar, got)
				end)
				it('works on pairs', function()
					local o = {
						a = 1,
						b = true,
						c = { }
					}
					local iter = Iter.of(pairs(o))
					local got = { }
					for k, v in iter() do
						got[k] = v
					end
					return assert.are.same(o, got)
				end)
				it('works on empty table', function()
					local o = { }
					local iter = Iter.of(pairs(o))
					local got = { }
					for k, v in iter() do
						got[k] = v
					end
					return assert.are.same(o, got)
				end)
				it('works on gmatch', function()
					local s = 'hello yue!'
					local iter = Iter.of(string.gmatch(s, '%a'))
					local got = { }
					for ch in iter() do
						got[#got + 1] = ch
					end
					return assert.are.same({
						'h',
						'e',
						'l',
						'l',
						'o',
						'y',
						'u',
						'e'
					}, got)
				end)
				return it('does not consume the Iter', function()
					local o = {
						1,
						2,
						3
					}
					local iter = Iter.of(ipairs(o))
					local got = { }
					for k, v in iter() do
						got[k] = v
					end
					assert.are.same(o, got)
					got = { }
					for k, v in iter() do
						got[k] = v
					end
					assert.are.same(o, got)
					local k, v = step(iter)
					return assert.are.same({
						[1] = 1
					}, {
						[k] = v
					})
				end)
			end)
		end
		do
			describe('step consumes the iterator one step at a time', function()
				it('always returns nil on empty table', function()
					local o = { }
					local iter = Iter.of(pairs(o))
					local v = step(iter)
					assert.is_nil(v)
					v = step(iter)
					return assert.is_nil(v)
				end)
				it('returns all expected values of array', function()
					local o = {
						1,
						2,
						3
					}
					local iter = Iter.of(ipairs(o))
					local i, v = step(iter)
					assert.are.same({
						[1] = 1
					}, {
						[i] = v
					})
					i, v = step(iter)
					assert.are.same({
						[2] = 2
					}, {
						[i] = v
					})
					i, v = step(iter)
					assert.are.same({
						[3] = 3
					}, {
						[i] = v
					})
					i, v = step(iter)
					assert.is_nil(i)
					return assert.is_nil(v)
				end)
				it('returns all expected values of object', function()
					local o = {
						a = true,
						b = 123,
						c = { }
					}
					local iter = Iter.of(pairs(o))
					local got = { }
					while true do
						local k, v = step(iter)
						if k == nil then
							break
						end
						got[k] = v
					end
					assert.are.same(o, got)
					local k, v = step(iter)
					return assert.is_string(k)
				end)
				it('raises an error when called with unsupported value', function()
					local s = 'abc'
					return assert.error_matches((function()
						return step(s)
					end), 'value of type string does not support the step operation')
				end)
				return it('raises an error with subtype when called with unsupported value', function()
					local User
					do
						local _class_0
						local _base_0 = { }
						if _base_0.__index == nil then
							_base_0.__index = _base_0
						end
						_class_0 = setmetatable({
							__init = function() end,
							__base = _base_0,
							__name = "User"
						}, {
							__index = _base_0,
							__call = function(cls, ...)
								local _self_0 = setmetatable({ }, _base_0)
								cls.__init(_self_0, ...)
								return _self_0
							end
						})
						_base_0.__class = _class_0
						User = _class_0
					end
					local v = User()
					return assert.error_matches((function()
						return step(v)
					end), 'value of type table %(instance User%) does not support the step operation')
				end)
			end)
		end
		do
			return describe('map returns an iterator that applies the transformation', function()
				it('double simple array values', function()
					local o = {
						1,
						2,
						3
					}
					local iter = Iter.of(ipairs(o))
					local iter2 = map(iter, function(i, v)
						return i, v * 2
					end)
					local got = { }
					for i, v in iter2() do
						got[i] = v
					end
					assert.are.same({
						2,
						4,
						6
					}, got)
					got = { }
					for i, v in iter() do
						got[i] = v
					end
					return assert.are.same({
						1,
						2,
						3
					}, got)
				end)
				it('no-op on empty table', function()
					local o = { }
					local iter = Iter.of(ipairs(o))
					local iter2 = map(iter, function(i, v)
						return i, v * 2
					end)
					local i, v = step(iter2)
					assert.is_nil(i)
					return assert.is_nil(v)
				end)
				return it('can modify and swap values', function()
					local o = {
						1,
						2,
						3
					}
					local iter = Iter.of(ipairs(o))
					local iter2 = map(iter, function(i, v)
						return string.char(64 + i)
					end)
					local v1, v2 = step(iter2)
					assert.equal('A', v1)
					assert.is_nil(v2)
					v1, v2 = step(iter2)
					assert.equal('B', v1)
					assert.is_nil(v2)
					v1, v2 = step(iter2)
					assert.equal('C', v1)
					assert.is_nil(v2)
					v1, v2 = step(iter2)
					assert.is_nil(v1)
					return assert.is_nil(v2)
				end)
			end)
		end
	end)
end
