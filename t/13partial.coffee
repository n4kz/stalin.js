assert = require 'assert'
Ulfsaar = require process.env.MINIFIED and '../ulfsaar.min' or '../lib/main'

check = (template, result, data) ->
	(fn) ->
		Ulfsaar fn, template
		assert.equal result, Ulfsaar[fn] data

Ulfsaar.wrap = (scope, escape) ->
	':' + scope('data') + ':'

Ulfsaar('double', '{{data}}{{data}}')

(vows = require 'vows')
	.describe('Check partial logic')
	.addBatch
		'helper':
			topic: 'helper'

			'empty'     : check('{{>wrap}}',              ':F:',        data: 'F')
			'prefix'    : check('frr{{>wrap}}',           'frr:F:',     data: 'F')
			'postfix'   : check('{{>wrap}}rrf',           ':F:rrf',     data: 'F')
			'both'      : check('test{{>wrap}}rrf',       'test:F:rrf', data: 'F')

			'spaces 1'  : check('frr{{  >wrap}}rrf',      'frr:F:rrf',  data: 'F')
			'spaces 2'  : check('frr{{>wrap  }}rrf',      'frr:F:rrf',  data: 'F')
			'spaces 3'  : check('frr{{>  wrap}}rrf',      'frr:F:rrf',  data: 'F')
			'spaces 4'  : check('frr{{ > wrap }}rrf',     'frr:F:rrf',  data: 'F')

			'exception' : ->
				assert.throws check('{{>wrap1}}', '', {})

			'scope'     : check('{{>wrap}}{{#meta}}{{>wrap}}{{/meta}}', ':F::E::F:',
				data: 'F'
				meta: [{ data: 'E' }, null]
			)

		'include':
			topic: 'include'

			'empty'     : check('{{>double}}',              'FF',        data: 'F')
			'prefix'    : check('frr{{>double}}',           'frrFF',     data: 'F')
			'postfix'   : check('{{>double}}rrf',           'FFrrf',     data: 'F')
			'both'      : check('test{{>double}}rrf',       'testFFrrf', data: 'F')

			'spaces 1'  : check('frr{{  >double}}rrf',      'frrFFrrf',  data: 'F')
			'spaces 2'  : check('frr{{>double  }}rrf',      'frrFFrrf',  data: 'F')
			'spaces 3'  : check('frr{{>  double}}rrf',      'frrFFrrf',  data: 'F')
			'spaces 4'  : check('frr{{ > double }}rrf',     'frrFFrrf',  data: 'F')

			'exception' : ->
				assert.throws check('{{>double1}}', '', {})

			'scope'     : check('{{>double}}{{#meta}}{{>double}}{{/meta}}', 'FFEEFF',
				data: 'F'
				meta: [{ data: 'E' }, null]
			)

	.export module
