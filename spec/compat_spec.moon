inspect = require 'inspect'

describe 'math_type', ->
	local math_type
	setup ->
		{:math_type} = require 'alma.compat'

	it 'is nil for nil', ->
		assert.is_nil math_type(nil)

	it 'is integer for 0', ->
		assert.equal 'integer', math_type(0)

	it 'is integer for 1', ->
		assert.equal 'integer', math_type(1)

	it 'is integer for -1', ->
		assert.equal 'integer', math_type(-1)

	it 'is integer for 123', ->
		assert.equal 'integer', math_type(123)

	it 'is integer for -456', ->
		assert.equal 'integer', math_type(-456)

	it 'is float for 1.1', ->
		assert.equal 'float', math_type(1.1)

	it 'is float for -1.1', ->
		assert.equal 'float', math_type(-1.1)

	it 'is float for 3.1415', ->
		assert.equal 'float', math_type(3.1415)

	it 'is float for -3.567', ->
		assert.equal 'float', math_type(-3.567)
