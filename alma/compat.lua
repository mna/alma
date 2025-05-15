local table = require('table')
local math = require('math')
local pack
pack = function(...)
  local n = select('#', ...)
  local t = {
    ...
  }
  t.n = n
  return t
end
local mtype
mtype = function(n)
  if not (type(n) == 'number') then
    return nil
  end
  if math.floor(n) == n then
    return 'integer'
  else
    return 'float'
  end
end
return {
  table_unpack = _G.unpack or table.unpack,
  table_pack = table.pack or pack,
  math_type = math.type or mtype
}
