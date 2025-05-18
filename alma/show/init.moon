meta = require 'alma.meta'

show_detect_circular = (x, seen) ->
	if x == nil then return 'nil'
	do
		metafn = meta.get_metavalue(x, '@@show', meta.is_callable)
		if metafn then return metafn(x)
	if seen[x] then return '<Circular>'

	switch type(x) -- note that nil is already handled
		when 'boolean'


show = (x) ->
	show_detect_circular(x, {})

{:show}
