local M = { }
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
