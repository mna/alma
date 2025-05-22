assert = require 'luassert'
inspect = require 'inspect'
_ = inspect -- don't complain if unused

{:pointer_hex} = require 'alma.compat'

luafn0 = () -> -- do not move
luafn1 = (a) -> -- do not move
luafn2 = (a, b, ...) -> -- do not move
luafnvar = (...) -> -- do not move

describe 'show', ->
	local show, lua_version, lua_jit

	setup ->
		{:show} = require 'alma.show'
		maj, min = string.match(_G._VERSION, 'Lua (%d+)%.(%d+)')
		lua_version = tonumber(maj .. min) -- e.g. 54 for 5.4, 51 for 5.1 and JIT
		lua_jit = (type(_G.jit) == 'table')

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
			{1.4569823e12, '1456982300000', -> lua_version < 53},
			{1.4569823e12, '1.4569823e12', -> lua_version >= 53},
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
			{{x: 1, 'a', 'b', 'c'}, '{"a", "b", "c", ["x"] = 1}'},
			{{'a', 'b', 'c', [5]: 'd'}, '{"a", "b", "c", [5] = "d"}'},
			{{'a', 'b', 'c', [0]: 'd'}, '{"a", "b", "c", [0] = "d"}'},
			{{'a', 'b', 'c', [-1]: 'd'}, '{"a", "b", "c", [-1] = "d"}'},

			{thread, string.format('<thread %s>', pointer_hex(thread))},
			{userdata, string.format('<userdata %s>', pointer_hex(userdata))},

			{{'@@show': true}, '{["@@show"] = true}'},
			{setmetatable({'a', x: 1}, {'@@show': -> '<custom>'}), '<custom>'},
			{setmetatable({'a', x: 1}, {'@@show': setmetatable({}, {__call: -> '<custom>'})}), '<custom>'},
			{setmetatable({'a', x: 1}, {'@@show': true}), '{"a", ["x"] = 1}'},
			{setmetatable({'a', x: 1}, {'@@show': {}}), '{"a", ["x"] = 1}'},
			-- On Lua 5.3.5+, the __call metamethod can itself be a "callable" metamethod,
			-- but on LuaJIT this must be a function, not a "callable". The alma library
			-- will attempt to call it if it is a callable, but it will fail on LuaJIT.
			-- {setmetatable({'a', x: 1}, {'@@show': setmetatable({}, {__call: setmetatable({}, {__call: -> '<custom>'})})}), '<custom>'},

			{luafn0, string.format('function ()
  -- Lua function (%s)
  -- at spec/show_spec.moon:7
end', pointer_hex(luafn0))},
			{luafn1, string.format('function (arg1)
  -- Lua function (%s)
  -- at spec/show_spec.moon:9
end', pointer_hex(luafn1)), -> lua_version > 51 or lua_jit},
			{luafn2, string.format('function (arg1, arg2, ...)
  -- Lua function (%s)
  -- at spec/show_spec.moon:11
end', pointer_hex(luafn2)), -> lua_version > 51 or lua_jit},
			{luafnvar, string.format('function (...)
  -- Lua function (%s)
  -- at spec/show_spec.moon:13
end', pointer_hex(luafnvar)), -> lua_version > 51 or lua_jit},
			{cfn, string.format('function (...)
  -- C function (%s)
end', pointer_hex(cfn)), -> lua_version > 51 or lua_jit},
		}
		for _, case in ipairs (cases)
			got = show(case[1])
			want = case[2]
			predicate = case[3]

			if predicate
				continue unless predicate()

			-- pattern-match if the first char is ~
			if string.sub(want, 1, 1) == '~'
				want = string.sub(want, 2)
				assert.matches(want, got)
			else
				assert.are.equal(want, got)
