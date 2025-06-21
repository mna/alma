inspect = require 'inspect'
_ = inspect -- don't complain if unused
math = require 'math'

{:spec_for} = require 'spec.helpers.type_class'
{:Array, :Callable, :StrMap} = require 'alma.type-classes'
{:Useless} = require 'alma.useless'

callable = setmetatable({}, {__call: -> true})

ones = {1}
table.insert(ones, ones)
ones_ = {1}
table.insert(ones_, {1, ones_})

zero = {z: 0}
one = {z: 1}
zero.a = one
one.a = zero

describe 'TypeClass', ->
	local TypeClass, identifier_of

	setup ->
		{:TypeClass} = require 'alma.type-classes'
		{:identifier_of} = require 'alma.type-identifiers'

	it 'is a function', ->
		assert.is_function(TypeClass)

	it 'behaves as expected', ->
		has_method = (name) -> (x) -> x != nil and type(x[name]) == 'function'

		Foo = TypeClass('my-package/Foo', 'http://example.com/my-package#Foo',
			{}, has_method('foo'))

		Bar = TypeClass('my-package/Bar', 'http://example.com/my-package#Bar',
			{Foo}, has_method('bar'))

		assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Foo))
		assert.are.equal('my-package/Foo', Foo.name)
		assert.are.equal('http://example.com/my-package#Foo', Foo.url)
		assert.is_false(Foo.test(nil))
		assert.is_false(Foo.test({}))
		assert.is_true(Foo.test({foo: ->}))
		assert.is_false(Foo.test({bar: ->}))
		assert.is_true(Foo.test({foo: ->, bar: ->}))
		assert.is_false(Foo.test({foo: 'not a func'}))

		assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Bar))
		assert.are.equal('my-package/Bar', Bar.name)
		assert.are.equal('http://example.com/my-package#Bar', Bar.url)
		assert.is_false(Bar.test(nil))
		assert.is_false(Bar.test({}))
		assert.is_false(Bar.test({foo: ->}))
		assert.is_false(Bar.test({bar: ->}))
		assert.is_true(Bar.test({foo: ->, bar: ->}))
		assert.is_false(Bar.test({foo: ->, bar: 'not a func'}))

spec_for('Setoid', {
		{want: true, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: true, value: ''},
		{want: true, value: 0},
		{want: true, value: true},
		{want: true, value: {}},
		{want: true, value: {a:1}},
		{want: true, value: Array()},
		{want: true, value: StrMap()},
		{want: true, value: math.abs},
		{want: true, value: callable}, -- is an empty table
		{want: true, value: Callable(callable)},
		{want: true, value: {->}},
		{want: true, value: {a:->}},
		{want: false, value: Useless},
		{want: false, value: {Useless}},
		{want: false, value: {foo: Useless}},
	})

spec_for('Ord', {
		{want: true, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: true, value: ''},
		{want: true, value: 0},
		{want: true, value: true},
		{want: true, value: {}},
		{want: true, value: {a:1}},
		{want: true, value: Array()},
		{want: true, value: StrMap()},
		{want: false, value: math.abs},
		{want: true, value: callable}, -- is an empty table
		{want: false, value: Callable(callable)},
		{want: false, value: {->}},
		{want: false, value: {a:->}},
	})

spec_for('Semigroupoid', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: false, value: {}},
		{want: false, value: {a:1}},
		{want: false, value: Array()},
		{want: false, value: StrMap()},
		{want: true, value: math.abs},
		{want: false, value: callable},
		{want: true, value: Callable(callable)},
	})

spec_for('Category', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: false, value: {}},
		{want: false, value: {a:1}},
		{want: false, value: Array()},
		{want: false, value: StrMap()},
		{want: true, value: math.abs},
		{want: false, value: callable},
		{want: true, value: Callable(callable)},
	})

spec_for('Semigroup', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: true, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: true, value: {}},
		{want: true, value: {a:1}},
		{want: true, value: Array()},
		{want: true, value: StrMap()},
		{want: false, value: math.abs},
		{want: true, value: callable},
		{want: false, value: Callable(callable)},
	})

spec_for('Monoid', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: true, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: true, value: {}},
		{want: true, value: {a:1}},
		{want: true, value: Array()},
		{want: true, value: StrMap()},
		{want: false, value: math.abs},
		{want: true, value: callable},
		{want: false, value: Callable(callable)},
	})

spec_for('Group', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: false, value: {}},
		{want: false, value: {a:1}},
		{want: false, value: Array()},
		{want: false, value: StrMap()},
		{want: false, value: math.abs},
		{want: false, value: callable},
		{want: false, value: Callable(callable)},

		-- TODO: implement a custom type that satisfies Group (Sum in sanctuary)
	})

spec_for('Filterable', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: true, value: {}},
		{want: true, value: {a:1}},
		{want: true, value: Array()},
		{want: true, value: StrMap()},
		{want: false, value: math.abs},
		{want: true, value: callable},
		{want: false, value: Callable(callable)},
	})

spec_for('Functor', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: true, value: {}},
		{want: true, value: {a:1}},
		{want: true, value: Array()},
		{want: true, value: StrMap()},
		{want: true, value: math.abs},
		{want: true, value: callable},
		{want: true, value: Callable(callable)},
	})

spec_for('Bifunctor', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: false, value: {}},
		{want: false, value: {a:1}},
		{want: false, value: Array()},
		{want: false, value: StrMap()},
		{want: false, value: math.abs},
		{want: false, value: callable},
		{want: false, value: Callable(callable)},

		-- TODO: add test for Pair once implemented, which is a bifunctor
	})

spec_for('Profunctor', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: false, value: {}},
		{want: false, value: {a:1}},
		{want: false, value: Array()},
		{want: false, value: StrMap()},
		{want: true, value: math.abs},
		{want: false, value: callable},
		{want: true, value: Callable(callable)},
	})

spec_for('Apply', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: true, value: {}},
		{want: true, value: {a:1}},
		{want: true, value: Array()},
		{want: true, value: StrMap()},
		{want: true, value: math.abs},
		{want: true, value: callable},
		{want: true, value: Callable(callable)},
	})

spec_for('Applicative', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: true, value: {}},
		{want: false, value: {a:1}},
		{want: true, value: Array()},
		{want: false, value: StrMap()},
		{want: true, value: math.abs},
		{want: true, value: callable},
		{want: true, value: Callable(callable)},
	})

spec_for('Chain', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: true, value: {}},
		{want: false, value: {a:1}},
		{want: true, value: Array()},
		{want: false, value: StrMap()},
		{want: true, value: math.abs},
		{want: true, value: callable},
		{want: true, value: Callable(callable)},
	})

spec_for('ChainRec', {
		{want: false, value: nil},
		{want: false, value: io.stdout},
		{want: false, value: coroutine.create(->)},
		{want: false, value: ''},
		{want: false, value: 0},
		{want: false, value: true},
		{want: true, value: {}},
		{want: false, value: {a:1}},
		{want: true, value: Array()},
		{want: false, value: StrMap()},
		{want: true, value: math.abs},
		{want: true, value: callable},
		{want: true, value: Callable(callable)},
	})

describe 'equals', ->
	local Z

	setup ->
		Z = require 'alma.type-classes'

	it 'behaves as expected', ->
		node1 = {id: 1, rels: {}}
		node2 = {id: 2, rels: {}}
		table.insert(node1.rels, {type: 'child', value: node2})
		table.insert(node2.rels, {type: 'parent', value: node1})

		cases = {
			{want: true, v1: nil, v2: nil},

			{want: true, v1: false, v2: false},
			{want: false, v1: false, v2: true},
			{want: true, v1: true, v2: true},
			{want: false, v1: true, v2: false},

			{want: true, v1: 0, v2: 0},
			{want: true, v1: 0, v2: -0},
			{want: true, v1: -0, v2: 0},
			{want: true, v1: -0, v2: -0},
			{want: true, v1: 0/0, v2: 0/0}, -- NaN
			{want: true, v1: 1/0, v2: 1/0}, -- inf
			{want: false, v1: 1/0, v2: -1/0},
			{want: false, v1: -1/0, v2: 1/0},
			{want: true, v1: -1/0, v2: -1/0},
			{want: false, v1: 0/0, v2: math.pi},
			{want: false, v1: math.pi, v2: 0/0},

			{want: true, v1: '', v2: ''},
			{want: true, v1: 'abC', v2: 'abC'},
			{want: false, v1: 'abC', v2: 'xyZ'},

			{want: true, v1: {}, v2: {}},
			{want: true, v1: Z.Array({}), v2: Z.Array({})},
			{want: true, v1: {}, v2: Z.Array({})},
			{want: true, v1: Z.Array({}), v2: {}},
			{want: true, v1: {'a'}, v2: {'a'}},
			{want: true, v1: {'a', 'b'}, v2: {'a', 'b'}},
			{want: false, v1: {1, 2, 3}, v2: {1, 2}},
			{want: false, v1: {1, 2}, v2: {1, 2, 3}},
			{want: false, v1: {1, 2}, v2: {2, 1}},
			{want: true, v1: {0}, v2: {-0}},
			{want: true, v1: {0/0}, v2: {0/0}},
			{want: true, v1: ones, v2: ones},
			{want: false, v1: ones, v2: {1, {1, {1, {1, {}}}}}},
			{want: false, v1: ones, v2: {1, {1, {1, {1, {0, ones}}}}}},
			{want: true, v1: ones, v2: {1, {1, {1, {1, {1, ones}}}}}},
			{want: true, v1: ones, v2: ones_},
			{want: true, v1: ones_, v2: ones},

			{want: true, v1: Z.StrMap({}), v2: Z.StrMap({})},
			{want: true, v1: Z.StrMap({}), v2: {}}, -- empty array and empty object are undistinguishable
			{want: true, v1: {}, v2: Z.StrMap({})},
			{want: true, v1: Z.Array({}), v2: Z.StrMap({})},
			{want: true, v1: Z.StrMap({}), v2: Z.Array({})},
			{want: true, v1: {x: 1, y: 2}, v2: {y: 2, x: 1}},
			{want: false, v1: {x: 1, y: 2, z: 3}, v2: {y: 2, x: 1}},
			{want: false, v1: {x: 1, y: 2}, v2: {z: 3, y: 2, x: 1}},
			{want: false, v1: {x: 1, y: 2}, v2: {x: 2, y: 1}},
			{want: true, v1: {x: 0}, v2: {x: -0}},
			{want: true, v1: {x: 0/0}, v2: {x: 0/0}},
			{want: true, v1: node1, v2: node1},
			{want: true, v1: node2, v2: node2},
			{want: false, v1: node1, v2: node2},
			{want: false, v1: node2, v2: node1},
			{want: true, v1: zero, v2: zero},
			{want: false, v1: zero, v2: one},
			{want: false, v1: one, v2: zero},
			{want: true, v1: one, v2: one},

			{want: true, v1: math.sin, v2: math.sin},
			{want: false, v1: math.sin, v2: math.cos},

			-- TODO: add cases for Maybe, Identity, other custom types
			-- TODO: add property based testing?
		}
		for _, c in ipairs(cases)
			got = Z.equals(c.v1, c.v2)
			assert.are.equal(c.want, got, "values: #{inspect(c.v1)}, #{inspect(c.v2)}")

describe 'lte', ->
	local Z

	setup ->
		Z = require 'alma.type-classes'

	it 'behaves as expected', ->
		cases = {
			{want: true, v1: nil, v2: nil},

			{want: true, v1: false, v2: false},
			{want: true, v1: false, v2: true},
			{want: true, v1: true, v2: true},
			{want: false, v1: true, v2: false},

			{want: true, v1: 42, v2: 42},
			{want: true, v1: 42, v2: 43},
			{want: false, v1: 43, v2: 42},
			{want: true, v1: 0, v2: 0},
			{want: true, v1: 0, v2: -0},
			{want: true, v1: -0, v2: 0},
			{want: true, v1: -0, v2: -0},
			{want: true, v1: 0/0, v2: 0/0},
			{want: true, v1: 1/0, v2: 1/0},
			{want: false, v1: 1/0, v2: -1/0},
			{want: true, v1: -1/0, v2: 1/0},
			{want: true, v1: -1/0, v2: -1/0},
			{want: true, v1: 0/0, v2: math.pi},
			{want: false, v1: math.pi, v2: 0/0},

			{want: true, v1: '', v2: ''},
			{want: true, v1: 'abc', v2: 'abc'},
			{want: true, v1: 'abc', v2: 'xyz'},
			{want: false, v1: 'xyz', v2: 'abc'},

			{want: true, v1: {}, v2: {}},
			{want: true, v1: {1, 2}, v2: {1, 2}},
			{want: false, v1: {1, 2, 3}, v2: {1, 2}},
			{want: true, v1: {1, 2}, v2: {1, 2, 3}},
			{want: true, v1: {1, 2}, v2: {2}},
			{want: true, v1: {0}, v2: {-0}},
			{want: true, v1: {0/0}, v2: {0/0}},
			{want: true, v1: ones, v2: ones},

			{want: false, v1: ones, v2: {1, {1, {1, {1, {}}}}}},
			{want: false, v1: ones, v2: {1, {1, {1, {0, ones}}}}},
			{want: true, v1: ones, v2: {1, {1, {1, {1, ones}}}}},
			{want: true, v1: ones, v2: ones_},
			{want: true, v1: ones_, v2: ones},

			{want: true, v1: Z.StrMap({}), v2: Z.StrMap({})},
			{want: true, v1: Z.StrMap({}), v2: {}}, -- empty array and empty object are undistinguishable
			{want: true, v1: {}, v2: Z.StrMap({})},
			{want: true, v1: Z.Array({}), v2: Z.StrMap({})},
			{want: true, v1: Z.StrMap({}), v2: Z.Array({})},
			{want: true, v1: {a: 0}, v2: {z: 0}},
			{want: false, v1: {z: 0}, v2: {a: 0}},
			{want: true, v1: {x: 1, y: 2}, v2: {y: 2, x: 1}},
			{want: false, v1: {x: 1, y: 2, z: 3}, v2: {y: 2, x: 1}},
			{want: true, v1: {x: 1, y: 2}, v2: {z: 3, y: 2, x: 1}},
			{want: true, v1: {x: 1, y: 1}, v2: {y: 1, x: 2}},
			{want: false, v1: {x: 2, y: 1}, v2: {y: 2, x: 1}},
			{want: true, v1: {x: 0, y: 0}, v2: {x: 1}},
			{want: true, v1: {x: 0}, v2: {x: 0, y: 0}},
			{want: false, v1: {x: 0, y: 0}, v2: {x: 0}},
			{want: true, v1: {x: -0}, v2: {x: 0}},
			{want: true, v1: {x: 0}, v2: {x: -0}},
			{want: true, v1: {x: 0/0}, v2: {x: 0/0}},

			{want: true, v1: zero, v2: zero},
			{want: false, v1: zero, v2: one},
			{want: false, v1: one, v2: zero},

			-- TODO: add cases for Maybe, Identity, other custom types
			-- TODO: add property based testing?
		}
		for _, c in ipairs(cases)
			got = Z.lte(c.v1, c.v2)
			assert.are.equal(c.want, got, "values: #{inspect(c.v1)}, #{inspect(c.v2)}")
