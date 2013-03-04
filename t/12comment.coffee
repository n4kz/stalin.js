assert = require 'assert'
Ulfsaar = require process.env.MINIFIED and '../ulfsaar.min' or '../lib/main'

check = (template, result, data) ->
	(fn) ->
		Ulfsaar fn, template
		assert.equal result, Ulfsaar[fn] data

(vows = require 'vows')
	.describe('Check comments')
	.addBatch
		'main':
			topic: 'comment'

			'single'       : check('{{!data}}',                     '',            data: 'TEST')
			'multiple'     : check('{{!data}} {{!data}}',           ' ',           data: 'TEST')
			'prefix'       : check('test {{!data}}',                'test ',       data: 'TEST')
			'postfix'      : check('{{!data}} test',                ' test',       data: 'TEST')
			'both'         : check('pre {{!data}} post',            'pre  post',   data: 'TEST')
			'spaces left'  : check('{{!  data}}',                   '',            data: 'TEST')
			'spaces right' : check('{{!data  }}',                   '',            data: 'TEST')
			'spaces both'  : check('{{ ! data }}',                  '',            data: 'TEST')
			'text'         : check('{{ ! My comment. Ignore it }}', '',            {})

	.export module
