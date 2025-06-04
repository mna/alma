local M

-- return a function that takes the Z module as an argument to avoid circular
-- dependencies
(Z) ->
	if M != nil
		error 'alma.type-classes.Nil required more than once'

	M = {}

  -- Nil.equals :: Nil ~> Nil -> Boolean
	M.equals = (other) => true

  -- Null.lte :: Nil ~> Nil -> Boolean
	M.lte = (other) => true

	M
