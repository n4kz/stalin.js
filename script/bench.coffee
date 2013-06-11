template = """
	{{#data}}
		{{#block.length}}
			{{#block}}
				<div>
					{{#list.length}}
					<ul>
						{{#list}}
							<a{{^href}} href="javascript:void(0);"{{/href}}{{#attrs}} {{&attrs}}{{/attrs}}>{{title}}</a>
						{{/list}}
					</ul>
					{{/list.length}}
				</div>
			{{/block}}
		{{/block.length}}
	{{/data}}
"""

fn = null

switch process.argv[2]
	when 'hogan'
		Hogan = require 'hogan.js'
		fn = Hogan.compile template
		fn = fn.render.bind fn

	when 'stalin'
		Stalin = require '../lib/main'
		fn = Stalin.compile template

	when 'milk'
		Milk = require 'milk'
		fn = Milk.render.bind template

	when 'mustache'
		Mustache = require 'mustache'
		fn = Mustache.compile template

	else
		process.exit(1)

data =
	attrs: 'target="_blank"'
	data:
		block: []

blocks   = 1000
elements = 1000

while blocks--
	remains = elements
	list = []

	while remains--
		list.push
			href: !!(remains % 10)
			title: (new Date()).toUTCString()

	data.data.block.push
		list: list

# Warm up
fn data if process.env['BENCH_WARM']

start = Date.now()

fn data

end = Date.now()

console.log "#{process.argv[2]}: #{end - start}ms"
