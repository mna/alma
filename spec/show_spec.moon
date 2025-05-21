assert = require 'luassert'
inspect = require 'inspect'
_ = inspect -- don't complain if unused

luafn0 = () -> -- do not move
luafn1 = (a) -> -- do not move
luafn2 = (a, b, ...) -> -- do not move
luafnvar = (...) -> -- do not move

describe 'show', ->
	local show

	setup ->
		{:show} = require 'alma.show'

	it 'returns as expected', ->
		thread = coroutine.create(->)
		userdata = io.stdout
		cfn = type
		circular_tbl = {}
		circular_tbl[1] = circular_tbl

		cases = {
			{nil, 'nil'},

			{true, 'true'},
			{false, 'false'},

			{1, '1'},
			{0, '0'},
			{-1, '-1'},
			{123456, '123456'},
			{-654321, '-654321'},

			{1.1, '1.1'},
			{3.14156, '3.14156'},
			{1.4569823e12, '1456982300000'},
			{12.3456789012, '12.3456789'},
			{12345.6789012, '12345.6789'},
			{123456789.123456, '123456789.1'},
			{-123456789.123456, '-123456789.1'},
			{0/0, 'nan'},
			{1/0, 'inf'},
			{-1/0, '-inf'},

			{'', '""'},
			{'a', '"a"'},
			{'a\nb\nc', '"a\\\nb\\\nc"'},

			{{}, '{}'},
			{{1}, '{1}'},
			{{1, 'b', true, 4}, '{1, "b", true, 4}'},
			{{1, 'b', true, 4}, '{1, "b", true, 4}'},
			{{circular_tbl}, '{{<circular>}}'},
			{{1, t: circular_tbl}, '{1, ["t"] = {<circular>}}'},
			{{a: true, [false]: 3}, '{["a"] = true, [false] = 3}'},
			{{x: {y: {z: "ok"}}}, '{["x"] = {["y"] = {["z"] = "ok"}}}'},
			{{x: 1, y: 2, z: 3}, '{["x"] = 1, ["y"] = 2, ["z"] = 3}'},
			{{y: 2, z: 3, x: 1}, '{["x"] = 1, ["y"] = 2, ["z"] = 3}'},

			{thread, string.format('<thread %p>', thread)},
			{userdata, string.format('<userdata %p>', userdata)},

			{luafn0, string.format('function ()
  -- Lua function (%p)
  -- at spec/show_spec.moon:5
end', luafn0)},
			{luafn1, string.format('function (arg1)
  -- Lua function (%p)
  -- at spec/show_spec.moon:7
end', luafn1)},
			{luafn2, string.format('function (arg1, arg2, ...)
  -- Lua function (%p)
  -- at spec/show_spec.moon:9
end', luafn2)},
			{luafnvar, string.format('function (...)
  -- Lua function (%p)
  -- at spec/show_spec.moon:11
end', luafnvar)},
			{cfn, string.format('function (...)
  -- C function (%p)
end', cfn)},
		}
		for _, case in ipairs (cases)
			got = show(case[1])
			assert.are.equal case[2], got
