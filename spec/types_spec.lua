local is_callable, type
do
	local _obj_0 = require('alma.types')
	is_callable, type = _obj_0.is_callable, _obj_0.type
end
do
	return describe('is_callable', function()
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
