local io = require('io')
local inspect = require('inspect')
local is_callable, type
do
	local _obj_0 = require('alma.types')
	is_callable, type = _obj_0.is_callable, _obj_0.type
end
local Iter
do
	local _obj_0 = require('alma.iter')
	Iter = _obj_0.Iter
end
do
	describe('is_callable', function()
		it('is false for nil', function()
			return assert.is_false(is_callable(nil))
		end)
		it('is false for bool', function()
			return assert.is_false(is_callable(true))
		end)
		it('is false for number', function()
			return assert.is_false(is_callable(1))
		end)
		it('is false for string', function()
			return assert.is_false(is_callable('abc'))
		end)
		it('is true for function', function()
			return assert.is_true(is_callable(function() end))
		end)
		it('is false for table', function()
			return assert.is_false(is_callable({ }))
		end)
		it('is true for table with fn call', function()
			local t = setmetatable({
				other = 'ok'
			}, {
				__call = function() end
			})
			return assert.is_true(is_callable(t))
		end)
		it('is false for table with string call', function()
			local t = setmetatable({
				other = 'ok'
			}, {
				__call = 'nope'
			})
			return assert.is_false(is_callable(t))
		end)
		it('is false for table with table call', function()
			local t = setmetatable({
				other = 'ok'
			}, {
				__call = { }
			})
			return assert.is_false(is_callable(t))
		end)
		return it('is true for table with callable table call', function()
			local t = setmetatable({
				other = 'ok'
			}, {
				__call = setmetatable({ }, {
					__call = function() end
				})
			})
			return assert.is_true(is_callable(t))
		end)
	end)
end
do
	return describe('type', function()
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
		local cases = {
			{
				val = nil,
				want = {
					'nil'
				}
			},
			{
				val = true,
				want = {
					'boolean'
				}
			},
			{
				val = false,
				want = {
					'boolean'
				}
			},
			{
				val = 1.1,
				want = {
					'number',
					'float'
				}
			},
			{
				val = 2,
				want = {
					'number',
					'integer'
				}
			},
			{
				val = 0,
				want = {
					'number',
					'integer'
				}
			},
			{
				val = -2,
				want = {
					'number',
					'integer'
				}
			},
			{
				val = -3.1415,
				want = {
					'number',
					'float'
				}
			},
			{
				val = 'abc',
				want = {
					'string'
				}
			},
			{
				val = (function() end),
				want = {
					'function'
				}
			},
			{
				val = coroutine.create(function() end),
				want = {
					'thread'
				}
			},
			{
				val = { },
				want = {
					'table'
				}
			},
			{
				val = io.output(),
				want = {
					'userdata',
					'file'
				}
			},
			{
				val = Iter.of({ }, 1, 2),
				want = {
					'table',
					'Iter'
				}
			},
			{
				val = User,
				want = {
					'table',
					'class User'
				}
			},
			{
				val = User(),
				want = {
					'table',
					'instance User'
				}
			}
		}
		for _index_0 = 1, #cases do
			local c = cases[_index_0]
			it("works for " .. tostring(c.val), function()
				local t1, t2 = type(c.val)
				assert.equal(c.want[1], t1)
				return assert.equal(c.want[2], t2)
			end)
		end
	end)
end
