# alma.type-classes

Alma equivalent of [sanctuary-type-classes][1].

The [Fantasy Land Specification][2] "specifies interoperability of common
algebraic structures" by defining a number of type classes. For each type
class, it states laws which every member of a type must obey in order for the
type to be a member of the type class. In order for the Maybe type to be
considered a [Functor][3], for example, every `Maybe a` value must have a
`fantasy-land/map` method which obeys the identity and composition laws.

This project provides:

* `TypeClass`, a function for defining type classes;
* one `TypeClass` value for each Fantasy Land type class;
* lawful Fantasy Land methods for Lua's built-in types;
* one function for each Fantasy Land method; and
* several functions derived from these functions.

[1]: https://github.com/sanctuary-js/sanctuary-type-classes
[2]: https://github.com/fantasyland/fantasy-land/tree/v5.0.0
[3]: https://github.com/fantasyland/fantasy-land/tree/v5.0.0#functor
