all: test test-min

min:
	uglifyjs lib/main.js -o ulfsaar.min.js --compress --mangle -r '_,Ulfsaar'

compile:
	coffee --lint --compile  t/*.coffee

test-min: compile min
	MINIFIED=1 vows --tap -i t/*.js

test: compile
	vows --tap -i t/*.js

clean:
	rm -f t/*.js
