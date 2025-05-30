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
	"moonscript ~> 0.5",
}
test = {
	type = "busted",
}
build = {
	type = "builtin",
	modules = {
		["alma.compat"] = "alma/compat/init.lua",
		["alma.meta"] = "alma/meta/init.lua",
		["alma.show"] = "alma/show/init.lua",
		["alma.type-classes"] = "alma/type-classes/init.lua",
		["alma.type-classes.Function"] = "alma/type-classes/Function.lua",
		["alma.type-identifiers"] = "alma/type-identifiers/init.lua",
	}
}
