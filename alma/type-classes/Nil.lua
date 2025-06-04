local M
return function(Z)
  if M ~= nil then
    error('alma.type-classes.Nil required more than once')
  end
  M = { }
  M.equals = function(self, other)
    return true
  end
  M.lte = function(self, other)
    return true
  end
  return M
end
