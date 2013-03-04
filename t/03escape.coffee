assert = require 'assert'
Ulfsaar = require process.env.MINIFIED and '../ulfsaar.min' or '../lib/main'

(vows = require 'vows')
	.describe('Check escape funtion')
	.addBatch
		'entities':
			topic: '{{data}}'

			'standalone': ->
				fn = Ulfsaar._.escape
				assert.equal fn('"\/"<<\n>>\''), '&#34;&#47;&#34;&#60;&#60;\n&#62;&#62;&#39;'
				assert.equal fn('<a>test</a>'), '&#60;a&#62;test&#60;&#47;a&#62;'

			'template': (topic) ->
				Ulfsaar 'escape', topic

				assert.equal '&#34;&#47;&#34;&#60;&#60;\n&#62;&#62;&#39;', Ulfsaar.escape data: '"\/"<<\n>>\''
				assert.equal '&#60;a&#62;test&#60;&#47;a&#62;', Ulfsaar.escape data: '<a>test</a>'

			'unescaped': (topic) ->
				Ulfsaar 'escape', '{{&data}}'

				assert.equal '"\/"<<\n>>\'', Ulfsaar.escape data: '"\/"<<\n>>\''
				assert.equal '<a>test</a>', Ulfsaar.escape data: '<a>test</a>'

	.export module
