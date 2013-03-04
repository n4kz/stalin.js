# Test minified version if defined
MINIFIED=

min:
	uglifyjs lib/main.js -o ulfsaar.min.js --compress --mangle -r '_,Ulfsaar'

compile:
	coffee --lint --compile  t/*.coffee

ifdef MINIFIED
test: compile min
	MINIFIED=1 vows --tap -i t/*.js
else
test: compile
	vows --tap -i t/*.js
endif

clean:
	rm ulfsaar.min.js t/*.js
