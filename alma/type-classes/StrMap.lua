local table = require('table')
local M
local sorted_keys
sorted_keys = function(o)
  local keys = { }
  for k in pairs(o) do
    table.insert(keys, k)
  end
  table.sort(keys)
  return keys
end
return function(Z)
  if M ~= nil then
    error('alma.type-classes.StrMap required more than once')
  end
  M = { }
  M.metatable = { }
  M.StrMap = function(o)
    return setmetatable(o or { }, M.metatable)
  end
  M.all_values = function(o, p)
    for _, v in pairs(o) do
      if not (p(v)) then
        return false
      end
    end
    return true
  end
  M.empty = function()
    return M.StrMap({ })
  end
  M.zero = function()
    return M.StrMap({ })
  end
  M.equals = function(self, other)
    local keys = sorted_keys(self)
    if not Z.equals(keys, sorted_keys(other)) then
      return false
    end
    for _, k in ipairs(keys) do
      if not Z.equals(self[k], other[k]) then
        return false
      end
    end
    return true
  end
  M.lte = function(self, other)
    local self_keys = sorted_keys(self)
    local other_keys = sorted_keys(other)
    while (true) do
      if #self_keys == 0 then
        return true
      end
      if #other_keys == 0 then
        return false
      end
      local k = table.remove(self_keys, 1)
      local z = table.remove(other_keys, 1)
      if k < z then
        return true
      end
      if k > z then
        return false
      end
      if not Z.equals(self[k], other[k]) then
        return Z.lte(self[k], other[k])
      end
    end
  end
  M.concat = function(self, other)
    local r = M.StrMap()
    for k, v in pairs(self) do
      r[k] = v
    end
    for k, v in pairs(other) do
      r[k] = v
    end
    return r
  end
  M.filter = function(o, pred)
    local r = M.StrMap()
    for k, v in pairs(o) do
      if pred(v) then
        r[k] = v
      end
    end
    return r
  end
  M.map = function(f)
    local r = M.StrMap()
    for k, v in pairs(self) do
      r[k] = f(v)
    end
    return r
  end
  M.ap = function(self, other)
    local r = M.StrMap()
    for k, v in pairs(self) do
      if other[k] ~= nil then
        r[k] = other[k](v)
      end
    end
    return r
  end
  M.alt = M.concat
  return M
end
