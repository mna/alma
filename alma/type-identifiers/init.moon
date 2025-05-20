string = require 'string'

meta = require 'alma.meta'

identifier_of = (x) ->
	meta.get_metavalue(x, '@@type', (v) -> type(v) == 'string') or
		type(x)

parse_identifier = (s) ->
	-- find last index of '/'
	last_slash = string.find(s, "/[^/]*$")

	-- if there is no '/', or no chars on both sides of it, then it is not a
	-- conforming identifier so the whole string is the name and version is 0.
	namespace, name, version = if last_slash
		before, after = string.sub(s, 1, last_slash - 1), string.sub(s, last_slash + 1)
		if before == "" or after == "" then
			nil, s, 0
		else
			-- if there is an '@' and it is followed only by a valid number, it becomes
			-- the version, otherwise the whole 'after' string is part of the name; the
			-- pattern matches at position 2 because the 'after' part must contain at
			-- least one character.
			at_position, version_string = string.match(after, "()@([%d]+)$", 2)
			if not version_string
				before, after, 0
			else
				before, string.sub(after, 1, at_position - 1), tonumber(version_string)
	else
		nil, s, 0

	{:namespace, :name, :version}


{:identifier_of, :parse_identifier}
