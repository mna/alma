debug = require 'debug'
string = require 'string'
table = require 'table'

meta = require 'alma.meta'
{:math_type, :pointer_hex} = require 'alma.compat'

show_detect_circular = (x, seen) ->
	if x == nil then return 'nil'

	do
		metafn = meta.get_metavalue(x, '@@show', meta.is_callable)
		if metafn then return metafn(x)

	if seen[x] then return '<circular>'

	switch type(x) -- note that nil is already handled
		when 'boolean'
			x and 'true' or 'false'

		when 'number'
			if math_type(x) == 'integer'
				string.format('%d', x)
			else
				string.format('%.10g', x)

		when 'string'
			string.format('%q', x)

		when 'table'
			seen[x] = true
			array_up_to = 0

			parts = {"{"}

			-- start with the array part
			for i, v in ipairs(x)
				if i > 1 then
					table.insert(parts, ', ')

				array_up_to = i
				table.insert(parts, show_detect_circular(v, seen))

			-- continue with the hash part, ignoring keys covered by the array
			needs_comma = array_up_to > 0
			key_vals = {}
			for k, v in pairs(x)
				if math_type(k) == 'integer' and k > 0 and k <= array_up_to
					continue
				table.insert(key_vals, string.format('[%s] = %s',
					show_detect_circular(k, seen), show_detect_circular(v, seen)))

			if #key_vals > 0
				-- sort by keys
				table.sort(key_vals)

				-- add the hash part to the table parts
				if needs_comma
					table.insert(parts, ', ')
				table.insert(parts, table.concat(key_vals, ', '))

			table.insert(parts, "}")
			seen[x] = nil
			table.concat(parts)

		when 'function'
			finfo = debug.getinfo(x)

			parts = {"function #{finfo.name or ''}("}
			for i = 1, finfo.nparams
				if i > 1 then
					table.insert(parts, ', ')
				table.insert(parts, string.format('arg%d', i))

			if finfo.isvararg
				if finfo.nparams > 0 then
					table.insert(parts, ', ')
				table.insert(parts, '...')
			table.insert(parts, ')\n')

			table.insert(parts, string.format("  -- %s function (%s)\n", finfo.what, pointer_hex(x)))
			if finfo.linedefined > 0
				table.insert(parts, string.format('  -- at %s:%d\n', finfo.short_src, finfo.linedefined))
			table.insert(parts, "end")

			table.concat(parts)

		when 'thread'
			"<thread #{string.format('%s', pointer_hex(x))}>"

		when 'userdata'
			"<userdata #{string.format('%s', pointer_hex(x))}>"

		else
			"<unknown type: #{type(x)}>"

show = (x) ->
	show_detect_circular(x, {})

{:show}
