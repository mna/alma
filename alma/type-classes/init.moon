{:is_callable, :get_metavalue} = require 'alma.meta'
Function = require 'alma.type-classes.Function'

-- Type metatables
TypeClass__metatable = {'@@type': 'alma.type-classes/TypeClass@1'}
Array__metatable = {'@@type': 'alma.type-classes/Array@1'}
StrMap__metatable = {'@@type': 'alma.type-classes/StrMap@1'}

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

is_table_array = (t) ->
	switch getmetatable(t)
		when Array__metatable
			-- explicitly an array
			true
		when StrMap__metatable
			-- explicitly a StrMap object
			false
		else
			-- empty table or non-empty array part is considered array
			(#t > 0) or (next(t) == nil)

-- StrMap helper functions.
StrMap__all_values = (o, p) ->
	for _, v in pairs(o)
		return false unless p(v)
	true

-- Location data type = Constructor | Value
Constructor = 'Constructor'
Value = 'Value'

ArrayType = {name: 'Array'}
StrMapType = {name: 'StrMap'}
StringType = {name: 'String'}
FunctionType = {name: 'Function'}

value_to_static_builtin_type = (value) ->
	switch type(value)
		when 'string'
			StringType
		when 'function'
			FunctionType
		when 'table'
			if is_table_array(value)
				ArrayType
			else
				StrMapType

-- Exported module
M = {:ArrayType, :StrMapType, :StringType, :FunctionType}

-- finds the proper implementation of a static method for a given type
-- representative; name must be the (unprefixed) name of the fantasy land
-- method, implementations the list of available implementations, and type_rep
-- is either the metatable of the value, or a alma.type-classes type
-- representative for one of the built-in types.
static_method = (name, implementations, type_rep, builtin_type) ->
	prefixed_name = 'fantasy-land/' .. name
	impl = if type_rep != nil and is_callable(type_rep[prefixed_name])
		type_rep[prefixed_name]

	return switch builtin_type != nil and builtin_type or type_rep
		when ArrayType
			return impl if impl
			implementations.Array
		when StrMapType
			return impl if impl
			implementations.StrMap
		when StringType
			return impl if impl
			implementations.String
		when FunctionType
			return impl if impl
			implementations.Function
		else
			impl


builtin_metatable_method = (implementations, value) ->
	switch type(value)
		when 'nil'
			implementations.Nil
		when 'number'
			implementations.Number
		when 'string'
			implementations.String
		when 'boolean'
			implementations.Boolean
		when 'function'
			implementations.Function
		when 'table'
			if is_table_array(value)
				implementations.Array
			else
				implementations.StrMap

has_metatable_method = (name, implementations, value) ->
	return (implementations.Nil != nil) if value == nil

	prefixed_name = 'fantasy-land/' .. name
	return true if get_metavalue(value, prefixed_name, is_callable)

	switch name
		when 'equals'
			-- each element in array or object must be a Setoid
			if type(value) == 'table'
				if is_table_array(value)
					return Array__all(value, M.Setoid.test)
				else
					return StrMap__all_values(value, M.Setoid.test)

		when 'lte'
			-- each element in array or object must be an Ord
			if type(value) == 'table'
				if is_table_array(value)
					return Array__all(value, M.Ord.test)
				else
					return StrMap__all_values(value, M.Ord.test)

	builtin_metatable_method(implementations, value) != nil

metatable_method = (name, implementations, value) ->
	return implementations.Nil if value == nil

	prefixed_name = 'fantasy-land/' .. name
	impl = get_metavalue(value, prefixed_name, is_callable)
	return impl if impl != nil

	builtin_metatable_method(implementations, value)

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

-- Callable Lua values do not satisfy the built-in Function type when testing
-- for type classes because it would be ambiguous - should a table with a
-- __call metamethod be considered a Function or an array? So we provide a
-- helper function to create a Function from a callable (it simply wraps the
-- callable function call in a function).
M.Callable = (c) -> (...) -> c(...)

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

		seen[x] = true unless x == nil
		ok, err_or_result = pcall(
			->
				Array__all(static_methods, (sm) ->
					x != nil and
					static_method(sm.name, sm.implementations, getmetatable(x), value_to_static_builtin_type(x)) != nil
				) and
				Array__all(metatable_methods, (mm) ->
					has_metatable_method(mm.name, mm.implementations, x)
				)
		)

		seen[x] = nil unless x == nil
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
				(context) -> (metatable_method(name, implementations, context)(context))
			when 1
				(a, context) -> (metatable_method(name, implementations, context)(context, a))
			else
				(a, b, context) -> (metatable_method(name, implementations, context)(context, a, b))
	)

	type_class

-- ---------------------------
-- Fantasy Land type classes
-- ---------------------------

M.Semigroupoid = TypeClass__factory('Semigroupoid', {}, {
	{
		name: 'compose',
		location: Value,
		arity: 1,
		implementations: {
			Function: Function.compose,
		},
	},
})

M.Category = TypeClass__factory('Category', {M.Semigroupoid}, {
	{
		name: 'id',
		location: Constructor,
		arity: 0,
		implementations: {
			Function: Function.id,
		},
	},
})

M
