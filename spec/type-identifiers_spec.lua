local assert = require('luassert')
local inspect = require('inspect')
local _ = inspect
describe('identifier_of', function()
  local identifier_of, Identity, Nothing, Just
  setup(function()
    identifier_of = require('alma.type-identifiers').identifier_of
    Identity = function(x)
      return setmetatable({
        value = x
      }, {
        ['@@type'] = 'my-package/Identity'
      })
    end
    Nothing = function()
      return setmetatable({
        is_nothing = true
      }, {
        ['@@type'] = 'my-package/Maybe'
      })
    end
    Just = function(x)
      return setmetatable({
        is_nothing = false,
        value = x
      }, {
        ['@@type'] = 'my-package/Maybe'
      })
    end
  end)
  return it('returns as expected', function()
    local cases = {
      {
        nil,
        'nil'
      },
      {
        1,
        'number'
      },
      {
        'a',
        'string'
      },
      {
        true,
        'boolean'
      },
      {
        { },
        'table'
      },
      {
        function() end,
        'function'
      },
      {
        coroutine.create(function() end),
        'thread'
      },
      {
        io.stdout,
        'userdata'
      },
      {
        Identity(42),
        'my-package/Identity'
      },
      {
        Identity,
        'function'
      },
      {
        getmetatable(Identity(42)),
        'table'
      },
      {
        setmetatable({ }, {
          ['@@type'] = nil
        }),
        'table'
      },
      {
        setmetatable({ }, {
          ['@@type'] = ''
        }),
        ''
      },
      {
        Nothing(),
        'my-package/Maybe'
      },
      {
        Just(0),
        'my-package/Maybe'
      }
    }
    for _, case in ipairs((cases)) do
      local got = identifier_of(case[1])
      assert.are.equal(case[2], got)
    end
  end)
end)
return describe('parse_identifier', function()
  local parse_identifier
  setup(function()
    parse_identifier = require('alma.type-identifiers').parse_identifier
  end)
  return it('parses as expected', function()
    local TypeIdentifier
    TypeIdentifier = function(namespace, name, version)
      return {
        namespace = namespace,
        name = name,
        version = version
      }
    end
    local cases = {
      {
        'package/Type',
        TypeIdentifier('package', 'Type', 0)
      },
      {
        'package/Type/X',
        TypeIdentifier('package/Type', 'X', 0)
      },
      {
        '@scope/package/Type',
        TypeIdentifier('@scope/package', 'Type', 0)
      },
      {
        '',
        TypeIdentifier(nil, '', 0)
      },
      {
        '/',
        TypeIdentifier(nil, '/', 0)
      },
      {
        '@',
        TypeIdentifier(nil, '@', 0)
      },
      {
        '/Type',
        TypeIdentifier(nil, '/Type', 0)
      },
      {
        '/@',
        TypeIdentifier(nil, '/@', 0)
      },
      {
        'a/@',
        TypeIdentifier('a', '@', 0)
      },
      {
        '@0',
        TypeIdentifier(nil, '@0', 0)
      },
      {
        'foo/\n@1',
        TypeIdentifier('foo', '\n', 1)
      },
      {
        'Type@1',
        TypeIdentifier(nil, 'Type@1', 0)
      },
      {
        'package/Type@1',
        TypeIdentifier('package', 'Type', 1)
      },
      {
        'package/Type@999',
        TypeIdentifier('package', 'Type', 999)
      },
      {
        'package/Type@X',
        TypeIdentifier('package', 'Type@X', 0)
      },
      {
        'package////@3@2@1@1',
        TypeIdentifier('package///', '@3@2@1', 1)
      }
    }
    for _, case in ipairs((cases)) do
      local got = parse_identifier(case[1])
      assert.are.same(case[2], got)
    end
  end)
end)
