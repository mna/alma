local M

-- return a function that takes the Z module as an argument to avoid circular
-- dependencies
(Z) ->
	if M != nil
		error 'alma.type-classes.Boolean required more than once'

	M = {}

  -- Boolean.equals :: Boolean ~> Boolean -> Boolean
	M.equals = (other) => @ == other

	M
