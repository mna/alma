assert = require 'luassert'
inspect = require 'inspect'
_ = inspect -- don't complain if unused

describe 'table_pack, table_unpack', ->
	local table_pack, table_unpack
	setup ->
		{:table_pack, :table_unpack} = require 'alma.compat'

	it 'is empty for no argument', ->
		t = table_pack!
		assert.are.same {n: 0}, t
		a = table_unpack t, 1, t.n
		assert.is_nil a

	it 'is as expected for one non-nil argument', ->
		t = table_pack 1
		assert.are.same {n: 1, [1]: 1}, t
		a, b = table_unpack t, 1, t.n
		assert.are.equal 1, a
		assert.is_nil b

	it 'is as expected for two non-nil arguments', ->
		t = table_pack 1, 'b'
		assert.are.same {n: 2, [1]: 1, [2]: 'b'}, t
		a, b, c = table_unpack t, 1, t.n
		assert.are.equal 1, a
		assert.are.equal 'b', b
		assert.is_nil c

	it 'is as expected for three non-nil arguments', ->
		t = table_pack 1, 'b', true
		assert.are.same {n: 3, [1]: 1, [2]: 'b', [3]: true}, t
		a, b, c, d = table_unpack t, 1, t.n
		assert.are.equal 1, a
		assert.are.equal 'b', b
		assert.is_true c
		assert.is_nil d

	it 'identifies the single value even if it is nil', ->
		t = table_pack nil
		assert.are.same {n: 1, [1]: nil}, t
		a, b = table_unpack t, 1, t.n
		assert.is_nil a
		assert.is_nil b

	it 'identifies all values even if it has nils', ->
		t = table_pack 'a', nil, 'c', nil, nil, 'f', nil
		assert.are.same {n: 7, [1]: 'a', [3]: 'c', [6]: 'f'}, t
		a, b, c, d, e, f, g = table_unpack t, 1, t.n
		assert.are.equal 'a', a
		assert.is_nil b
		assert.are.equal 'c', c
		assert.is_nil d
		assert.is_nil e
		assert.are.equal 'f', f
		assert.is_nil g

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
