local get_metavalue
get_metavalue = function(x, field, predicate)
  local meta = getmetatable(x)
  return (meta ~= nil and predicate(meta[field])) and meta[field] or nil
end
return {
  get_metavalue = get_metavalue
}
