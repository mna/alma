assert = require 'luassert'
inspect = require 'inspect'

describe 'identifier_of', ->
	local table_pack, table_unpack
	setup ->
		{:table_pack, :table_unpack} = require 'alma.compat'
