local inspect = require('inspect')
local step, Iter
do
	local _obj_0 = require('alma.iter')
	step, Iter = _obj_0.step, _obj_0.Iter
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
			describe('step consumes the iterator one step at a time', function() end)
		end
		do
			return describe('map returns an iterator that applies the transformation', function() end)
		end
	end)
end
