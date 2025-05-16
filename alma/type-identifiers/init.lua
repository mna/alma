local identifier_of
identifier_of = function(x)
  local meta = getmetatable((x))
  return (meta ~= nil and (type((meta['@@type']))) == 'string') and meta['@@type'] or type((x))
end
return {
  identifier_of = identifier_of
}
