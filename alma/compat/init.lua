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
    if string.find(string.format('%f', n), 'inf') then
      return 'float'
    else
      return 'integer'
    end
  else
    return 'float'
  end
end
local pointer_hex
pointer_hex = function(v)
  local s = tostring(v)
  local hex = string.match(s, '0x%x+')
  return hex or ''
end
return {
  table_unpack = _G.unpack or table.unpack,
  table_pack = table.pack or pack,
  math_type = math.type or mtype,
  pointer_hex = pointer_hex
}
