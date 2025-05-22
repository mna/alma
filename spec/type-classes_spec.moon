assert = require 'luassert'
inspect = require 'inspect'
_ = inspect -- don't complain if unused

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
