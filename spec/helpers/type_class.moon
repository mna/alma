{:assert, :describe, :it, :setup} = require 'busted'
inspect = require 'inspect'

M = {}

M.spec_for = (name, test_cases) ->
	describe name, ->
		local sut, identifier_of

		setup ->
			TypeClasses = require 'alma.type-classes'
			{:identifier_of} = require 'alma.type-identifiers'
			sut = TypeClasses[name]

		it 'is a TypeClass', ->
			assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(sut))

		it 'has the expected name', ->
			assert.are.equal("alma.type-classes/#{name}", sut.name)

		it 'has the expected url', ->
			assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes##{name}", sut.url)

		if test_cases and #test_cases > 0
			it 'accepts expected values', ->
				for _, c in ipairs(test_cases)
					got = sut.test(c.value)
					assert.are.equal(c.want, got, "tested value: #{inspect(c.value)}")

M
