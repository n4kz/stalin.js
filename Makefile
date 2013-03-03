min:
	uglifyjs lib/main.js -o ulfsaar.min.js --compress --mangle -r '_,Ulfsaar'

compile:
	coffee --lint --compile  t/*.coffee

test: compile
	vows --tap -i t/*.js

clean:
	rm ulfsaar.min.js t/*.js
