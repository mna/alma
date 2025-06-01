local M
return function(Z)
  if M ~= nil then
    error('alma.type-classes.Array required more than once')
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
  return M
end
