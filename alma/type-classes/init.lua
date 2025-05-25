local is_callable
is_callable = require('alma.meta').is_callable
local Array__all
Array__all = function(a, p)
  for _, v in ipairs(a) do
    if not p(v) then
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
local Constructor = 'Constructor'
local Value = 'Value'
local TypeClass__metatable = {
  ['@@type'] = 'alma.type-classes/TypeClass@1'
}
local Array__metatable = {
  ['@@type'] = 'alma.type-classes/Array@1'
}
local StrMap__metatable = {
  ['@@type'] = 'alma.type-classes/StrMap@1'
}
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
  if meta.is_callable(type_rep[prefixed_name]) then
    return type_rep[prefixed_name]
  end
end
local M = {
  ArrayType = ArrayType,
  StrMapType = StrMapType,
  StringType = StringType,
  FunctionType = FunctionType
}
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
  local type_class = M.TypeClass("alma.type-classes/" .. tostring(name), "https://github.com/mna/alma/tree/v" .. tostring(version) .. "/alma/type-classes#" .. tostring(name), dependencies, function() end)
end
return M
