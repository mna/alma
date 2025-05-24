-- Array helper functions.
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

-- Type metatables
TypeClass__metatable = {'@@type': 'alma.type-classes/TypeClass@1'}
Array__metatable = {'@@type': 'alma.type-classes/Array@1'}
StrMap__metatable = {'@@type': 'alma.type-classes/StrMap@1'}

static_method = (name, implementations, type_rep) ->
	
  -- const staticMethod = (name, implementations, typeRep) => {
  --   switch (typeRep) {
  --     case String: return implementations.String;
  --     case Array: return implementations.Array;
  --     case Object: return implementations.Object;
  --     case Function: return implementations.Function;
  --   }
  --
  --   const prefixedName = 'fantasy-land/' + name;
  --   if (typeof typeRep[prefixedName] === 'function') {
  --     return typeRep[prefixedName];
  --   }
  --
	--   -- this is because e.g. Function.name == 'Function', and if the constructor
	--   -- is not from the same VM, it will not match the first type switch above.
  --   switch (typeRep.name) {
  --     case 'String': return implementations.String;
  --     case 'Array': return implementations.Array;
  --     case 'Object': return implementations.Object;
  --     case 'Function': return implementations.Function;
  --   }
  -- };

-- Exported module
M = {}

M.TypeClass = (name, url, dependencies, test) ->
	setmetatable({
		name: name,
		url: url,
		test: (x) -> Array__all(dependencies, (d) -> d.test(x)) and test(x),
	}, TypeClass__metatable)

-- Because Lua uses the same table data structure for arrays and objects, alma
-- provides the Array and StrMap functions to create arrays and objects
-- (StrMap, that is objects with string keys) with the correct metatables so
-- they are recognized as such by the type class system, even when empty.
M.Array = (a) ->
	setmetatable(a or {}, Array__metatable)

M.StrMap = (o) ->
	setmetatable(o or {}, StrMap__metatable)

TypeClass__factory = (name, dependencies, requirements) ->
	version = '0.1.0' -- updated via publish script

	static_methods = Array__filter(requirements, (req) -> req.location == Constructor)
	metatable_methods = Array__filter(requirements, (req) -> req.location == Value)

	type_class = M.TypeClass(
		"alma.type-classes/#{name}",
		"https://github.com/mna/alma/tree/v#{version}/alma/type-classes##{name}",
		dependencies,

M
