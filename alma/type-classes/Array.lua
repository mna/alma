local M = { }
M.metatable = {
  ['@@type'] = 'alma.type-classes/Array@1'
}
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
return M
