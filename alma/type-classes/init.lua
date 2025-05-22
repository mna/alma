local Array__all
Array__all = function(a, p)
  for _, v in ipairs(a) do
    if not p(v) then
      return false
    end
  end
  return true
end
local TypeClass__metatable = {
  ['@@type'] = 'alma.type-classes/TypeClass@1'
}
local M = { }
M.TypeClass = function(name, url, dependencies, test)
  return setmetatable({
    name = name,
    url = url,
    test = function(x)
      return Array__all(dependencies, function(d)
        return d.test(x)
      end) and test(x)
    end
  }, TypeClass__metatable)
end
return M
