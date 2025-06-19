local M
return function(Z)
  if M ~= nil then
    error('alma.type-classes.Array required more than once')
  end
  M = { }
  M.metatable = { }
  M.Array = function(a)
    return setmetatable(a or { }, M.metatable)
  end
  M.all = function(a, p)
    for _, v in ipairs(a) do
      if not (p(v)) then
        return false
      end
    end
    return true
  end
  M.some = function(a, p)
    for _, v in ipairs(a) do
      if p(v) then
        return true
      end
    end
    return false
  end
  M.filter = function(a, p)
    local r = M.Array()
    for _, v in ipairs(a) do
      if p(v) then
        table.insert(r, v)
      end
    end
    return r
  end
  M.each = function(a, f)
    for _, v in ipairs(a) do
      f(v)
    end
  end
  M.empty = function()
    return M.Array({ })
  end
  M.of = function(x)
    return M.Array({
      x
    })
  end
  M.zero = function()
    return M.Array({ })
  end
  M.equals = function(self, other)
    if #other ~= #self then
      return false
    end
    for i = 1, #self do
      if not Z.equals(self[i], other[i]) then
        return false
      end
    end
    return true
  end
  M.lte = function(self, other)
    for i = 1, #self do
      if i > #other then
        return false
      end
      if not Z.equals(self[i], other[i]) then
        return Z.lte(self[i], other[i])
      end
    end
    return true
  end
  M.concat = function(self, other)
    local r = M.Array()
    for _, v in ipairs(self) do
      table.insert(r, v)
    end
    for _, v in ipairs(other) do
      table.insert(r, v)
    end
    return r
  end
  M.map = function(f)
    local r = M.Array()
    for _, v in ipairs(self) do
      table.insert(r, (f(v)))
    end
    return r
  end
  M.ap = function(self, fs)
    local r = M.Array()
    for _, f in ipairs(fs) do
      for _, v in ipairs(self) do
        table.insert(r, f(v))
      end
    end
    return r
  end
  return M
end
