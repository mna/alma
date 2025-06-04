local M
return function(Z)
  if M ~= nil then
    error('alma.type-classes.Function required more than once')
  end
  M = { }
  M.identity = function(x)
    return x
  end
  M.id = function()
    return M.identity
  end
  M.compose = function(self, other)
    return function(x)
      return other(self(x))
    end
  end
  M.equals = function(self, other)
    return other == self
  end
  return M
end
