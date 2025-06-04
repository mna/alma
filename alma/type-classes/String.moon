local M

-- return a function that takes the Z module as an argument to avoid circular
-- dependencies
(Z) ->
	if M != nil
		error 'alma.type-classes.String required more than once'

	M = {}

  -- String.empty :: () -> String
	M.empty = -> ''

  -- String.equals :: String ~> String -> Boolean
	M.equals = (other) => @ == other

  -- String.lte :: String ~> String -> Boolean
	M.lte = (other) => @ <= other

  -- String.concat :: String ~> String -> String
	M.concat = (other) => @ .. other

	M
