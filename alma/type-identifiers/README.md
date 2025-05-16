# alma.type-identifiers module

Alma equivalent of [sanctuary-type-identifiers][1]. The specification is
compatible with Sanctuary's for Javascript.

A type is a set of values. Boolean, for example, is the type comprising `true`
and `false`. A value may be a member of multiple types (`42` is a member of
Number, PositiveNumber, Integer, and many other types).

In certain situations it is useful to divide Lua values into non-overlapping
types. The language provides the [`type`][2] function for this purpose, but it
doesn't support user-defined types.

alma.type-identifiers comprises:

  - a module for deriving the _type identifier_ of a Lua value; and
  - a specification which authors may follow to specify type identifiers for
	their types.

## Specification

For a type to be compatible with the algorithm:

  - every member of the type MUST have a `@@type` meta-value (the _type
	identifier_); and

  - the type identifier MUST be a string primitive and SHOULD have format
	`'<namespace>/<name>[@<version>]'`, where:

	  - `<namespace>` MUST consist of one or more characters, and SHOULD equal
		the name of the luarocks package which defines the type (including [the
		manifest or the Luarocks namespace][3] where appropriate);

	  - `<name>` MUST consist of one or more characters, and SHOULD be the
		unique name of the type; and

	  - `<version>` MUST consist of one or more digits, and SHOULD represent
		the version of the type.

If the type identifier does not conform to the format specified above, it is
assumed that the entire string represents the _name_ of the type; _namespace_
will be `null` and _version_ will be `0`.

If the _version_ is not given, it is assumed to be `0`.

[1]: https://github.com/sanctuary-js/sanctuary-type-identifiers
[2]: https://www.lua.org/manual/5.1/manual.html#pdf-type
[3]: https://github.com/luarocks/luarocks/blob/main/docs/namespaces.md#namespaces
