local debug = require('debug')
local string = require('string')
local table = require('table')
local meta = require('alma.meta')
local math_type, pointer_hex
do
  local _obj_0 = require('alma.compat')
  math_type, pointer_hex = _obj_0.math_type, _obj_0.pointer_hex
end
local show_detect_circular
show_detect_circular = function(x, seen)
  if x == nil then
    return 'nil'
  end
  do
    local metafn = meta.get_metavalue(x, '@@show', meta.is_callable)
    if metafn then
      return metafn(x)
    end
  end
  if seen[x] then
    return '<circular>'
  end
  local _exp_0 = type(x)
  if 'boolean' == _exp_0 then
    return x and 'true' or 'false'
  elseif 'number' == _exp_0 then
    if math_type(x) == 'integer' then
      return string.format('%d', x)
    else
      return string.format('%.10g', x)
    end
  elseif 'string' == _exp_0 then
    return string.format('%q', x)
  elseif 'table' == _exp_0 then
    seen[x] = true
    local array_up_to = 0
    local parts = {
      "{"
    }
    for i, v in ipairs(x) do
      if i > 1 then
        table.insert(parts, ', ')
      end
      array_up_to = i
      table.insert(parts, show_detect_circular(v, seen))
    end
    local needs_comma = array_up_to > 0
    local key_vals = { }
    for k, v in pairs(x) do
      local _continue_0 = false
      repeat
        if math_type(k) == 'integer' and k > 0 and k <= array_up_to then
          _continue_0 = true
          break
        end
        table.insert(key_vals, string.format('[%s] = %s', show_detect_circular(k, seen), show_detect_circular(v, seen)))
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
    if #key_vals > 0 then
      table.sort(key_vals)
      if needs_comma then
        table.insert(parts, ', ')
      end
      table.insert(parts, table.concat(key_vals, ', '))
    end
    table.insert(parts, "}")
    seen[x] = nil
    return table.concat(parts)
  elseif 'function' == _exp_0 then
    local finfo = debug.getinfo(x)
    local parts = {
      "function " .. tostring(finfo.name or '') .. "("
    }
    for i = 1, finfo.nparams do
      if i > 1 then
        table.insert(parts, ', ')
      end
      table.insert(parts, string.format('arg%d', i))
    end
    if finfo.isvararg then
      if finfo.nparams > 0 then
        table.insert(parts, ', ')
      end
      table.insert(parts, '...')
    end
    table.insert(parts, ')\n')
    table.insert(parts, string.format("  -- %s function (%s)\n", finfo.what, pointer_hex(x)))
    if finfo.linedefined > 0 then
      table.insert(parts, string.format('  -- at %s:%d\n', finfo.short_src, finfo.linedefined))
    end
    table.insert(parts, "end")
    return table.concat(parts)
  elseif 'thread' == _exp_0 then
    return "<thread " .. tostring(string.format('%s', pointer_hex(x))) .. ">"
  elseif 'userdata' == _exp_0 then
    return "<userdata " .. tostring(string.format('%s', pointer_hex(x))) .. ">"
  else
    return "<unknown type: " .. tostring(type(x)) .. ">"
  end
end
local show
show = function(x)
  return show_detect_circular(x, { })
end
return {
  show = show
}
