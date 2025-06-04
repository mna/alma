local assert = require('luassert')
local inspect = require('inspect')
local _ = inspect
return describe('Useless', function()
  local Useless, identifier_of, parse_identifier, Z
  setup(function()
    Useless = require('alma.useless').Useless
    do
      local _obj_0 = require('alma.type-identifiers')
      identifier_of, parse_identifier = _obj_0.identifier_of, _obj_0.parse_identifier
    end
    Z = require('alma.type-classes')
  end)
  it('is of the expected type', function()
    return assert.are.equal('alma.useless/Useless@1', identifier_of(Useless))
  end)
  it('type parses as expected', function()
    local tp = parse_identifier(identifier_of(Useless))
    return assert.are.same({
      namespace = 'alma.useless',
      name = 'Useless',
      version = 1
    }, tp)
  end)
  return it('satisfies no type class', function()
    local cases = {
      Z.Setoid,
      Z.Ord,
      Z.Semigroupoid,
      Z.Category
    }
    for _, tc in ipairs(cases) do
      assert.is_false(tc.test(Useless), 'typeclass: ' .. tc.name)
    end
  end)
end)
