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
  M.map = function(f)
    return function(x)
      return f(self(x))
    end
  end
  M.promap = function(self, f, g)
    return function(x)
      return g(self(f(x)))
    end
  end
  M.ap = function(self, f)
    return function(x)
      return f(x)(self(x))
    end
  end
  M.of = function(x)
    return function()
      return x
    end
  end
  M.chain = function(self, f)
    return function(x)
      return f(self(x))(x)
    end
  end
  return M
end
