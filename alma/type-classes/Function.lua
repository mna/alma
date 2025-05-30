local M = { }
M.identity = function(x)
  return x
end
M.id = function()
  return M.identity
end
return M
