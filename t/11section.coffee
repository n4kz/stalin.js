assert = require 'assert'
Ulfsaar = require '../lib/main'

check = (template, result, data) ->
	(fn) ->
		Ulfsaar fn, template
		assert.equal result, Ulfsaar[fn] data

(vows = require 'vows')

(vows = require 'vows')
	.describe('Check section logic')
	.addBatch
		'basic':
			topic: 'section'

			'empty false'     : check('{{#data}}{{/data}}',                '',         {})
			'text false'      : check('{{#data}}test{{/data}}',            '',         {})
			'prefix false'    : check('frr{{#data}}12{{/data}}',           'frr',      {})
			'postfix false'   : check('{{#data}}21{{/data}}rrf',           'rrf',      {})
			'both false'      : check('test{{#data}}{{/data}}rrf',         'testrrf',  {})
			'empty true'      : check('{{#data}}{{/data}}',                '',         data: true)
			'text true'       : check('{{#data}}test{{/data}}',            'test',     data: true)
			'prefix true'     : check('frr{{#data}}12{{/data}}',           'frr12',    data: true)
			'postfix true'    : check('{{#data}}12{{/data}}rrf',           '12rrf',    data: true)
			'both true'       : check('frr{{#data}}12{{/data}}rrf',        'frr12rrf', data: true)
			'spaces 1'        : check('frr{{  #data}}12{{/data}}rrf',      'frr12rrf', data: true)
			'spaces 2'        : check('frr{{#data  }}12{{/data}}rrf',      'frr12rrf', data: true)
			'spaces 3'        : check('frr{{#data}}12{{  /data}}rrf',      'frr12rrf', data: true)
			'spaces 4'        : check('frr{{#data}}12{{/data  }}rrf',      'frr12rrf', data: true)
			'spaces 5'        : check('frr{{ # data }}12{{ / data  }}rrf', 'frr12rrf', data: true)

			'false null'      : check('{{#data}}1{{/data}}', '',  data: null)
			'false undefined' : check('{{#data}}1{{/data}}', '',  data: undefined)
			'false zero'      : check('{{#data}}1{{/data}}', '',  data: 0)
			'false string'    : check('{{#data}}1{{/data}}', '',  data: '')
			'false array'     : check('{{#data}}1{{/data}}', '',  data: [])
			'false false'     : check('{{#data}}1{{/data}}', '',  data: false)
			'true true'       : check('{{#data}}1{{/data}}', '1', data: true)
			'true string'     : check('{{#data}}1{{/data}}', '1', data: ' ')
			'true number'     : check('{{#data}}1{{/data}}', '1', data: 1)
			'true object'     : check('{{#data}}1{{/data}}', '1', data: {})
			'true function'   : check('{{#data}}1{{/data}}', '1', data: ->)
			'true array'      : check('{{#data}}1{{/data}}', '1', data: [ 2 ])

			'unclosed': ->
				assert.throws ->
					check('{{#data}}', '', data: [])()

			'empty stack': ->
				assert.throws ->
					check('{{/data}}', '', data: [])()

			'mismatch': ->
				assert.throws ->
					check('{{#data}}{{/nodata}}', '', data: [])()

		'inverted':
			topic: 'section'

			'empty false'     : check('{{^data}}{{/data}}',                '',         {})
			'text false'      : check('{{^data}}test{{/data}}',            'test',     {})
			'prefix false'    : check('frr{{^data}}12{{/data}}',           'frr12',    {})
			'postfix false'   : check('{{^data}}21{{/data}}rrf',           '21rrf',    {})
			'both false'      : check('test{{^data}}2{{/data}}rrf',        'test2rrf', {})
			'empty true'      : check('{{^data}}{{/data}}',                '',         data: true)
			'text true'       : check('{{^data}}test{{/data}}',            '',         data: true)
			'prefix true'     : check('frr{{^data}}12{{/data}}',           'frr',      data: true)
			'postfix true'    : check('{{^data}}12{{/data}}rrf',           'rrf',      data: true)
			'both true'       : check('frr{{^data}}12{{/data}}rrf',        'frrrrf',   data: true)

			'spaces 1'        : check('frr{{  ^data}}12{{/data}}rrf',      'frrrrf', data: true)
			'spaces 2'        : check('frr{{^data  }}12{{/data}}rrf',      'frrrrf', data: true)
			'spaces 3'        : check('frr{{^data}}12{{  /data}}rrf',      'frrrrf', data: true)
			'spaces 4'        : check('frr{{^data}}12{{/data  }}rrf',      'frrrrf', data: true)
			'spaces 5'        : check('frr{{ ^ data }}12{{ / data  }}rrf', 'frrrrf', data: true)

			'false null'      : check('{{^data}}1{{/data}}', '1', data: null)
			'false undefined' : check('{{^data}}1{{/data}}', '1', data: undefined)
			'false zero'      : check('{{^data}}1{{/data}}', '1', data: 0)
			'false string'    : check('{{^data}}1{{/data}}', '1', data: '')
			'false array'     : check('{{^data}}1{{/data}}', '1', data: [])
			'false false'     : check('{{^data}}1{{/data}}', '1', data: false)
			'true true'       : check('{{^data}}1{{/data}}', '',  data: true)
			'true string'     : check('{{^data}}1{{/data}}', '',  data: ' ')
			'true number'     : check('{{^data}}1{{/data}}', '',  data: 1)
			'true object'     : check('{{^data}}1{{/data}}', '',  data: {})
			'true function'   : check('{{^data}}1{{/data}}', '',  data: ->)
			'true array'      : check('{{^data}}1{{/data}}', '',  data: [ 2 ])

			'unclosed': ->
				assert.throws ->
					check('{{^data}}', '', data: [])()

			'mismatch': ->
				assert.throws ->
					check('{{^data}}{{/nodata}}', '', data: [])()

		'loop':
			topic: 'section'

			'single'    : check('{{#data}}{{test}}{{/data}}',            'ok',     data: [ test: 'ok' ])
			'multi'     : check('{{#data}}{{test}}{{/data}}',            'ok12ok', data: [{ test: 'ok' }, { test: '12' }, { test: 'ok' }])
			'null'      : check('{{#data}}{{test}}{{/data}}',            'okok',   data: [ null, null ], test: 'ok')
			'undefined' : check('{{#data}}{{test}}{{/data}}',            'ok',     data: [ undefined ],  test: 'ok')
			'false'     : check('{{#data}}{{test}}{{/data}}',            'ok',     data: [ false ],      test: 'ok')
			'zero'      : check('{{#data}}{{test}}{{/data}}',            'ok',     data: [ 0 ],          test: 'ok')
			'function'  : check('{{#data}}{{test}}{{/data}}',            'ok',     data: [ -> ],         test: 'ok')
			'nested'    : check('{{#data}}{{#test}}1{{/test}}{{/data}}', '1111',   data: [ { test: [ 0, null ] }, { test: [ false, undefined ] } ])

		'property':
			topic: 'section'

			'single'     : check('{{#data.test}}{{name}}{{/data.test}}',     'ok', data: test: [ name: 'ok' ])
			'multilevel' : check('{{#data.test.name}}ok{{/data.test.name}}', 'ok', data: test: name: ['ok'])

		'scope':
			topic: 'section'

			'nested': check('{{#data}}{{#test}}{{a}}{{b}}{{/test}}{{/data}}', '6F9F7DEF', {
				b: 'F'
				a: 'E'
				data: [
					{
						test: [
							{ a: 6 },
							{ a: 9 }
						]
					},
					{
						test:
							a: 7
							b: 'D'
					},
					{
						test: {}
					}
				]
			})

			'nested property': check('{{#data}}{{a.b}}{{/data}}', 'EFG', {
				data: [{ a: b: 'E' }, null, { a: b: 'G' }],
				a: b: 'F'
			})

			'double': check('{{#data}}{{#data}}F{{/data}}{{/data}}', 'FFFF', data: [null, null])
			'double inverted': check('{{#data}}{{^data}}F{{/data}}{{/data}}', '', data: [null, null])
	.export module
