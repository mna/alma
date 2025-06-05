assert = require 'luassert'
inspect = require 'inspect'
_ = inspect -- don't complain if unused
math = require 'math'

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

describe 'Setoid', ->
	local Setoid, Array, Callable, StrMap, identifier_of, Useless

	setup ->
		{:Array, :Callable, :Setoid, :StrMap} = require 'alma.type-classes'
		{:identifier_of} = require 'alma.type-identifiers'
		{:Useless} = require 'alma.useless'

	it 'is a TypeClass', ->
		assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Setoid))

	it 'has the expected name', ->
		assert.are.equal('alma.type-classes/Setoid', Setoid.name)

	it 'has the expected url', ->
		assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Setoid", Setoid.url)

	it 'accepts expected values', ->
		callable = setmetatable({}, {__call: -> true})
		cases = {
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
		}
		for _, c in ipairs(cases)
			got = Setoid.test(c.value)
			assert.are.equal(c.want, got, "tested value: #{inspect(c.value)}")

describe 'Ord', ->
	local Ord, Array, Callable, StrMap, identifier_of

	setup ->
		{:Array, :Callable, :Ord, :StrMap} = require 'alma.type-classes'
		{:identifier_of} = require 'alma.type-identifiers'

	it 'is a TypeClass', ->
		assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Ord))

	it 'has the expected name', ->
		assert.are.equal('alma.type-classes/Ord', Ord.name)

	it 'has the expected url', ->
		assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Ord", Ord.url)

	it 'accepts expected values', ->
		callable = setmetatable({}, {__call: -> true})
		cases = {
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
		}
		for _, c in ipairs(cases)
			got = Ord.test(c.value)
			assert.are.equal(c.want, got, "tested value: #{inspect(c.value)}")

describe 'Semigroupoid', ->
	local Semigroupoid, Array, Callable, StrMap, identifier_of

	setup ->
		{:Array, :Callable, :Semigroupoid, :StrMap} = require 'alma.type-classes'
		{:identifier_of} = require 'alma.type-identifiers'

	it 'is a TypeClass', ->
		assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Semigroupoid))

	it 'has the expected name', ->
		assert.are.equal('alma.type-classes/Semigroupoid', Semigroupoid.name)

	it 'has the expected url', ->
		assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Semigroupoid", Semigroupoid.url)

	it 'accepts expected values', ->
		callable = setmetatable({}, {__call: -> true})
		cases = {
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
		}
		for _, c in ipairs(cases)
			got = Semigroupoid.test(c.value)
			assert.are.equal(c.want, got, "tested value: #{inspect(c.value)}")

describe 'Category', ->
	local Category, Array, Callable, StrMap, identifier_of

	setup ->
		{:Array, :Callable, :Category, :StrMap} = require 'alma.type-classes'
		{:identifier_of} = require 'alma.type-identifiers'

	it 'is a TypeClass', ->
		assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Category))

	it 'has the expected name', ->
		assert.are.equal('alma.type-classes/Category', Category.name)

	it 'has the expected url', ->
		assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Category", Category.url)

	it 'accepts expected values', ->
		callable = setmetatable({}, {__call: -> true})
		cases = {
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
		}
		for _, c in ipairs(cases)
			got = Category.test(c.value)
			assert.are.equal(c.want, got, "tested value: #{inspect(c.value)}")

describe 'Semigroup', ->
	local Semigroup, Array, Callable, StrMap, identifier_of

	setup ->
		{:Array, :Callable, :Semigroup, :StrMap} = require 'alma.type-classes'
		{:identifier_of} = require 'alma.type-identifiers'

	it 'is a TypeClass', ->
		assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Semigroup))

	it 'has the expected name', ->
		assert.are.equal('alma.type-classes/Semigroup', Semigroup.name)

	it 'has the expected url', ->
		assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Semigroup", Semigroup.url)

	it 'accepts expected values', ->
		callable = setmetatable({}, {__call: -> true})
		cases = {
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
		}
		for _, c in ipairs(cases)
			got = Semigroup.test(c.value)
			assert.are.equal(c.want, got, "tested value: #{inspect(c.value)}")

describe 'Monoid', ->
	local Monoid, Array, Callable, StrMap, identifier_of

	setup ->
		{:Array, :Callable, :Monoid, :StrMap} = require 'alma.type-classes'
		{:identifier_of} = require 'alma.type-identifiers'

	it 'is a TypeClass', ->
		assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Monoid))

	it 'has the expected name', ->
		assert.are.equal('alma.type-classes/Monoid', Monoid.name)

	it 'has the expected url', ->
		assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Monoid", Monoid.url)

	it 'accepts expected values', ->
		callable = setmetatable({}, {__call: -> true})
		cases = {
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
		}
		for _, c in ipairs(cases)
			got = Monoid.test(c.value)
			assert.are.equal(c.want, got, "tested value: #{inspect(c.value)}")

describe 'equals', ->
	local Z

	setup ->
		Z = require 'alma.type-classes'

	it 'behaves as expected', ->
		ones = {1}
		table.insert(ones, ones)
		ones_ = {1}
		table.insert(ones_, {1, ones_})

		node1 = {id: 1, rels: {}}
		node2 = {id: 2, rels: {}}
		table.insert(node1.rels, {type: 'child', value: node2})
		table.insert(node2.rels, {type: 'parent', value: node1})

		zero = {z: 0}
		one = {z: 1}
		zero.a = one
		one.a = zero

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
		}
		for _, c in ipairs(cases)
			got = Z.lte(c.v1, c.v2)
			assert.are.equal(c.want, got, "values: #{inspect(c.v1)}, #{inspect(c.v2)}")

-- test ('lte', () => {
--   eq (Z.lte (ones, [1, [1, [1, [1, []]]]]), false);
--   eq (Z.lte (ones, [1, [1, [1, [1, [0, ones]]]]]), false);
--   eq (Z.lte (ones, [1, [1, [1, [1, [1, ones]]]]]), true);
--   eq (Z.lte (ones, ones_), true);
--   eq (Z.lte (ones_, ones), true);
--   eq (Z.lte ({}, {}), true);
--   eq (Z.lte ({a: 0}, {z: 0}), true);
--   eq (Z.lte ({z: 0}, {a: 0}), false);
--   eq (Z.lte ({x: 1, y: 2}, {y: 2, x: 1}), true);
--   eq (Z.lte ({x: 1, y: 2, z: 3}, {x: 1, y: 2}), false);
--   eq (Z.lte ({x: 1, y: 2}, {x: 1, y: 2, z: 3}), true);
--   eq (Z.lte ({x: 1, y: 1}, {x: 2, y: 1}), true);
--   eq (Z.lte ({x: 2, y: 1}, {x: 1, y: 2}), false);
--   eq (Z.lte ({x: 0, y: 0}, {x: 1}), true);
--   eq (Z.lte ({x: 0}, {x: 0, y: 0}), true);
--   eq (Z.lte ({x: -0}, {x: 0}), true);
--   eq (Z.lte ({x: 0}, {x: -0}), true);
--   eq (Z.lte ({x: NaN}, {x: NaN}), true);
--   eq (Z.lte (Identity (Identity (Identity (0))), Identity (Identity (Identity (0)))), true);
--   eq (Z.lte (Identity (Identity (Identity (0))), Identity (Identity (Identity (1)))), true);
--   eq (Z.lte (Identity (Identity (Identity (1))), Identity (Identity (Identity (0)))), false);
--   eq (Z.lte ('abc', 123), false);
--
--   const $0 = {z: 0};
--   const $1 = {z: 1};
--   $0.a = $1;
--   $1.a = $0;
--   eq (Z.lte ($0, $0), true);
--   eq (Z.lte ($0, $1), false);
--   eq (Z.lte ($1, $0), false);
-- });
