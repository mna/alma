local assert = require('luassert')
local inspect = require('inspect')
local _ = inspect
local luafn0
luafn0 = function() end
local luafn1
luafn1 = function(a) end
local luafn2
luafn2 = function(a, b, ...) end
local luafnvar
luafnvar = function(...) end
return describe('show', function()
  local show
  setup(function()
    show = require('alma.show').show
  end)
  return it('returns as expected', function()
    local thread = coroutine.create(function() end)
    local userdata = io.stdout
    local cfn = type
    local circular_tbl = { }
    circular_tbl[1] = circular_tbl
    local cases = {
      {
        nil,
        'nil'
      },
      {
        true,
        'true'
      },
      {
        false,
        'false'
      },
      {
        1,
        '1'
      },
      {
        0,
        '0'
      },
      {
        -1,
        '-1'
      },
      {
        123456,
        '123456'
      },
      {
        -654321,
        '-654321'
      },
      {
        1.1,
        '1.1'
      },
      {
        3.14156,
        '3.14156'
      },
      {
        1.4569823e12,
        '1456982300000'
      },
      {
        12.3456789012,
        '12.3456789'
      },
      {
        12345.6789012,
        '12345.6789'
      },
      {
        123456789.123456,
        '123456789.1'
      },
      {
        -123456789.123456,
        '-123456789.1'
      },
      {
        0 / 0,
        'nan'
      },
      {
        1 / 0,
        'inf'
      },
      {
        -1 / 0,
        '-inf'
      },
      {
        '',
        '""'
      },
      {
        'a',
        '"a"'
      },
      {
        'a\nb\nc',
        '"a\\\nb\\\nc"'
      },
      {
        { },
        '{}'
      },
      {
        {
          1
        },
        '{1}'
      },
      {
        {
          1,
          'b',
          true,
          4
        },
        '{1, "b", true, 4}'
      },
      {
        {
          1,
          'b',
          true,
          4
        },
        '{1, "b", true, 4}'
      },
      {
        {
          circular_tbl
        },
        '{{<circular>}}'
      },
      {
        {
          1,
          t = circular_tbl
        },
        '{1, ["t"] = {<circular>}}'
      },
      {
        {
          a = true,
          [false] = 3
        },
        '{["a"] = true, [false] = 3}'
      },
      {
        {
          x = {
            y = {
              z = "ok"
            }
          }
        },
        '{["x"] = {["y"] = {["z"] = "ok"}}}'
      },
      {
        {
          x = 1,
          y = 2,
          z = 3
        },
        '{["x"] = 1, ["y"] = 2, ["z"] = 3}'
      },
      {
        {
          y = 2,
          z = 3,
          x = 1
        },
        '{["x"] = 1, ["y"] = 2, ["z"] = 3}'
      },
      {
        {
          x = 1,
          'a',
          'b',
          'c'
        },
        '{"a", "b", "c", ["x"] = 1}'
      },
      {
        {
          'a',
          'b',
          'c',
          [5] = 'd'
        },
        '{"a", "b", "c", [5] = "d"}'
      },
      {
        {
          'a',
          'b',
          'c',
          [0] = 'd'
        },
        '{"a", "b", "c", [0] = "d"}'
      },
      {
        {
          'a',
          'b',
          'c',
          [-1] = 'd'
        },
        '{"a", "b", "c", [-1] = "d"}'
      },
      {
        thread,
        string.format('<thread %p>', thread)
      },
      {
        userdata,
        string.format('<userdata %p>', userdata)
      },
      {
        {
          ['@@show'] = true
        },
        '{["@@show"] = true}'
      },
      {
        setmetatable({
          'a',
          x = 1
        }, {
          ['@@show'] = function()
            return '<custom>'
          end
        }),
        '<custom>'
      },
      {
        setmetatable({
          'a',
          x = 1
        }, {
          ['@@show'] = setmetatable({ }, {
            __call = function()
              return '<custom>'
            end
          })
        }),
        '<custom>'
      },
      {
        setmetatable({
          'a',
          x = 1
        }, {
          ['@@show'] = true
        }),
        '{"a", ["x"] = 1}'
      },
      {
        setmetatable({
          'a',
          x = 1
        }, {
          ['@@show'] = { }
        }),
        '{"a", ["x"] = 1}'
      },
      {
        luafn0,
        string.format('function ()\n  -- Lua function (%p)\n  -- at spec/show_spec.moon:5\nend', luafn0)
      },
      {
        luafn1,
        string.format('function (arg1)\n  -- Lua function (%p)\n  -- at spec/show_spec.moon:7\nend', luafn1)
      },
      {
        luafn2,
        string.format('function (arg1, arg2, ...)\n  -- Lua function (%p)\n  -- at spec/show_spec.moon:9\nend', luafn2)
      },
      {
        luafnvar,
        string.format('function (...)\n  -- Lua function (%p)\n  -- at spec/show_spec.moon:11\nend', luafnvar)
      },
      {
        cfn,
        string.format('function (...)\n  -- C function (%p)\nend', cfn)
      }
    }
    for _, case in ipairs((cases)) do
      local got = show(case[1])
      assert.are.equal(case[2], got)
    end
  end)
end)
