rockspec_format = "3.0"
package = "alma"
version = "dev-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1, < 5.5"
}
test_dependencies = {
	"busted ~> 2.2",
	"inspect ~> 3.1",
	"luacov ~> 0.16",
	"luacov-multiple ~> 0.6",
	"yuescript ~> 0.27",
}
build = {
   type = "builtin",
   modules = {}
}
