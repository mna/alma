identifier_of = (x) ->
	meta = getmetatable (x)
	(meta != nil and (type (meta['@@type'])) == 'string') and
		meta['@@type'] or
		type (x)

parse_identifier = (s) ->
	-- find last index of '/'
	last_slash = string.find (s, "/[^/]*$")

	-- if there is no '/', or no chars on either side of it, then it is not a
	-- conforming identifier so the whole string is the name and version is 0.
	namespace, name, version = if last_slash
		before, after = string.sub (s, 1, last_slash - 1), string.sub (s, last_slash + 1)
		if before == "" or after == "" then
			nil, s, 0

		-- if there is an '@' and it is followed only by a valid number, it becomes
		-- the version, otherwise the whole 'after' string is part of the name.
		last_at = string.find (after, "@[^@]*$")
	else
		nil, s, 0


{:identifier_of}
