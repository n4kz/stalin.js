assert = require 'assert'

(vows = require 'vows')
	.describe('Check module consistency')
	.addBatch
		'require':
			'topic':
				stalin: require process.env.MINIFIED and '../stalin.min' or '../lib/main'

			'Stalin': (topic) ->
				stalin = topic.stalin

				assert.isFunction stalin
				assert.equal Object.keys(stalin).length, 2
				assert.isUndefined global.Stalin

			'Stalin#functions': (topic) ->
				stalin = topic.stalin

				assert.isFunction stalin.process
				assert.isFunction stalin.compile

	.export module
