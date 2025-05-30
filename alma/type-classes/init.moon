{:is_callable, :get_metavalue} = require 'alma.meta'

-- Array helper functions.
Array__all = (a, p) ->
	for _, v in ipairs(a)
		return false unless p(v)
	true

Array__filter = (a, p) ->
	r = {}
	for _, v in ipairs(a)
		table.insert(r, v) if p(v)
	r

Array__each = (a, f) ->
	for _, v in ipairs(a)
		f(v)

-- Location data type = Constructor | Value
Constructor = 'Constructor'
Value = 'Value'

-- Type metatables
TypeClass__metatable = {'@@type': 'alma.type-classes/TypeClass@1'}
Array__metatable = {'@@type': 'alma.type-classes/Array@1'}
StrMap__metatable = {'@@type': 'alma.type-classes/StrMap@1'}

ArrayType = {name: 'Array'}
StrMapType = {name: 'StrMap'}
StringType = {name: 'String'}
FunctionType = {name: 'Function'}

-- Exported module
M = {:ArrayType, :StrMapType, :StringType, :FunctionType}

-- finds the proper implementation of a static method for a given type
-- representative; name must be the (unprefixed) name of the fantasy land
-- method, implementations the list of available implementations, and type_rep
-- is either the metatable of the value, or a alma.type-classes type
-- representative for one of the built-in types.
static_method = (name, implementations, type_rep) ->
	switch type_rep
		when ArrayType
			return implementations.Array
		when StrMapType
			return implementations.StrMap
		when StringType
			return implementations.String
		when FunctionType
			return implementations.Function

	prefixed_name = 'fantasy-land/' .. name
	if is_callable(type_rep[prefixed_name])
		return type_rep[prefixed_name]

builtin_metatable_method = (implementations, value) ->
	switch type(value)
		when 'nil'
			return implementations.Nil
		when 'number'
			return implementations.Number
		when 'string'
			return implementations.String
		when 'boolean'
			return implementations.Boolean
		when 'function'
			return implementations.Function
		when 'table'
			switch getmetatable(value)
				when Array__metatable then return implementations.Array
				when StrMap__metatable then return implementations.StrMap
				else
					-- TODO: if empty or # > 0, default to array
					nil

has_metatable_method = (name, implementations, value) ->
	return implementations.Nil if value == nil

	prefixed_name = 'fantasy-land/' .. name
	return true if get_metavalue(value, prefixed_name, is_callable)

	switch name
		when 'equals'
			-- each element in array or object must be a Setoid
			nil
		when 'lte'
			-- each element in array or object must be an Ord
			nil

	builtin_metatable_method(implementations, value) != nil
 
  -- const hasPrototypeMethod = (name, implementations, value) => {
  --   switch (value) {
  --     case null: return implementations.Null != null;
  --     case undefined: return implementations.Undefined != null;
  --   }
  --
  --   const prefixedName = 'fantasy-land/' + name;
  --   const isPrototype = value.constructor == null ||
  --                       value.constructor.prototype !== value;
  --   if (isPrototype && typeof value[prefixedName] === 'function') {
  --     return true;
  --   }
  --
  --   if (typeof value['@@type'] === 'string') return false;
  --
  --   if (name === 'equals') {
  --     if (value.constructor === Array || type (value) === 'Array') {
  --       return value.every (Z.Setoid.test);
  --     }
  --
  --     if (value.constructor === Object || type (value) === 'Object') {
  --       return (Object.values (value)).every (Z.Setoid.test);
  --     }
  --   }
  --
  --   if (name === 'lte') {
  --     if (value.constructor === Array || type (value) === 'Array') {
  --       return value.every (Z.Ord.test);
  --     }
  --
  --     if (value.constructor === Object || type (value) === 'Object') {
  --       return (Object.values (value)).every (Z.Ord.test);
  --     }
  --   }
  --
  --   return customPrototypeMethod (implementations, value) != null;
  -- };
  --

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

-- TypeClass__factory is used internally by this module to define type classes
-- with similar boilerplate.
TypeClass__factory = (name, dependencies, requirements) ->
	version = '0.1.0' -- updated via publish script

	static_methods = Array__filter(requirements, (req) -> req.location == Constructor)
	metatable_methods = Array__filter(requirements, (req) -> req.location == Value)

	type_class_test = (seen) -> (x) ->
		-- we use memoization because the test function can be called from within
		-- itself when looking for instance methods (e.g. 'equals' on an Array
		-- checks for each element in the array, and the same element could appear
		-- multiple times). We use a table to keep track of seen values, we don't
		-- need to worry about nil values being significant (nil is special-cased
		-- in the instance methods lookup).
		return true if seen[x]

		seen[x] = true
		ok, err_or_result = pcall(
			->
				Array__all(static_methods, (sm) ->
					x != nil and
					static_method(sm.name, sm.implementations, getmetatable(x)) != nil
				) and
				Array__all(metatable_methods, (mm) ->
					has_metatable_method(mm.name, mm.implementations, x)
				)
		)

		seen[x] = nil
		error(err_or_result) unless ok
		err_or_result

	type_class = M.TypeClass("alma.type-classes/#{name}",
		"https://github.com/mna/alma/tree/v#{version}/alma/type-classes##{name}",
		dependencies,
		type_class_test({})
	)

	type_class.methods = {}

	Array__each(static_methods, (sm) ->
		{:arity, :implementations, :name} = sm
		type_class.methods[name] = switch arity
			when 0
				(type_rep) -> (static_method(name, implementations, type_rep)())
			when 1
				(type_rep, a) -> (static_method(name, implementations, type_rep)(a))
			else
				(type_rep, a, b) -> (static_method(name, implementations, type_rep)(a, b))
	)

	Array__each(metatable_methods, (mm) ->
		{:arity, :implementations, :name} = mm
		type_class.methods[name] = switch arity
			when 0
				nil
			when 1
				nil
			else
				nil
	)

	-- prototypeMethods.forEach (({name, arity, implementations}) => {
	--   typeClass.methods[name] = (
	--     arity === 0 ? context => (
	--       (prototypeMethod (name, implementations, context)).call (context)
	--     ) :
	--     arity === 1 ? (a, context) => (
	--       (prototypeMethod (name, implementations, context)).call (context, a)
	--     ) :
	--     (a, b, context) => (
	--       (prototypeMethod (name, implementations, context))
	--       .call (context, a, b)
	--     )
	--   );
	-- });
	--
	-- return typeClass;

M
