local is_callable, get_metavalue
do
  local _obj_0 = require('alma.meta')
  is_callable, get_metavalue = _obj_0.is_callable, _obj_0.get_metavalue
end
local Function = require('alma.type-classes.Function')
local TypeClass__metatable = {
  ['@@type'] = 'alma.type-classes/TypeClass@1'
}
local Array__metatable = {
  ['@@type'] = 'alma.type-classes/Array@1'
}
local StrMap__metatable = {
  ['@@type'] = 'alma.type-classes/StrMap@1'
}
local Array__all
Array__all = function(a, p)
  for _, v in ipairs(a) do
    if not (p(v)) then
      return false
    end
  end
  return true
end
local Array__filter
Array__filter = function(a, p)
  local r = { }
  for _, v in ipairs(a) do
    if p(v) then
      table.insert(r, v)
    end
  end
  return r
end
local Array__each
Array__each = function(a, f)
  for _, v in ipairs(a) do
    f(v)
  end
end
local is_table_array
is_table_array = function(t)
  local _exp_0 = getmetatable(t)
  if Array__metatable == _exp_0 then
    return true
  elseif StrMap__metatable == _exp_0 then
    return false
  else
    return (#t > 0) or (next(t) == nil)
  end
end
local StrMap__all_values
StrMap__all_values = function(o, p)
  for _, v in pairs(o) do
    if not (p(v)) then
      return false
    end
  end
  return true
end
local Constructor = 'Constructor'
local Value = 'Value'
local ArrayType = {
  name = 'Array'
}
local StrMapType = {
  name = 'StrMap'
}
local StringType = {
  name = 'String'
}
local FunctionType = {
  name = 'Function'
}
local M = {
  ArrayType = ArrayType,
  StrMapType = StrMapType,
  StringType = StringType,
  FunctionType = FunctionType
}
local static_method
static_method = function(name, implementations, type_rep)
  local _exp_0 = type_rep
  if ArrayType == _exp_0 then
    return implementations.Array
  elseif StrMapType == _exp_0 then
    return implementations.StrMap
  elseif StringType == _exp_0 then
    return implementations.String
  elseif FunctionType == _exp_0 then
    return implementations.Function
  end
  local prefixed_name = 'fantasy-land/' .. name
  if is_callable(type_rep[prefixed_name]) then
    return type_rep[prefixed_name]
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
  local _exp_0 = name
  if 'equals' == _exp_0 then
    if type(value) == 'table' then
      if is_table_array(value) then
        return Array__all(value, M.Setoid.test)
      else
        return StrMap__all_values(value, M.Setoid.test)
      end
    end
  elseif 'lte' == _exp_0 then
    if type(value) == 'table' then
      if is_table_array(value) then
        return Array__all(value, M.Ord.test)
      else
        return StrMap__all_values(value, M.Ord.test)
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
      return Array__all(dependencies, function(d)
        return d.test(x)
      end) and test(x)
    end
  }, TypeClass__metatable)
end
M.Array = function(a)
  return setmetatable(a or { }, Array__metatable)
end
M.StrMap = function(o)
  return setmetatable(o or { }, StrMap__metatable)
end
local TypeClass__factory
TypeClass__factory = function(name, dependencies, requirements)
  local version = '0.1.0'
  local static_methods = Array__filter(requirements, function(req)
    return req.location == Constructor
  end)
  local metatable_methods = Array__filter(requirements, function(req)
    return req.location == Value
  end)
  local type_class_test
  type_class_test = function(seen)
    return function(x)
      if seen[x] then
        return true
      end
      seen[x] = true
      local ok, err_or_result = pcall(function()
        return Array__all(static_methods, function(sm)
          return x ~= nil and static_method(sm.name, sm.implementations, getmetatable(x)) ~= nil
        end) and Array__all(metatable_methods, function(mm)
          return has_metatable_method(mm.name, mm.implementations, x)
        end)
      end)
      seen[x] = nil
      if not (ok) then
        error(err_or_result)
      end
      return err_or_result
    end
  end
  local type_class = M.TypeClass("alma.type-classes/" .. tostring(name), "https://github.com/mna/alma/tree/v" .. tostring(version) .. "/alma/type-classes#" .. tostring(name), dependencies, type_class_test({ }))
  type_class.methods = { }
  Array__each(static_methods, function(sm)
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
  Array__each(metatable_methods, function(mm)
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
return M
