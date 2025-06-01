local M

-- return a function that takes the Z module as an argument to avoid circular
-- dependencies
(Z) ->
	if M != nil
		error 'alma.type-classes.Nil required more than once'

	M = {}

  -- Nil.equals :: Null ~> Null -> Boolean
	M.equals = (other) => true

	M
