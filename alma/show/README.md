# alma.show

Alma equivalent of [sanctuary-show][1]. It is adapted to Lua and due to the differences between Javascript and Lua, the output is not compatible.

Haskell has a show function which can be applied to a compatible value to produce a descriptive string representation of that value. The idea is that the string representation should, if possible, be an expression which would produce the original value if evaluated.

This library provides a similar `show` function.

In general, this property should hold: `assert(loadstring( show(x) ))() == x`.

One can make values of a custom type compatible with `show` by defining a `@@show` meta-method.

[1]: https://github.com/sanctuary-js/sanctuary-show
