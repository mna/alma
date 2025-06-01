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

	M
