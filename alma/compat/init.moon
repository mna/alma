table = require 'table'
math = require 'math'

pack = (...) ->
	n = select '#', ...
	t = {...}
	t.n = n
	t

mtype = (n) ->
	return nil unless type(n) == 'number'
	if math.floor(n) == n
		if string.find(string.format('%f', n), 'inf')
			'float'
		else
			'integer'
	else
		'float'

-- Lua < 5.4 (and != LuaJIT) does not support the %p format in string.format,
-- so this is a version-portable way to extract the address of a value using
-- its string representation.
pointer_hex = (v) ->
	s = tostring(v)
	hex = string.match(s, '0x%x+')
	hex or ''

{
	-- Lua 5.1 has the global unpack function, and starting with Lua 5.2 it is
	-- the table.unpack function.
	table_unpack: _G.unpack or table.unpack

	-- Lua 5.1 has no pack function so this module provides one, and starting
	-- with Lua 5.2 it is the table.pack function.
	table_pack: table.pack or pack

	-- Lua 5.3 introduces the math.type function to get the subtype of a number
	-- (integer or float). This module provides a compatible version for previous
	-- Lua versions.
	math_type: math.type or mtype

	:pointer_hex
}
