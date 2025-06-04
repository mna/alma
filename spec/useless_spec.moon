assert = require 'luassert'
inspect = require 'inspect'
_ = inspect -- don't complain if unused

describe 'Useless', ->
	local Useless, identifier_of, parse_identifier, Z

	setup ->
		{:Useless} = require 'alma.useless'
		{:identifier_of, :parse_identifier} = require 'alma.type-identifiers'
		Z = require 'alma.type-classes'

	it 'is of the expected type', ->
		assert.are.equal('alma.useless/Useless@1', identifier_of(Useless))

	it 'type parses as expected', ->
		tp = parse_identifier(identifier_of(Useless))
		assert.are.same({namespace: 'alma.useless', name: 'Useless', version: 1}, tp)

	it 'satisfies no type class', ->
		cases = {
			Z.Setoid,
			Z.Ord,
			Z.Semigroupoid,
			Z.Category,
		}
		for _, tc in ipairs(cases)
			assert.is_false(tc.test(Useless), 'typeclass: ' .. tc.name)

--   eq (Z.Semigroup.test (Useless), false);
--   eq (Z.Monoid.test (Useless), false);
--   eq (Z.Group.test (Useless), false);
--   eq (Z.Filterable.test (Useless), false);
--   eq (Z.Functor.test (Useless), false);
--   eq (Z.Bifunctor.test (Useless), false);
--   eq (Z.Profunctor.test (Useless), false);
--   eq (Z.Apply.test (Useless), false);
--   eq (Z.Applicative.test (Useless), false);
--   eq (Z.Chain.test (Useless), false);
--   eq (Z.ChainRec.test (Useless), false);
--   eq (Z.Monad.test (Useless), false);
--   eq (Z.Alt.test (Useless), false);
--   eq (Z.Plus.test (Useless), false);
--   eq (Z.Alternative.test (Useless), false);
--   eq (Z.Foldable.test (Useless), false);
--   eq (Z.Traversable.test (Useless), false);
--   eq (Z.Extend.test (Useless), false);
--   eq (Z.Comonad.test (Useless), false);
--   eq (Z.Contravariant.test (Useless), false);
