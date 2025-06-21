# force posix-compatible behaviour
.POSIX:

.PHONY: test testcov rock build lint clean

test: build
	busted ${BUSTED_ARGS}

testcov: build
	busted --run coverage ${BUSTED_ARGS}
	xdg-open luacov_html/index.html

rock: build
	luarocks --lua-version=5.1 make --pack-binary-rock alma-dev-1.rockspec

build:
	moonc alma spec

lint:
	moonc -l alma spec

clean:
	find {spec,alma} -name "*.lua" -type f -delete
	find {.,spec,alma} -name "*.out" -type f -delete
