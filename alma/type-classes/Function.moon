local M

-- return a function that takes the Z module as an argument to avoid circular
-- dependencies
(Z) ->
	if M != nil
		error 'alma.type-classes.Function required more than once'

	M = {}

	M.identity = (x) -> x

	-- Function.id :: () -> a -> a
	M.id = () -> M.identity

	-- Function.compose :: (a -> b) ~> (b -> c) -> (a -> c)
	M.compose = (other) =>
		(x) -> other(@(x))

  -- Function.equals :: Function ~> Function -> Boolean
	M.equals = (other) => other == @

  -- Function.map :: (a -> b) ~> (b -> c) -> (a -> c)
	M.map = (f) ->
		(x) -> f(@(x))

  -- Function.promap :: (b -> c) ~> (a -> b, c -> d) -> (a -> d)
	M.promap = (f, g) =>
		(x) -> g(@(f(x)))

  -- Function.ap :: (a -> b) ~> (a -> b -> c) -> (a -> c)
	M.ap = (f) =>
		(x) -> f(x)(@(x))

  -- Function.of :: b -> (a -> b)
	M.of = (x) ->
		-> x

  -- Function.chain :: (a -> b) ~> (b -> a -> c) -> (a -> c)
	M.chain = (f) =>
		(x) -> f(@(x))(x)

	M
