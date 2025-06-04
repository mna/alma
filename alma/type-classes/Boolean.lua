local M
return function(Z)
  if M ~= nil then
    error('alma.type-classes.Boolean required more than once')
  end
  M = { }
  M.equals = function(self, other)
    return self == other
  end
  M.lte = function(self, other)
    return (self == false) or (other == true)
  end
  return M
end
