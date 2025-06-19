table = require 'table'

local M

-- sorted_keys :: StrMap -> Array String
sorted_keys = (o) ->
	keys = {}
	for k in pairs(o)
		table.insert(keys, k)
	table.sort(keys)
	keys

-- return a function that takes the Z module as an argument to avoid circular
-- dependencies
(Z) ->
	if M != nil
		error 'alma.type-classes.StrMap required more than once'

	M = {}

	M.metatable = {}

	M.StrMap = (o) ->
		setmetatable(o or {}, M.metatable)

	M.all_values = (o, p) ->
		for _, v in pairs(o)
			return false unless p(v)
		true

  -- StrMap.empty :: () -> StrMap a
	M.empty = -> M.StrMap({})

  -- StrMap.zero :: () -> StrMap a
	M.zero = -> M.StrMap({})

  -- StrMap.equals :: Setoid a => StrMap a ~> StrMap a -> Boolean
	M.equals = (other) =>
		keys = sorted_keys(@)
		if not Z.equals(keys, sorted_keys(other))
			return false

		for _, k in ipairs(keys)
			if not Z.equals(@[k], other[k])
				return false
		true

  -- StrMap.lte :: Ord a => StrMap a ~> StrMap a -> Boolean
	M.lte = (other) =>
		self_keys = sorted_keys(@)
		other_keys = sorted_keys(other)
		while (true)
			return true if #self_keys == 0
			return false if #other_keys == 0

			k = table.remove(self_keys, 1)
			z = table.remove(other_keys, 1)
			return true if k < z
			return false if k > z

			if not Z.equals(@[k], other[k])
				return Z.lte(@[k], other[k])

  -- StrMap.concat :: StrMap a ~> StrMap a -> StrMap a
	M.concat = (other) =>
		r = M.StrMap()
		for k, v in pairs(@)
			r[k] = v
		for k, v in pairs(other)
			r[k] = v
		r

  -- StrMap.filter :: StrMap a ~> (a -> Boolean) -> StrMap a
	M.filter = (o, pred) ->
		r = M.StrMap()
		for k, v in pairs(o)
			r[k] = v if pred(v)
		r

  -- StrMap.map :: StrMap a ~> (a -> b) -> StrMap b
	M.map= (f) ->
		r = M.StrMap()
		for k, v in pairs(@)
			r[k] = f(v)
		r

  -- StrMap.ap :: StrMap a ~> StrMap (a -> b) -> StrMap b
	M.ap = (other) =>
		r = M.StrMap()
		for k, v in pairs(@)
			if other[k] != nil
				r[k] = other[k](v)
		r

	M

  -- //  Object$prototype$alt :: StrMap a ~> StrMap a -> StrMap a
  -- const Object$prototype$alt = Object$prototype$concat;
  --
  -- //  Object$prototype$reduce :: StrMap a ~> ((b, a) -> b, b) -> b
  -- function Object$prototype$reduce(f, initial) {
  --   return sortedKeys (this)
  --          .reduce ((acc, k) => f (acc, this[k]), initial);
  -- }
  --
  -- //  Object$prototype$traverse :: Applicative f => StrMap a ~> (TypeRep f, a -> f b) -> f (StrMap b)
  -- function Object$prototype$traverse(typeRep, f) {
  --   return Object.keys (this)
  --          .reduce (
  --            (applicative, k) => (
  --              Z.lift2 (
  --                o => v => Object$prototype$concat.call (o, {[k]: v}),
  --                applicative,
  --                f (this[k])
  --              )
  --            ),
  --            Z.of (typeRep, {})
  --          );
  -- }
  --
