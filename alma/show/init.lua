local meta = require('alma.meta')
local math_type
math_type = require('alma.compat').math_type
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
    return '<Circular>'
  end
  local _exp_0 = type(x)
  if 'boolean' == _exp_0 then
    return x and 'true' or 'false'
  elseif 'number' == _exp_0 then
    return 'todo'
  else
    return 'todo'
  end
end
local show
show = function(x)
  return show_detect_circular(x, { })
end
return {
  show = show
}
