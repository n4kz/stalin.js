#!/bin/bash
for compiler in $@
	do coffee script/bench.coffee $compiler
done
