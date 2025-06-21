local M = { }
M.iteration_next = function(x)
  return {
    value = x,
    done = false
  }
end
M.iteration_done = function(x)
  return {
    value = x,
    done = true
  }
end
return M
