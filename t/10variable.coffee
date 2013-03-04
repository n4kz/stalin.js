assert = require 'assert'
Ulfsaar = require '../lib/main'

check = (template, result, data) ->
	(fn) ->
		Ulfsaar fn, template
		assert.equal result, Ulfsaar[fn] data

(vows = require 'vows')
	.describe('Check variable interpolation')
	.addBatch
		'basic':
			topic: 'interpolation'

			'empty'        : check('{{data}}',          '',                {})
			'boolean false': check('{{data}}',          '',                { data: false })
			'boolean true' : check('{{data}}',          'true',            { data: true })
			'undefined'    : check('{{data}}',          '',                { data: undefined })
			'null'         : check('{{data}}',          '',                { data: null })
			'zero'         : check('{{data}}',          '0',               { data: 0 })
			'number'       : check('{{data}}',          '1',               { data: 1 })
			'float'        : check('{{data}}',          '1.15',            { data: 1.15 })
			'object'       : check('{{data}}',          '[object Object]', { data: {} })
			'array'        : check('{{data}}',          '',                { data: [] })
			'function'     : check('{{data}}',          'function () {}',  { data: -> })
			'single'       : check('{{data}}',          'TEST',            data: 'TEST')
			'multiple'     : check('{{data}} {{data}}', 'TEST TEST',       data: 'TEST')
			'prefix'       : check('test {{data}}',     'test TEST',       data: 'TEST')
			'postfix'      : check('{{data}} test',     'TEST test',       data: 'TEST')
			'both'         : check('pre {{data}} post', 'pre TEST post',   data: 'TEST')
			'spaces left'  : check('{{  data}}',        'TEST',            data: 'TEST')
			'spaces right' : check('{{data  }}',        'TEST',            data: 'TEST')
			'spaces both'  : check('{{ data }}',        'TEST',            data: 'TEST')

		'unescaped':
			topic: 'interpolation'

			'empty'        : check('{{&data}}',           '',                {})
			'boolean false': check('{{data}}',            '',                { data: false })
			'boolean true' : check('{{data}}',            'true',            { data: true })
			'undefined'    : check('{{&data}}',           '',                { data: undefined })
			'null'         : check('{{&data}}',           '',                { data: null })
			'zero'         : check('{{&data}}',           '0',               { data: 0 })
			'number'       : check('{{&data}}',           '1',               { data: 1 })
			'float'        : check('{{&data}}',           '1.15',            { data: 1.15 })
			'object'       : check('{{&data}}',           '[object Object]', { data: {} })
			'array'        : check('{{data}}',            '',                { data: [] })
			'function'     : check('{{&data}}',           'function () {}',  { data: -> })
			'single'       : check('{{&data}}',           'TEST',            data: 'TEST')
			'multiple'     : check('{{&data}} {{&data}}', 'TEST TEST',       data: 'TEST')
			'prefix'       : check('test {{&data}}',      'test TEST',       data: 'TEST')
			'postfix'      : check('{{&data}} test',      'TEST test',       data: 'TEST')
			'both'         : check('pre {{&data}} post',  'pre TEST post',   data: 'TEST')
			'spaces left'  : check('{{&   data}}',        'TEST',            data: 'TEST')
			'spaces right' : check('{{&data   }}',        'TEST',            data: 'TEST')
			'spaces mid'   : check('{{&   data}}',        'TEST',            data: 'TEST')
			'spaces both'  : check('{{ & data }}',        'TEST',            data: 'TEST')

		'property':
			topic: 'interpolation'

			'single'       : check('{{data.text}}',               'TEST',          data: text: 'TEST')
			'multiple'     : check('{{data.text}} {{data.text}}', 'TEST TEST',     data: text: 'TEST')
			'prefix'       : check('test {{data.text}}',          'test TEST',     data: text: 'TEST')
			'postfix'      : check('{{data.text}} test',          'TEST test',     data: text: 'TEST')
			'both'         : check('pre {{data.text}} post',      'pre TEST post', data: text: 'TEST')
			'spaces left'  : check('{{  data.text}}',             'TEST',          data: text: 'TEST')
			'spaces right' : check('{{data.text  }}',             'TEST',          data: text: 'TEST')
			'spaces both'  : check('{{ data.text }}',             'TEST',          data: text: 'TEST')
			'multilevel'   : check('{{data.text.a}}',             'TEST',          data: text: a: 'TEST')

		'unescaped property':
			topic: 'interpolation'

			'single'       : check('{{&data.text}}',                'TEST',          data: text: 'TEST')
			'multiple'     : check('{{&data.text}} {{&data.text}}', 'TEST TEST',     data: text: 'TEST')
			'prefix'       : check('test {{&data.text}}',           'test TEST',     data: text: 'TEST')
			'postfix'      : check('{{&data.text}} test',           'TEST test',     data: text: 'TEST')
			'both'         : check('pre {{&data.text}} post',       'pre TEST post', data: text: 'TEST')
			'spaces left'  : check('{{&  data.text}}',              'TEST',          data: text: 'TEST')
			'spaces right' : check('{{&data.text  }}',              'TEST',          data: text: 'TEST')
			'spaces both'  : check('{{& data.text }}',              'TEST',          data: text: 'TEST')
			'multilevel'   : check('{{&data.text.a}}',              'TEST',          data: text: a: 'TEST')

	.export module
