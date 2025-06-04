local M
return function(Z)
  if M ~= nil then
    error('alma.type-classes.String required more than once')
  end
  M = { }
  M.empty = function()
    return ''
  end
  M.equals = function(self, other)
    return self == other
  end
  M.lte = function(self, other)
    return self <= other
  end
  M.concat = function(self, other)
    return self .. other
  end
  return M
end
