assert = require 'assert'
Stalin = require process.env.MINIFIED and '../stalin.min' or '../lib/main'

check = (template, result, data) ->
	(fn) ->
		Stalin fn, template
		assert.equal result, Stalin[fn] data

(vows = require 'vows')
	.describe('Check variable interpolation')
	.addBatch
		'basic':
			topic: 'interpolation'

			'no data'      : check('{{data}}',          '')
			'null data'    : check('{{data}}',          '',                null)
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

			'no data'      : check('{{&data}}',           '')
			'null data'    : check('{{&data}}',           '',                null)
			'empty'        : check('{{&data}}',           '',                {})
			'boolean false': check('{{&data}}',           '',                { data: false })
			'boolean true' : check('{{&data}}',           'true',            { data: true })
			'undefined'    : check('{{&data}}',           '',                { data: undefined })
			'null'         : check('{{&data}}',           '',                { data: null })
			'zero'         : check('{{&data}}',           '0',               { data: 0 })
			'number'       : check('{{&data}}',           '1',               { data: 1 })
			'float'        : check('{{&data}}',           '1.15',            { data: 1.15 })
			'object'       : check('{{&data}}',           '[object Object]', { data: {} })
			'array'        : check('{{&data}}',           '',                { data: [] })
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

			'no data'      : check('{{data.text.a}}',             '')
			'null data'    : check('{{data.text.a}}',             '',              null)
			'single'       : check('{{data.text}}',               'TEST',          data: text: 'TEST')
			'multiple'     : check('{{data.text}} {{data.text}}', 'TEST TEST',     data: text: 'TEST')
			'prefix'       : check('test {{data.text}}',          'test TEST',     data: text: 'TEST')
			'postfix'      : check('{{data.text}} test',          'TEST test',     data: text: 'TEST')
			'both'         : check('pre {{data.text}} post',      'pre TEST post', data: text: 'TEST')
			'spaces left'  : check('{{  data.text}}',             'TEST',          data: text: 'TEST')
			'spaces right' : check('{{data.text  }}',             'TEST',          data: text: 'TEST')
			'spaces both'  : check('{{ data.text }}',             'TEST',          data: text: 'TEST')
			'multilevel'   : check('{{data.text.a}}',             'TEST',          data: text: a: 'TEST')
			'missed'       : check('{{data.text.a}}',             '',              data: test: 1)

		'unescaped property':
			topic: 'interpolation'

			'no data'      : check('{{&data.text.a}}',              '')
			'null data'    : check('{{&data.text.a}}',              '',              null)
			'single'       : check('{{&data.text}}',                'TEST',          data: text: 'TEST')
			'multiple'     : check('{{&data.text}} {{&data.text}}', 'TEST TEST',     data: text: 'TEST')
			'prefix'       : check('test {{&data.text}}',           'test TEST',     data: text: 'TEST')
			'postfix'      : check('{{&data.text}} test',           'TEST test',     data: text: 'TEST')
			'both'         : check('pre {{&data.text}} post',       'pre TEST post', data: text: 'TEST')
			'spaces left'  : check('{{&  data.text}}',              'TEST',          data: text: 'TEST')
			'spaces right' : check('{{&data.text  }}',              'TEST',          data: text: 'TEST')
			'spaces both'  : check('{{& data.text }}',              'TEST',          data: text: 'TEST')
			'multilevel'   : check('{{&data.text.a}}',              'TEST',          data: text: a: 'TEST')
			'missed'       : check('{{&data.text.a}}',              '',              data: test: 1)

	.export module
