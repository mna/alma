local M

is_NaN = (n) -> n != n

-- return a function that takes the Z module as an argument to avoid circular
-- dependencies
(Z) ->
	if M != nil
		error 'alma.type-classes.Number required more than once'

	M = {}

  -- Number.equals :: Number ~> Number -> Boolean
	M.equals = (other) => (@ == other) or (is_NaN(@) and is_NaN(other))

  -- Number.lte :: Number ~> Number -> Boolean
	M.lte = (other) => (is_NaN(@)) or (@ <= other)

	M
