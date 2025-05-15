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
		'integer'
	else
		'float'

{
	table_unpack: _G.unpack or table.unpack
	table_pack: table.pack or pack
	math_type: math.type or mtype
}
