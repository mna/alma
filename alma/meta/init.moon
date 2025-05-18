-- returns x's metatable field value if it exists and satisfies the predicate,
-- otherwise returns nil.
get_metavalue = (x, field, predicate) ->
	meta = getmetatable(x)
	(meta != nil and predicate(meta[field])) and
		meta[field] or nil

is_callable = (v) ->
	type(v) == 'function' or
		(meta.get_metavalue(v, '__call', is_callable)) != nil

{:get_metavalue, :is_callable}
