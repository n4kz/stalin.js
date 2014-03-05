assert = require 'assert'
Stalin = require process.env.MINIFIED and '../stalin.min' or '../lib/main'

check = (template, result, data) ->
	(fn) ->
		Stalin fn, template
		assert.equal result, Stalin[fn] data

(vows = require 'vows')
	.describe('Check iterator')
	.addBatch
		'basic':
			topic: 'iterator'

			'simple'           : check('{{#data}}{{.}}{{/data}}',   '&#60;',           data: '<')
			'simple unescaped' : check('{{#data}}{{&.}}{{/data}}',  '<',               data: '<')
			'space 1'          : check('{{#data}}{{ .}}{{/data}}',  'A',               data: 'A')
			'space 2'          : check('{{#data}}{{. }}{{/data}}',  'A',               data: 'A')
			'space 3'          : check('{{#data}}{{ . }}{{/data}}', 'A',               data: 'A')
			'multi'            : check('{{#data}}{{.}}:{{/data}}',  '&#60;:B:C:',      data: '<BC'.split(''))
			'multi unescaped'  : check('{{#data}}{{&.}}:{{/data}}', '<:B:C:',          data: '<BC'.split(''))
			'null'             : check('{{#data}}{{.}}{{/data}}',   '',                data: [null])
			'undefined'        : check('{{#data}}{{.}}{{/data}}',   '',                data: [undefined])
			'false'            : check('{{#data}}{{.}}{{/data}}',   '',                data: [false])
			'zero'             : check('{{#data}}{{.}}{{/data}}',   '0',               data: [0])
			'number'           : check('{{#data}}{{.}}{{/data}}',   '1',               data: 1)
			'float'            : check('{{#data}}{{.}}{{/data}}',   '1.15',            data: 1.15)
			'object'           : check('{{#data}}{{.}}{{/data}}',   '[object Object]', data: {})

		'scope':
			topic: 'iterator'

			'inverted' : check('{{#data}}{{^test}}{{.}}{{/test}}{{/data}}', 'FF', data: 'FF')
			'nested'   : check('{{#data}}{{#test}}{{.}}{{/test}}{{/data}}', 'E',  { data: 'F', test: 'E'})
			'section'  : check('{{#data}}{{#.}}{{name}}{{/.}}{{/data}}',    'EF', { data: [{ name: 'E' }, { name: 'F' }], name: 'G' })

		'exceptions':
			topic: 'iterator'

			'not in loop': ->
				assert.throws check '{{.}}', '', {}

			'in inverted': ->
				assert.throws check '{{^data}}{{.}}{{/data}}', '', {}

			'in nested inverted': ->
				assert.throws check '{{^test}}{{^data}}{{.}}{{/data}}{{/test}}', '', {}

			'not in loop unescaped': ->
				assert.throws check '{{&.}}', '', {}

			'in inverted unescaped': ->
				assert.throws check '{{^data}}{{&.}}{{/data}}', '', {}

			'after section': ->
				assert.throws check '{{#data}}E{{/data}}{{.}}', 'E', data: 'F'

	.export module
