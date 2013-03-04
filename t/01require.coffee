assert = require 'assert'

(vows = require 'vows')
	.describe('Check module consistency')
	.addBatch
		'require':
			'topic':
				ulfsaar: require process.env.MINIFIED and '../ulfsaar.min' or '../lib/main'

			'Ulfsaar': (topic) ->
				ulfsaar = topic.ulfsaar

				assert.isFunction ulfsaar
				assert.equal Object.keys(ulfsaar).length, 1
				assert.isUndefined global.Ulfsaar

			'Ulfsaar._': (topic) ->
				_ = topic.ulfsaar._

				assert.isObject _
				assert.isFunction _.fn
				assert.isFunction _.compile
				assert.isFunction _.escape

	.export module
