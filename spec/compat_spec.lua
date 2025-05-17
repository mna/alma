local assert = require('luassert')
local inspect = require('inspect')
local _ = inspect
describe('table_pack, table_unpack', function()
  local table_pack, table_unpack
  setup(function()
    do
      local _obj_0 = require('alma.compat')
      table_pack, table_unpack = _obj_0.table_pack, _obj_0.table_unpack
    end
  end)
  it('is empty for no argument', function()
    local t = table_pack()
    assert.are.same({
      n = 0
    }, t)
    local a = table_unpack(t, 1, t.n)
    return assert.is_nil(a)
  end)
  it('is as expected for one non-nil argument', function()
    local t = table_pack(1)
    assert.are.same({
      n = 1,
      [1] = 1
    }, t)
    local a, b = table_unpack(t, 1, t.n)
    assert.are.equal(1, a)
    return assert.is_nil(b)
  end)
  it('is as expected for two non-nil arguments', function()
    local t = table_pack(1, 'b')
    assert.are.same({
      n = 2,
      [1] = 1,
      [2] = 'b'
    }, t)
    local a, b, c = table_unpack(t, 1, t.n)
    assert.are.equal(1, a)
    assert.are.equal('b', b)
    return assert.is_nil(c)
  end)
  it('is as expected for three non-nil arguments', function()
    local t = table_pack(1, 'b', true)
    assert.are.same({
      n = 3,
      [1] = 1,
      [2] = 'b',
      [3] = true
    }, t)
    local a, b, c, d = table_unpack(t, 1, t.n)
    assert.are.equal(1, a)
    assert.are.equal('b', b)
    assert.is_true(c)
    return assert.is_nil(d)
  end)
  it('identifies the single value even if it is nil', function()
    local t = table_pack(nil)
    assert.are.same({
      n = 1,
      [1] = nil
    }, t)
    local a, b = table_unpack(t, 1, t.n)
    assert.is_nil(a)
    return assert.is_nil(b)
  end)
  return it('identifies all values even if it has nils', function()
    local t = table_pack('a', nil, 'c', nil, nil, 'f', nil)
    assert.are.same({
      n = 7,
      [1] = 'a',
      [3] = 'c',
      [6] = 'f'
    }, t)
    local a, b, c, d, e, f, g = table_unpack(t, 1, t.n)
    assert.are.equal('a', a)
    assert.is_nil(b)
    assert.are.equal('c', c)
    assert.is_nil(d)
    assert.is_nil(e)
    assert.are.equal('f', f)
    return assert.is_nil(g)
  end)
end)
return describe('math_type', function()
  local math_type
  setup(function()
    math_type = require('alma.compat').math_type
  end)
  it('is nil for nil', function()
    return assert.is_nil(math_type(nil))
  end)
  it('is integer for 0', function()
    return assert.equal('integer', math_type(0))
  end)
  it('is integer for 1', function()
    return assert.equal('integer', math_type(1))
  end)
  it('is integer for -1', function()
    return assert.equal('integer', math_type(-1))
  end)
  it('is integer for 123', function()
    return assert.equal('integer', math_type(123))
  end)
  it('is integer for -456', function()
    return assert.equal('integer', math_type(-456))
  end)
  it('is float for 1.1', function()
    return assert.equal('float', math_type(1.1))
  end)
  it('is float for -1.1', function()
    return assert.equal('float', math_type(-1.1))
  end)
  it('is float for 3.1415', function()
    return assert.equal('float', math_type(3.1415))
  end)
  return it('is float for -3.567', function()
    return assert.equal('float', math_type(-3.567))
  end)
end)
