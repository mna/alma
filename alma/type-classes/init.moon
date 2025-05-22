Array__all = (a, p) ->
	for _, v in ipairs(a)
		if not p(v)
			return false
	true

TypeClass__metatable = {'@@type': 'alma.type-classes/TypeClass@1'}

M = {}

M.TypeClass = (name, url, dependencies, test) ->
	setmetatable({
		name: name,
		url: url,
		test: (x) -> Array__all(dependencies, (d) -> d.test(x)) and test(x),
	}, TypeClass__metatable)

M
