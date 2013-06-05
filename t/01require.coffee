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
				assert.equal Object.keys(stalin).length, 1
				assert.isUndefined global.Stalin

			'Stalin._': (topic) ->
				_ = topic.stalin._

				assert.isObject _
				assert.isFunction _.fn
				assert.isFunction _.compile

	.export module
