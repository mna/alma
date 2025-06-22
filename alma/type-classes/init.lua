local table = require('table')
local is_callable, get_metavalue
do
  local _obj_0 = require('alma.meta')
  is_callable, get_metavalue = _obj_0.is_callable, _obj_0.get_metavalue
end
local M = { }
local Array = require('alma.type-classes.Array')(M)
local Boolean = require('alma.type-classes.Boolean')(M)
local Function = require('alma.type-classes.Function')(M)
local Nil = require('alma.type-classes.Nil')(M)
local Number = require('alma.type-classes.Number')(M)
local String = require('alma.type-classes.String')(M)
local StrMap = require('alma.type-classes.StrMap')(M)
local TypeClass__metatable = {
  ['@@type'] = 'alma.type-classes/TypeClass@1'
}
local is_table_array
is_table_array = function(t)
  local _exp_0 = getmetatable(t)
  if Array.metatable == _exp_0 then
    return true
  elseif StrMap.metatable == _exp_0 then
    return false
  else
    return (#t > 0) or (next(t) == nil)
  end
end
local Constructor = 'Constructor'
local Value = 'Value'
M.ArrayType = {
  name = 'Array'
}
M.StrMapType = {
  name = 'StrMap'
}
M.StringType = {
  name = 'String'
}
M.FunctionType = {
  name = 'Function'
}
M.Array = Array.Array
M.StrMap = StrMap.StrMap
local value_to_static_builtin_type
value_to_static_builtin_type = function(value)
  local _exp_0 = type(value)
  if 'string' == _exp_0 then
    return M.StringType
  elseif 'function' == _exp_0 then
    return M.FunctionType
  elseif 'table' == _exp_0 then
    if is_table_array(value) then
      return M.ArrayType
    else
      return M.StrMapType
    end
  end
end
local static_method
static_method = function(name, implementations, type_rep, builtin_type)
  local prefixed_name = 'fantasy-land/' .. name
  local impl
  if type_rep ~= nil and is_callable(type_rep[prefixed_name]) then
    impl = type_rep[prefixed_name]
  end
  local _exp_0 = builtin_type ~= nil and builtin_type or type_rep
  if M.ArrayType == _exp_0 then
    if impl then
      return impl
    end
    return implementations.Array
  elseif M.StrMapType == _exp_0 then
    if impl then
      return impl
    end
    return implementations.StrMap
  elseif M.StringType == _exp_0 then
    if impl then
      return impl
    end
    return implementations.String
  elseif M.FunctionType == _exp_0 then
    if impl then
      return impl
    end
    return implementations.Function
  else
    return impl
  end
end
local builtin_metatable_method
builtin_metatable_method = function(implementations, value)
  local _exp_0 = type(value)
  if 'nil' == _exp_0 then
    return implementations.Nil
  elseif 'number' == _exp_0 then
    return implementations.Number
  elseif 'string' == _exp_0 then
    return implementations.String
  elseif 'boolean' == _exp_0 then
    return implementations.Boolean
  elseif 'function' == _exp_0 then
    return implementations.Function
  elseif 'table' == _exp_0 then
    if is_table_array(value) then
      return implementations.Array
    else
      return implementations.StrMap
    end
  end
end
local has_metatable_method
has_metatable_method = function(name, implementations, value)
  if value == nil then
    return (implementations.Nil ~= nil)
  end
  local prefixed_name = 'fantasy-land/' .. name
  if get_metavalue(value, prefixed_name, is_callable) then
    return true
  end
  if get_metavalue(value, '@@type', function(v)
    return type(v) == 'string'
  end) then
    return false
  end
  local _exp_0 = name
  if 'equals' == _exp_0 then
    if type(value) == 'table' then
      if is_table_array(value) then
        return Array.all(value, M.Setoid.test)
      else
        return StrMap.all_values(value, M.Setoid.test)
      end
    end
  elseif 'lte' == _exp_0 then
    if type(value) == 'table' then
      if is_table_array(value) then
        return Array.all(value, M.Ord.test)
      else
        return StrMap.all_values(value, M.Ord.test)
      end
    end
  end
  return builtin_metatable_method(implementations, value) ~= nil
end
local metatable_method
metatable_method = function(name, implementations, value)
  if value == nil then
    return implementations.Nil
  end
  local prefixed_name = 'fantasy-land/' .. name
  local impl = get_metavalue(value, prefixed_name, is_callable)
  if impl ~= nil then
    return impl
  end
  return builtin_metatable_method(implementations, value)
end
M.TypeClass = function(name, url, dependencies, test)
  return setmetatable({
    name = name,
    url = url,
    test = function(x)
      return Array.all(dependencies, function(d)
        return d.test(x)
      end) and test(x)
    end
  }, TypeClass__metatable)
end
M.Callable = function(c)
  return function(...)
    return c(...)
  end
end
local TypeClass__factory
TypeClass__factory = function(name, dependencies, requirements)
  local version = '0.1.0'
  local static_methods = Array.filter(requirements, function(req)
    return req.location == Constructor
  end)
  local metatable_methods = Array.filter(requirements, function(req)
    return req.location == Value
  end)
  local type_class_test
  type_class_test = function(seen)
    return function(x)
      if seen[x] then
        return true
      end
      if not (x == nil) then
        seen[x] = true
      end
      local ok, err_or_result = pcall(function()
        return Array.all(static_methods, function(sm)
          return x ~= nil and static_method(sm.name, sm.implementations, getmetatable(x), value_to_static_builtin_type(x)) ~= nil
        end) and Array.all(metatable_methods, function(mm)
          return has_metatable_method(mm.name, mm.implementations, x)
        end)
      end)
      if not (x == nil) then
        seen[x] = nil
      end
      if not (ok) then
        error(err_or_result)
      end
      return err_or_result
    end
  end
  local type_class = M.TypeClass("alma.type-classes/" .. tostring(name), "https://github.com/mna/alma/tree/v" .. tostring(version) .. "/alma/type-classes#" .. tostring(name), dependencies, type_class_test({ }))
  type_class.methods = { }
  Array.each(static_methods, function(sm)
    local arity, implementations
    arity, implementations, name = sm.arity, sm.implementations, sm.name
    local _exp_0 = arity
    if 0 == _exp_0 then
      type_class.methods[name] = function(type_rep)
        return (static_method(name, implementations, type_rep)())
      end
    elseif 1 == _exp_0 then
      type_class.methods[name] = function(type_rep, a)
        return (static_method(name, implementations, type_rep)(a))
      end
    else
      type_class.methods[name] = function(type_rep, a, b)
        return (static_method(name, implementations, type_rep)(a, b))
      end
    end
  end)
  Array.each(metatable_methods, function(mm)
    local arity, implementations
    arity, implementations, name = mm.arity, mm.implementations, mm.name
    local _exp_0 = arity
    if 0 == _exp_0 then
      type_class.methods[name] = function(context)
        return (metatable_method(name, implementations, context)(context))
      end
    elseif 1 == _exp_0 then
      type_class.methods[name] = function(a, context)
        return (metatable_method(name, implementations, context)(context, a))
      end
    else
      type_class.methods[name] = function(a, b, context)
        return (metatable_method(name, implementations, context)(context, a, b))
      end
    end
  end)
  return type_class
end
M.Setoid = TypeClass__factory('Setoid', { }, {
  {
    name = 'equals',
    location = Value,
    arity = 1,
    implementations = {
      Array = Array.equals,
      Boolean = Boolean.equals,
      Function = Function.equals,
      Nil = Nil.equals,
      Number = Number.equals,
      String = String.equals,
      StrMap = StrMap.equals
    }
  }
})
M.Ord = TypeClass__factory('Ord', {
  M.Setoid
}, {
  {
    name = 'lte',
    location = Value,
    arity = 1,
    implementations = {
      Array = Array.lte,
      Boolean = Boolean.lte,
      Nil = Nil.lte,
      Number = Number.lte,
      String = String.lte,
      StrMap = StrMap.lte
    }
  }
})
M.Semigroupoid = TypeClass__factory('Semigroupoid', { }, {
  {
    name = 'compose',
    location = Value,
    arity = 1,
    implementations = {
      Function = Function.compose
    }
  }
})
M.Category = TypeClass__factory('Category', {
  M.Semigroupoid
}, {
  {
    name = 'id',
    location = Constructor,
    arity = 0,
    implementations = {
      Function = Function.id
    }
  }
})
M.Semigroup = TypeClass__factory('Semigroup', { }, {
  {
    name = 'concat',
    location = Value,
    arity = 1,
    implementations = {
      Array = Array.concat,
      String = String.concat,
      StrMap = StrMap.concat
    }
  }
})
M.Monoid = TypeClass__factory('Monoid', {
  M.Semigroup
}, {
  {
    name = 'empty',
    location = Constructor,
    arity = 0,
    implementations = {
      Array = Array.empty,
      String = String.empty,
      StrMap = StrMap.empty
    }
  }
})
M.Group = TypeClass__factory('Group', {
  M.Monoid
}, {
  {
    name = 'invert',
    location = Value,
    arity = 0,
    implementations = { }
  }
})
M.Filterable = TypeClass__factory('Filterable', { }, {
  {
    name = 'filter',
    location = Value,
    arity = 1,
    implementations = {
      Array = Array.filter,
      StrMap = StrMap.filter
    }
  }
})
M.Functor = TypeClass__factory('Functor', { }, {
  {
    name = 'map',
    location = Value,
    arity = 1,
    implementations = {
      Array = Array.map,
      Function = Function.map,
      StrMap = StrMap.map
    }
  }
})
M.Bifunctor = TypeClass__factory('Bifunctor', {
  M.Functor
}, {
  {
    name = 'bimap',
    location = Value,
    arity = 2,
    implementations = { }
  }
})
M.Profunctor = TypeClass__factory('Profunctor', {
  M.Functor
}, {
  {
    name = 'promap',
    location = Value,
    arity = 2,
    implementations = {
      Function = Function.promap
    }
  }
})
M.Apply = TypeClass__factory('Apply', {
  M.Functor
}, {
  {
    name = 'ap',
    location = Value,
    arity = 1,
    implementations = {
      Array = Array.ap,
      Function = Function.ap,
      StrMap = StrMap.ap
    }
  }
})
M.Applicative = TypeClass__factory('Applicative', {
  M.Apply
}, {
  {
    name = 'of',
    location = Constructor,
    arity = 1,
    implementations = {
      Array = Array.of,
      Function = Function.of
    }
  }
})
M.Chain = TypeClass__factory('Chain', {
  M.Apply
}, {
  {
    name = 'chain',
    location = Value,
    arity = 1,
    implementations = {
      Array = Array.chain,
      Function = Function.chain
    }
  }
})
M.ChainRec = TypeClass__factory('ChainRec', {
  M.Chain
}, {
  {
    name = 'chain_rec',
    location = Constructor,
    arity = 2,
    implementations = {
      Array = Array.chain_rec,
      Function = Function.chain_rec
    }
  }
})
M.Monad = TypeClass__factory('Monad', {
  M.Applicative,
  M.Chain
}, { })
M.Alt = TypeClass__factory('Alt', {
  M.Functor
}, {
  {
    name = 'alt',
    location = Value,
    arity = 1,
    implementations = {
      Array = Array.alt,
      StrMap = StrMap.alt
    }
  }
})
M.Plus = TypeClass__factory('Plus', {
  M.Alt
}, {
  {
    name = 'zero',
    location = Constructor,
    arity = 0,
    implementations = {
      Array = Array.zero,
      StrMap = StrMap.zero
    }
  }
})
M.Alternative = TypeClass__factory('Alternative', {
  M.Applicative,
  M.Plus
}, { })
M.Foldable = TypeClass__factory('Foldable', { }, {
  {
    name = 'reduce',
    location = Value,
    arity = 2,
    implementations = {
      Array = Array.reduce,
      StrMap = StrMap.reduce
    }
  }
})
M.Traversable = TypeClass__factory('Traversable', {
  M.Functor,
  M.Foldable
}, {
  {
    name = 'traverse',
    location = Value,
    arity = 2,
    implementations = {
      Array = Array.traverse,
      StrMap = StrMap.traverse
    }
  }
})
do
  local pairs = { }
  M.equals = function(x, y)
    if Array.some(pairs, function(p)
      return p[1] == x and p[2] == y
    end) then
      return true
    end
    table.insert(pairs, {
      x,
      y
    })
    local ok, err_or_result = pcall(M.Setoid.methods.equals, y, x)
    table.remove(pairs)
    if not (ok) then
      error(err_or_result)
    end
    return err_or_result
  end
end
do
  local pairs = { }
  M.lte = function(x, y)
    if Array.some(pairs, function(p)
      return p[1] == x and p[2] == y
    end) then
      return M.equals(x, y)
    end
    table.insert(pairs, {
      x,
      y
    })
    local ok, err_or_result = pcall(M.Ord.methods.lte, y, x)
    table.remove(pairs)
    if not (ok) then
      error(err_or_result)
    end
    return err_or_result
  end
end
do
  M.compose = M.Semigroupoid.methods.compose
end
do
  M.id = M.Category.methods.id
end
do
  M.concat = function(a, b)
    return M.Semigroup.methods.concat(b, a)
  end
end
do
  M.empty = M.Monoid.methods.empty
end
do
  M.invert = M.Group.methods.invert
end
do
  M.filter = M.Filterable.methods.filter
end
do
  M.map = M.Functor.methods.map
end
do
  M.bimap = M.Bifunctor.methods.bimap
end
do
  M.promap = M.Profunctor.methods.promap
end
do
  M.ap = M.Apply.methods.ap
end
do
  M.of = M.Applicative.methods.of
end
do
  M.chain = M.Chain.methods.chain
end
do
  M.chain_rec = M.ChainRec.methods.chain_rec
end
do
  M.alt = function(a, b)
    return M.Alt.methods.alt(b, a)
  end
end
do
  M.zero = M.Plus.methods.zero
end
do
  M.reduce = M.Foldable.methods.reduce
end
do
  M.traverse = M.Traversable.methods.traverse
end
return M
