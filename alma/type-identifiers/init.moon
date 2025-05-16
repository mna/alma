identifier_of = (x) ->
	meta = getmetatable (x)
	(meta != nil and (type (meta['@@type'])) == 'string') and
		meta['@@type'] or
		type (x)


{:identifier_of}
