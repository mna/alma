local assert, describe, it, setup
do
  local _obj_0 = require('busted')
  assert, describe, it, setup = _obj_0.assert, _obj_0.describe, _obj_0.it, _obj_0.setup
end
local inspect = require('inspect')
local M = { }
M.spec_for = function(name, test_cases)
  return describe(name, function()
    local sut, identifier_of
    setup(function()
      local TypeClasses = require('alma.type-classes')
      identifier_of = require('alma.type-identifiers').identifier_of
      sut = TypeClasses[name]
    end)
    it('is a TypeClass', function()
      return assert.are.equal('alma.type-classes/TypeClass@1', identifier_of(sut))
    end)
    it('has the expected name', function()
      return assert.are.equal("alma.type-classes/" .. tostring(name), sut.name)
    end)
    it('has the expected url', function()
      return assert.matches("https://github%.com/mna/alma/tree/v%d%.%d%.%d/alma/type%-classes#" .. tostring(name), sut.url)
    end)
    if test_cases and #test_cases > 0 then
      return it('accepts expected values', function()
        for _, c in ipairs(test_cases) do
          local got = sut.test(c.value)
          assert.are.equal(c.want, got, "tested value: " .. tostring(inspect(c.value)))
        end
      end)
    end
  end)
end
return M
