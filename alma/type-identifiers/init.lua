local identifier_of
identifier_of = function(x)
  local meta = getmetatable((x))
  return (meta ~= nil and (type((meta['@@type']))) == 'string') and meta['@@type'] or type((x))
end
local parse_identifier
parse_identifier = function(s)
  local last_slash = string.find(s, "/[^/]*$")
  local namespace, name, version
  if last_slash then
    local before, after = string.sub(s, 1, last_slash - 1), string.sub(s, last_slash + 1)
    if before == "" or after == "" then
      namespace, name, version = nil, s, 0
    else
      local at_position, version_string = string.match(after, "()@([%d]+)$", 2)
      if not version_string then
        namespace, name, version = before, after, 0
      else
        namespace, name, version = before, string.sub(after, 1, at_position - 1), tonumber(version_string)
      end
    end
  else
    namespace, name, version = nil, s, 0
  end
  return {
    namespace = namespace,
    name = name,
    version = version
  }
end
return {
  identifier_of = identifier_of,
  parse_identifier = parse_identifier
}
