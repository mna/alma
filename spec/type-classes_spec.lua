local assert = require('luassert')
local inspect = require('inspect')
local _ = inspect
return describe('TypeClass', function()
  local TypeClass, identifier_of
  setup(function()
    TypeClass = require('alma.type-classes').TypeClass
    identifier_of = require('alma.type-identifiers').identifier_of
  end)
  it('is a function', function()
    return assert.is_function(TypeClass)
  end)
  return it('behaves as expected', function()
    local has_method
    has_method = function(name)
      return function(x)
        return x ~= nil and type(x[name]) == 'function'
      end
    end
    local Foo = TypeClass('my-package/Foo', 'http://example.com/my-package#Foo', { }, has_method('foo'))
    local Bar = TypeClass('my-package/Bar', 'http://example.com/my-package#Bar', {
      Foo
    }, has_method('bar'))
    assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Foo))
    assert.are.equal('my-package/Foo', Foo.name)
    assert.are.equal('http://example.com/my-package#Foo', Foo.url)
    assert.is_false(Foo.test(nil))
    assert.is_false(Foo.test({ }))
    assert.is_true(Foo.test({
      foo = function() end
    }))
    assert.is_false(Foo.test({
      bar = function() end
    }))
    assert.is_true(Foo.test({
      foo = function() end,
      bar = function() end
    }))
    assert.is_false(Foo.test({
      foo = 'not a func'
    }))
    assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Bar))
    assert.are.equal('my-package/Bar', Bar.name)
    assert.are.equal('http://example.com/my-package#Bar', Bar.url)
    assert.is_false(Bar.test(nil))
    assert.is_false(Bar.test({ }))
    assert.is_false(Bar.test({
      foo = function() end
    }))
    assert.is_false(Bar.test({
      bar = function() end
    }))
    assert.is_true(Bar.test({
      foo = function() end,
      bar = function() end
    }))
    return assert.is_false(Bar.test({
      foo = function() end,
      bar = 'not a func'
    }))
  end)
end)
