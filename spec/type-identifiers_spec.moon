assert = require 'luassert'
inspect = require 'inspect'
_ = inspect -- don't complain if unused

describe 'identifier_of', ->
	local identifier_of, Identity, Nothing, Just

	setup ->
		{:identifier_of} = require 'alma.type-identifiers'

		Identity = (x) ->
			setmetatable({value: x}, {['@@type']: 'my-package/Identity'})

		Nothing = ->
			setmetatable({is_nothing: true}, {['@@type']: 'my-package/Maybe'})

		Just = (x) ->
			setmetatable({is_nothing: false, value: x}, {['@@type']: 'my-package/Maybe'})

	it 'returns as expected', ->
		cases = {
			{nil, 'nil'},
			{1, 'number'},
			{'a', 'string'},
			{true, 'boolean'},
			{{}, 'table'},
			{->, 'function'},
			{coroutine.create(->), 'thread'},
			{io.stdout, 'userdata'},

			{Identity(42), 'my-package/Identity'},
			{Identity, 'function'},
			{getmetatable(Identity(42)), 'table'},
			{setmetatable({}, {['@@type']: nil}), 'table'},
			{setmetatable({}, {['@@type']: ''}), ''},
			{Nothing(), 'my-package/Maybe'},
			{Just(0), 'my-package/Maybe'},
		}
		for _, case in ipairs (cases)
			got = identifier_of(case[1])
			assert.are.equal case[2], got

describe 'parse_identifier', ->
	local parse_identifier
	setup ->
		{:parse_identifier} = require 'alma.type-identifiers'

	it 'parses as expected', ->
		TypeIdentifier = (namespace, name, version) ->
			:namespace, :name, :version

		cases = {
			{'package/Type', TypeIdentifier('package', 'Type', 0)},
			{'package/Type/X', TypeIdentifier('package/Type', 'X', 0)},
			{'@scope/package/Type', TypeIdentifier('@scope/package', 'Type', 0)},
			{'', TypeIdentifier(nil, '', 0)},
			{'/', TypeIdentifier(nil, '/', 0)},
			{'@', TypeIdentifier(nil, '@', 0)},
			{'/Type', TypeIdentifier(nil, '/Type', 0)},
			{'/@', TypeIdentifier(nil, '/@', 0)},
			{'a/@', TypeIdentifier('a', '@', 0)},
			{'@0', TypeIdentifier(nil, '@0', 0)},
			{'foo/\n@1', TypeIdentifier('foo', '\n', 1)},
			{'Type@1', TypeIdentifier(nil, 'Type@1', 0)},
			{'package/Type@1', TypeIdentifier('package', 'Type', 1)},
			{'package/Type@999', TypeIdentifier('package', 'Type', 999)},
			{'package/Type@X', TypeIdentifier('package', 'Type@X', 0)},
			{'package////@3@2@1@1', TypeIdentifier('package///', '@3@2@1', 1)},
		}
		for _, case in ipairs (cases)
			got = parse_identifier (case[1])
			assert.are.same case[2], got
