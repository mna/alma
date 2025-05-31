M = {}

M.identity = (x) -> x
M.id = () -> M.identity

-- Function.compose :: (a -> b) ~> (b -> c) -> (a -> c)
M.compose = (other) =>
	(x) -> other(@(x))

M
