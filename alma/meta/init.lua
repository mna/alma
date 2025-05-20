local get_metavalue
get_metavalue = function(x, field, predicate)
  local meta = getmetatable(x)
  return (meta ~= nil and predicate(meta[field])) and meta[field] or nil
end
local is_callable
is_callable = function(v)
  return type(v) == 'function' or (get_metavalue(v, '__call', is_callable)) ~= nil
end
return {
  get_metavalue = get_metavalue,
  is_callable = is_callable
}
