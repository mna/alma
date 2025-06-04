local M
return function(Z)
  if M ~= nil then
    error('alma.type-classes.Boolean required more than once')
  end
  M = { }
  M.equals = function(self, other)
    return self == other
  end
  return M
end
