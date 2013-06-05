assert = require 'assert'
Stalin = require process.env.MINIFIED and '../stalin.min' or '../lib/main'

check = (template, result, data) ->
	(fn) ->
		Stalin fn, template
		assert.equal result, Stalin[fn] data

Stalin.wrap = (scope, escape) ->
	':' + scope('data') + ':'

(vows = require 'vows')
	.describe('Check delimiter')
	.addBatch
		'basic':
			topic: 'basic'

			'percent' : check('{{=% %=}}%data%{{data}}',         '{{data}}')
			'angle'   : check('{{=< >=}}<data>{{data}}',         '{{data}}')
			'equal'   : check('{{== ==}}=data={{data}}',         '{{data}}')
			'complex' : check('{{=<%= =%>=}}<%=data=%>{{data}}', '{{data}}')

		'data':
			topic: 'data'

			'percent' : check('{{data}}{{=% %=}}%data%',         'FF', data: 'F')
			'angle'   : check('{{data}}{{=< >=}}<data>',         'FF', data: 'F')
			'equal'   : check('{{data}}{{== ==}}=data=',         'FF', data: 'F')
			'complex' : check('{{data}}{{=<%= =%>=}}<%=data=%>', 'FF', data: 'F')

		'double':
			topic: 'double'

			'percent' : check('{{data}}{{=% %=}}a%data%b%={{ }}=%{{data}}c', 'FaFbFc', data: 'F')
			'angle'   : check('{{data}}{{=< >=}}a<data>b<={{ }}=>{{data}}c', 'FaFbFc', data: 'F')
			'equal'   : check('{{data}}{{== ==}}a=data=b=={{ }}=={{data}}c', 'FaFbFc', data: 'F')

		'section':
			topic: 'section'

			'normal'   : check('{{=% %=}}%#data%%.%%/data%',   '1234', data: [1, 2, 3, 4])
			'inverted' : check('{{=% %=}}%^data%%.%%/data%',   '',     data: [1, 2, 3, 4])
			'nested'   : check('{{#data}}{{=% %=}}%.%%/data%', '1234', data: [1, 2, 3, 4])

		'partial':
			topic: 'partial'

			'basic' : check('{{=% %=}}%>wrap%', '::::', data: '::')
			'angle' : check('{{=< >=}}<>wrap>', '::::', data: '::')
	.export module
