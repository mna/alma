local M
local is_NaN
is_NaN = function(n)
  return n ~= n
end
return function(Z)
  if M ~= nil then
    error('alma.type-classes.Number required more than once')
  end
  M = { }
  M.equals = function(self, other)
    return (self == other) or (is_NaN(self) and is_NaN(other))
  end
  M.lte = function(self, other)
    return (is_NaN(self)) or (self <= other)
  end
  return M
end
