M = {}

M.iteration_next = (x) ->
	{value: x, done: false}

M.iteration_done = (x) ->
	{value: x, done: true}

M
