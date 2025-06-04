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
  M.metatable = {
    ['@@type'] = 'alma.type-classes/StrMap@1'
  }
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
  return M
end
