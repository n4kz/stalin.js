assert = require 'assert'
Stalin = require process.env.MINIFIED and '../stalin.min' or '../lib/main'

(vows = require 'vows')
	.describe('Check escape funtion')
	.addBatch
		'entities':
			topic: '{{data}}'

			'template': (topic) ->
				Stalin 'escape', topic

				assert.equal '&#34;&#47;&#34;&#60;&#60;\n&#62;&#62;&#39;', Stalin.escape data: '"\/"<<\n>>\''
				assert.equal '&#60;a&#62;test&#60;&#47;a&#62;', Stalin.escape data: '<a>test</a>'

			'unescaped': (topic) ->
				Stalin 'escape', '{{&data}}'

				assert.equal '"\/"<<\n>>\'', Stalin.escape data: '"\/"<<\n>>\''
				assert.equal '<a>test</a>', Stalin.escape data: '<a>test</a>'

	.export module
