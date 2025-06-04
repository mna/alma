local assert = require('luassert')
local inspect = require('inspect')
local _ = inspect
local math = require('math')
describe('TypeClass', function()
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
describe('Setoid', function()
  local Setoid, Array, Callable, StrMap, identifier_of, Useless
  setup(function()
    do
      local _obj_0 = require('alma.type-classes')
      Array, Callable, Setoid, StrMap = _obj_0.Array, _obj_0.Callable, _obj_0.Setoid, _obj_0.StrMap
    end
    identifier_of = require('alma.type-identifiers').identifier_of
    Useless = require('alma.useless').Useless
  end)
  it('is a TypeClass', function()
    return assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Setoid))
  end)
  it('has the expected name', function()
    return assert.are.equal('alma.type-classes/Setoid', Setoid.name)
  end)
  it('has the expected url', function()
    return assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Setoid", Setoid.url)
  end)
  return it('accepts expected values', function()
    local callable = setmetatable({ }, {
      __call = function()
        return true
      end
    })
    local cases = {
      {
        want = true,
        value = nil
      },
      {
        want = false,
        value = io.stdout
      },
      {
        want = false,
        value = coroutine.create(function() end)
      },
      {
        want = true,
        value = ''
      },
      {
        want = true,
        value = 0
      },
      {
        want = true,
        value = true
      },
      {
        want = true,
        value = { }
      },
      {
        want = true,
        value = {
          a = 1
        }
      },
      {
        want = true,
        value = Array()
      },
      {
        want = true,
        value = StrMap()
      },
      {
        want = true,
        value = math.abs
      },
      {
        want = true,
        value = callable
      },
      {
        want = true,
        value = Callable(callable)
      },
      {
        want = true,
        value = {
          function() end
        }
      },
      {
        want = true,
        value = {
          a = function() end
        }
      },
      {
        want = false,
        value = Useless
      },
      {
        want = false,
        value = {
          Useless
        }
      },
      {
        want = false,
        value = {
          foo = Useless
        }
      }
    }
    for _, c in ipairs(cases) do
      local got = Setoid.test(c.value)
      assert.are.equal(c.want, got, "tested value: " .. tostring(inspect(c.value)))
    end
  end)
end)
describe('Ord', function()
  local Ord, Array, Callable, StrMap, identifier_of
  setup(function()
    do
      local _obj_0 = require('alma.type-classes')
      Array, Callable, Ord, StrMap = _obj_0.Array, _obj_0.Callable, _obj_0.Ord, _obj_0.StrMap
    end
    identifier_of = require('alma.type-identifiers').identifier_of
  end)
  it('is a TypeClass', function()
    return assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Ord))
  end)
  it('has the expected name', function()
    return assert.are.equal('alma.type-classes/Ord', Ord.name)
  end)
  it('has the expected url', function()
    return assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Ord", Ord.url)
  end)
  return it('accepts expected values', function()
    local callable = setmetatable({ }, {
      __call = function()
        return true
      end
    })
    local cases = {
      {
        want = true,
        value = nil
      },
      {
        want = false,
        value = io.stdout
      },
      {
        want = false,
        value = coroutine.create(function() end)
      },
      {
        want = true,
        value = ''
      },
      {
        want = true,
        value = 0
      },
      {
        want = true,
        value = true
      },
      {
        want = true,
        value = { }
      },
      {
        want = true,
        value = {
          a = 1
        }
      },
      {
        want = true,
        value = Array()
      },
      {
        want = true,
        value = StrMap()
      },
      {
        want = false,
        value = math.abs
      },
      {
        want = true,
        value = callable
      },
      {
        want = false,
        value = Callable(callable)
      },
      {
        want = false,
        value = {
          function() end
        }
      },
      {
        want = false,
        value = {
          a = function() end
        }
      }
    }
    for _, c in ipairs(cases) do
      local got = Ord.test(c.value)
      assert.are.equal(c.want, got, "tested value: " .. tostring(inspect(c.value)))
    end
  end)
end)
describe('Semigroupoid', function()
  local Semigroupoid, Array, Callable, StrMap, identifier_of
  setup(function()
    do
      local _obj_0 = require('alma.type-classes')
      Array, Callable, Semigroupoid, StrMap = _obj_0.Array, _obj_0.Callable, _obj_0.Semigroupoid, _obj_0.StrMap
    end
    identifier_of = require('alma.type-identifiers').identifier_of
  end)
  it('is a TypeClass', function()
    return assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Semigroupoid))
  end)
  it('has the expected name', function()
    return assert.are.equal('alma.type-classes/Semigroupoid', Semigroupoid.name)
  end)
  it('has the expected url', function()
    return assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Semigroupoid", Semigroupoid.url)
  end)
  return it('accepts expected values', function()
    local callable = setmetatable({ }, {
      __call = function()
        return true
      end
    })
    local cases = {
      {
        want = false,
        value = nil
      },
      {
        want = false,
        value = io.stdout
      },
      {
        want = false,
        value = coroutine.create(function() end)
      },
      {
        want = false,
        value = ''
      },
      {
        want = false,
        value = 0
      },
      {
        want = false,
        value = true
      },
      {
        want = false,
        value = { }
      },
      {
        want = false,
        value = {
          a = 1
        }
      },
      {
        want = false,
        value = Array()
      },
      {
        want = false,
        value = StrMap()
      },
      {
        want = true,
        value = math.abs
      },
      {
        want = false,
        value = callable
      },
      {
        want = true,
        value = Callable(callable)
      }
    }
    for _, c in ipairs(cases) do
      local got = Semigroupoid.test(c.value)
      assert.are.equal(c.want, got, "tested value: " .. tostring(inspect(c.value)))
    end
  end)
end)
return describe('Category', function()
  local Category, Array, Callable, StrMap, identifier_of
  setup(function()
    do
      local _obj_0 = require('alma.type-classes')
      Array, Callable, Category, StrMap = _obj_0.Array, _obj_0.Callable, _obj_0.Category, _obj_0.StrMap
    end
    identifier_of = require('alma.type-identifiers').identifier_of
  end)
  it('is a TypeClass', function()
    return assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(Category))
  end)
  it('has the expected name', function()
    return assert.are.equal('alma.type-classes/Category', Category.name)
  end)
  it('has the expected url', function()
    return assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#Category", Category.url)
  end)
  return it('accepts expected values', function()
    local callable = setmetatable({ }, {
      __call = function()
        return true
      end
    })
    local cases = {
      {
        want = false,
        value = nil
      },
      {
        want = false,
        value = io.stdout
      },
      {
        want = false,
        value = coroutine.create(function() end)
      },
      {
        want = false,
        value = ''
      },
      {
        want = false,
        value = 0
      },
      {
        want = false,
        value = true
      },
      {
        want = false,
        value = { }
      },
      {
        want = false,
        value = {
          a = 1
        }
      },
      {
        want = false,
        value = Array()
      },
      {
        want = false,
        value = StrMap()
      },
      {
        want = true,
        value = math.abs
      },
      {
        want = false,
        value = callable
      },
      {
        want = true,
        value = Callable(callable)
      }
    }
    for _, c in ipairs(cases) do
      local got = Category.test(c.value)
      assert.are.equal(c.want, got, "tested value: " .. tostring(inspect(c.value)))
    end
  end)
end)
