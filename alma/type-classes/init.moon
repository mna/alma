Array__all = (a, p) ->
	for _, v in ipairs(a)
		if not p(v)
			return false
	true

Array__filter = (a, p) ->
	r = {}
	for _, v in ipairs(a)
		table.insert(r, v) if p(v)
	r

-- Location data type = Constructor | Value
Constructor = 'Constructor'
Value = 'Value'

TypeClass__metatable = {'@@type': 'alma.type-classes/TypeClass@1'}

-- Exported module
M = {}

M.TypeClass = (name, url, dependencies, test) ->
	setmetatable({
		name: name,
		url: url,
		test: (x) -> Array__all(dependencies, (d) -> d.test(x)) and test(x),
	}, TypeClass__metatable)

TypeClass__factory = (name, dependencies, requirements) ->
	version = '0.1.0' -- updated via publish script

	static_methods = Array__filter(requirements, (req) -> req.location == Constructor)
	metatable_methods = Array__filter(requirements, (req) -> req.location == Value)

	type_class = M.TypeClass(
		"alma.type-classes/#{name}",
		"https://github.com/mna/alma/tree/v#{version}/alma/type-classes##{name}",
		dependencies,

M
