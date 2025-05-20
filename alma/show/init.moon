debug = require 'debug'
string = require 'string'
table = require 'table'

meta = require 'alma.meta'
{:math_type} = require 'alma.compat'

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
			for k, v in pairs(x)
				if math_type(k) == 'integer' and k > 0 and k <= array_up_to
					continue

				if needs_comma
					table.insert(parts, ', ')

				table.insert(parts, string.format('[%s] = ', show_detect_circular(k, seen)))
				table.insert(parts, show_detect_circular(v, seen))
				needs_comma = true

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

			table.insert(parts, string.format("  -- %s function (%p)\n", finfo.what, x))
			if finfo.linedefined > 0
				table.insert(parts, string.format('  -- at %s:%d\n', finfo.short_src, finfo.linedefined))
			table.insert(parts, "end")

			table.concat(parts)

		when 'thread'
			"<thread #{string.format('%p', x)}>"

		when 'userdata'
			"<userdata #{string.format('%p', x)}>"

		else
			"<unknown type: #{type(x)}>"

show = (x) ->
	show_detect_circular(x, {})

{:show}
