table = require 'table'
{:is_callable, :get_metavalue} = require 'alma.meta'

-- declare the module immediately to pass it to the sub-modules and break
-- circular dependencies
M = {}
Array = require('alma.type-classes.Array')(M)
Boolean = require('alma.type-classes.Boolean')(M)
Function = require('alma.type-classes.Function')(M)
Nil = require('alma.type-classes.Nil')(M)
Number = require('alma.type-classes.Number')(M)
String = require('alma.type-classes.String')(M)
StrMap = require('alma.type-classes.StrMap')(M)

TypeClass__metatable = {'@@type': 'alma.type-classes/TypeClass@1'}

is_table_array = (t) ->
	switch getmetatable(t)
		when Array.metatable
			-- explicitly an array
			true
		when StrMap.metatable
			-- explicitly a StrMap object
			false
		else
			-- empty table or non-empty array part is considered array
			(#t > 0) or (next(t) == nil)

-- Location data type = Constructor | Value
Constructor = 'Constructor'
Value = 'Value'

M.ArrayType = {name: 'Array'}
M.StrMapType = {name: 'StrMap'}
M.StringType = {name: 'String'}
M.FunctionType = {name: 'Function'}
M.Array = Array.Array
M.StrMap = StrMap.StrMap

value_to_static_builtin_type = (value) ->
	switch type(value)
		when 'string'
			M.StringType
		when 'function'
			M.FunctionType
		when 'table'
			if is_table_array(value)
				M.ArrayType
			else
				M.StrMapType

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
		when M.ArrayType
			return impl if impl
			implementations.Array
		when M.StrMapType
			return impl if impl
			implementations.StrMap
		when M.StringType
			return impl if impl
			implementations.String
		when M.FunctionType
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
	-- technically, nil value can have a metatable that could implement the
	-- fantasy-land method, but that seems more like a way to break things than
	-- anything useful.
	return (implementations.Nil != nil) if value == nil

	prefixed_name = 'fantasy-land/' .. name
	return true if get_metavalue(value, prefixed_name, is_callable)

	-- if the value has a @@type, then it is a custom type, do not fallback to
	-- built-in types.
	return false if get_metavalue(value, '@@type', (v) -> type(v) == 'string')

	switch name
		when 'equals'
			-- each element in array or object must be a Setoid
			if type(value) == 'table'
				if is_table_array(value)
					return Array.all(value, M.Setoid.test)
				else
					return StrMap.all_values(value, M.Setoid.test)

		when 'lte'
			-- each element in array or object must be an Ord
			if type(value) == 'table'
				if is_table_array(value)
					return Array.all(value, M.Ord.test)
				else
					return StrMap.all_values(value, M.Ord.test)

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
		test: (x) -> Array.all(dependencies, (d) -> d.test(x)) and test(x),
	}, TypeClass__metatable)

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

	static_methods = Array.filter(requirements, (req) -> req.location == Constructor)
	metatable_methods = Array.filter(requirements, (req) -> req.location == Value)

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
				Array.all(static_methods, (sm) ->
					x != nil and
					static_method(sm.name, sm.implementations, getmetatable(x), value_to_static_builtin_type(x)) != nil
				) and
				Array.all(metatable_methods, (mm) ->
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

	Array.each(static_methods, (sm) ->
		{:arity, :implementations, :name} = sm
		type_class.methods[name] = switch arity
			when 0
				(type_rep) -> (static_method(name, implementations, type_rep)())
			when 1
				(type_rep, a) -> (static_method(name, implementations, type_rep)(a))
			else
				(type_rep, a, b) -> (static_method(name, implementations, type_rep)(a, b))
	)

	Array.each(metatable_methods, (mm) ->
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

M.Setoid = TypeClass__factory('Setoid', {}, {
	{
		name: 'equals',
		location: Value,
		arity: 1,
		implementations: {
			Array: Array.equals,
			Boolean: Boolean.equals,
			Function: Function.equals,
			Nil: Nil.equals,
			Number: Number.equals,
			String: String.equals,
			StrMap: StrMap.equals,
		},
	},
})

M.Ord = TypeClass__factory('Ord', {M.Setoid}, {
	{
		name: 'lte',
		location: Value,
		arity: 1,
		implementations: {
			Array: Array.lte,
			Boolean: Boolean.lte,
			Nil: Nil.lte,
			Number: Number.lte,
			String: String.lte,
			StrMap: StrMap.lte,
		},
	},
})

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

M.Semigroup = TypeClass__factory('Semigroup', {}, {
	{
		name: 'concat',
		location: Value,
		arity: 1,
		implementations: {
			Array: Array.concat,
			String: String.concat,
			StrMap: StrMap.concat,
		},
	},
})

M.Monoid = TypeClass__factory('Monoid', {M.Semigroup}, {
	{
		name: 'empty',
		location: Constructor,
		arity: 0,
		implementations: {
			Array: Array.empty,
			String: String.empty,
			StrMap: StrMap.empty,
		},
	},
})

M.Group = TypeClass__factory('Group', {M.Monoid}, {
	{
		name: 'invert',
		location: Value,
		arity: 0,
		implementations: {},
	},
})

M.Filterable = TypeClass__factory('Filterable', {}, {
	{
		name: 'filter',
		location: Value,
		arity: 1,
		implementations: {
			Array: Array.filter,
			StrMap: StrMap.filter,
		},
	},
})

M.Functor = TypeClass__factory('Functor', {}, {
	{
		name: 'map',
		location: Value,
		arity: 1,
		implementations: {
			Array: Array.map,
			Function: Function.map,
			StrMap: StrMap.map,
		},
	},
})

M.Bifunctor = TypeClass__factory('Bifunctor', {M.Functor}, {
	{
		name: 'bimap',
		location: Value,
		arity: 2,
		implementations: {},
	},
})

M.Profunctor = TypeClass__factory('Profunctor', {M.Functor}, {
	{
		name: 'promap',
		location: Value,
		arity: 2,
		implementations: {
			Function: Function.promap,
		},
	},
})

M.Apply = TypeClass__factory('Apply', {M.Functor}, {
	{
		name: 'ap',
		location: Value,
		arity: 1,
		implementations: {
			Array: Array.ap,
			Function: Function.ap,
			StrMap: StrMap.ap,
		},
	},
})

-- -------------------------------------------
-- Fantasy-Land functions for each type class
-- -------------------------------------------

do
	-- pairs :: Array (Array2 Any Any)
	pairs = {} -- cache of pairs of values to compare

	M.equals = (x, y) ->
		-- This algorithm for comparing circular data structures was
		-- suggested in <http://stackoverflow.com/a/40622794/312785>.
		if Array.some(pairs, (p) -> p[1] == x and p[2] == y)
			return true

		table.insert(pairs, {x, y})
		ok, err_or_result = pcall(M.Setoid.methods.equals, y, x)
		table.remove(pairs)
		error(err_or_result) unless ok
		err_or_result

do
	-- pairs :: Array (Array2 Any Any)
	pairs = {} -- cache of pairs of values to compare

	M.lte = (x, y) ->
		-- This algorithm for comparing circular data structures was
		-- suggested in <http://stackoverflow.com/a/40622794/312785>.
		if Array.some(pairs, (p) -> p[1] == x and p[2] == y)
			return M.equals(x, y)

		table.insert(pairs, {x, y})
		ok, err_or_result = pcall(M.Ord.methods.lte, y, x)
		table.remove(pairs)
		error(err_or_result) unless ok
		err_or_result

do
	M.compose = M.Semigroupoid.methods.compose

do
	M.id = M.Category.methods.id

do
	M.concat = (a, b) -> M.Semigroup.methods.concat(b, a)

do
	M.empty = M.Monoid.methods.empty

do
	M.invert = M.Group.methods.invert

do
	M.filter = M.Filterable.methods.filter

do
	M.map = M.Functor.methods.map

do
	M.bimap = M.Bifunctor.methods.bimap

do
	M.promap = M.Profunctor.methods.promap

do
	M.ap = M.Apply.methods.ap

M
