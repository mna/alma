{:iteration_next, :iteration_done} = require 'alma.type-classes.internal'

local M

-- return a function that takes the Z module as an argument to avoid circular
-- dependencies
(Z) ->
	if M != nil
		error 'alma.type-classes.Array required more than once'

	M = {}

	M.metatable = {}

	M.Array = (a) ->
		setmetatable(a or {}, M.metatable)

	M.all = (a, p) ->
		for _, v in ipairs(a)
			return false unless p(v)
		true

	M.some = (a, p) ->
		for _, v in ipairs(a)
			return true if p(v)
		false

	-- Array.filter :: Array a ~> (a -> Boolean) -> Array a
	M.filter = (a, p) ->
		r = M.Array()
		for _, v in ipairs(a)
			table.insert(r, v) if p(v)
		r

	M.each = (a, f) ->
		for _, v in ipairs(a)
			f(v)

	-- Array.empty :: () -> Array a
	M.empty = () -> M.Array({})

	-- Array.of :: a -> Array a
	M.of = (x) -> M.Array({x})

	-- Array.zero :: () -> Array a
	M.zero = () -> M.Array({})

  -- Array.equals :: Setoid a => Array a ~> Array a -> Boolean
	M.equals = (other) =>
		return false if #other != #@
		for i = 1, #@
			if not Z.equals(@[i], other[i]) then
				return false
		true

	-- Array.lte :: Ord a => Array a ~> Array a -> Boolean
	M.lte = (other) =>
		for i = 1, #@
			return false if i > #other
			if not Z.equals(@[i], other[i]) then
				return Z.lte(@[i], other[i])
		true

	-- Array.concat :: Array a ~> Array a -> Array a
	M.concat = (other) =>
		r = M.Array()
		for _, v in ipairs(@)
			table.insert(r, v)
		for _, v in ipairs(other)
			table.insert(r, v)
		r

	-- Array.map :: Array a ~> (a -> b) -> Array b
	M.map = (f) ->
		r = M.Array()
		for _, v in ipairs(@)
			table.insert(r, (f(v)))
		r

	-- Array.ap :: Array a ~> Array (a -> b) -> Array b
	M.ap = (fs) =>
		r = M.Array()
		for _, f in ipairs(fs)
			for _, v in ipairs(@)
				table.insert(r, f(v))
		r

	-- Array.chain :: Array a ~> (a -> Array b) -> Array b
	M.chain = (f) =>
		r = M.Array()
		for _, v in ipairs(@)
			xs = f(v)
			for _, x in ipairs(xs)
				table.insert(r, x)
		r

	-- Array.chain_rec :: ((a -> c, b -> c, a) -> Array c, a) -> Array b
	M.chain_rec = (f, x) ->
		result = M.Array()
		neant = {}
		todo = {head: x, tail: neant}

		while todo != neant
			more = neant
			steps = f(iteration_next, iteration_done, todo.head)

			for _, step in ipairs(steps)
				if step.done
					table.insert(result, step.value)
				else
					more = {head: step.value, tail: more}
			todo = todo.tail

			while more != neant
				todo = {head: more.head, tail: todo}
				more = more.tail

		return result

	M

		-- //  Array$prototype$alt :: Array a ~> Array a -> Array a
		-- const Array$prototype$alt = Array$prototype$concat;
		--
		-- //  Array$prototype$reduce :: Array a ~> ((b, a) -> b, b) -> b
		-- function Array$prototype$reduce(f, initial) {
		--   let acc = initial;
		--   for (let idx = 0; idx < this.length; idx += 1) acc = f (acc, this[idx]);
		--   return acc;
		-- }
		--
		-- //  Array$prototype$traverse :: Applicative f => Array a ~> (TypeRep f, a -> f b) -> f (Array b)
		-- function Array$prototype$traverse(typeRep, f) {
		--   const go = (idx, n) => {
		--     switch (n) {
		--       case 0: return Z.of (typeRep, []);
		--       case 2: return Z.lift2 (pair, f (this[idx]), f (this[idx + 1]));
		--       default: {
		--         const m = Math.floor (n / 4) * 2;
		--         return Z.lift2 (concat, go (idx, m), go (idx + m, n - m));
		--       }
		--     }
		--   };
		--   return this.length % 2 === 1 ?
		--     Z.lift2 (
		--       concat,
		--       Z.map (Array$of, f (this[0])), go (1, this.length - 1)
		--     ) :
		--     go (0, this.length);
		-- }
		--
		-- //  Array$prototype$extend :: Array a ~> (Array a -> b) -> Array b
		-- function Array$prototype$extend(f) {
		--   return this.map ((_, idx, xs) => f (xs.slice (idx)));
		-- }
		--
