local M

-- return a function that takes the Z module as an argument to avoid circular
-- dependencies
(Z) ->
	if M != nil
		error 'alma.type-classes.Array required more than once'

	M = {}

	M.metatable = {'@@type': 'alma.type-classes/Array@1'}

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

	M
		-- //  Array$chainRec :: ((a -> c, b -> c, a) -> Array c, a) -> Array b
		-- const Array$chainRec = (f, x) => {
		--   const result = [];
		--   const nil = {};
		--   let todo = {head: x, tail: nil};
		--   while (todo !== nil) {
		--     let more = nil;
		--     const steps = f (iterationNext, iterationDone, todo.head);
		--     for (let idx = 0; idx < steps.length; idx += 1) {
		--       const step = steps[idx];
		--       if (step.done) {
		--         result.push (step.value);
		--       } else {
		--         more = {head: step.value, tail: more};
		--       }
		--     }
		--     todo = todo.tail;
		--     while (more !== nil) {
		--       todo = {head: more.head, tail: todo};
		--       more = more.tail;
		--     }
		--   }
		--   return result;
		-- };
		-- //  Array$prototype$lte :: Ord a => Array a ~> Array a -> Boolean
		-- function Array$prototype$lte(other) {
		--   for (let idx = 0; true; idx += 1) {
		--     if (idx === this.length) break;
		--     if (idx === other.length) return false;
		--     if (!(Z.equals (this[idx], other[idx]))) {
		--       return Z.lte (this[idx], other[idx]);
		--     }
		--   }
		--   return true;
		-- }
		--
		-- //  Array$prototype$concat :: Array a ~> Array a -> Array a
		-- function Array$prototype$concat(other) {
		--   return this.concat (other);
		-- }
		--
		-- //  Array$prototype$filter :: Array a ~> (a -> Boolean) -> Array a
		-- function Array$prototype$filter(pred) {
		--   return this.filter (x => pred (x));
		-- }
		--
		-- //  Array$prototype$map :: Array a ~> (a -> b) -> Array b
		-- function Array$prototype$map(f) {
		--   return this.map (x => f (x));
		-- }
		--
		-- //  Array$prototype$ap :: Array a ~> Array (a -> b) -> Array b
		-- function Array$prototype$ap(fs) {
		--   const result = [];
		--   for (let idx = 0; idx < fs.length; idx += 1) {
		--     for (let idx2 = 0; idx2 < this.length; idx2 += 1) {
		--       result.push (fs[idx] (this[idx2]));
		--     }
		--   }
		--   return result;
		-- }
		--
		-- //  Array$prototype$chain :: Array a ~> (a -> Array b) -> Array b
		-- function Array$prototype$chain(f) {
		--   const result = [];
		--   for (let idx = 0; idx < this.length; idx += 1) {
		--     for (let idx2 = 0, xs = f (this[idx]); idx2 < xs.length; idx2 += 1) {
		--       result.push (xs[idx2]);
		--     }
		--   }
		--   return result;
		-- }
		--
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
