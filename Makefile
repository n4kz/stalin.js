all: test test-min

BENCH=stalin hogan

min:
	uglifyjs lib/main.js -o stalin.min.js --compress --mangle

compile:
	coffee --compile t/*.coffee

test-min: compile min
	MINIFIED=1 vows --tap -i t/*.js

test: compile
	vows --tap -i t/*.js

bench:
	script/bench.sh $(BENCH)

clean:
	rm -f t/*.js
