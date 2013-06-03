assert = require 'assert'
Stalin = require process.env.MINIFIED and '../stalin.min' or '../lib/main'

(vows = require 'vows')
	.describe('Check compilation')
	.addBatch
		'Stalin':
			topic: 'template'

			'compilation': (topic) ->
				assert.isFunction Stalin('a', topic)
				assert.isFunction Stalin.a
				assert.equal Stalin.a(), topic

			'recompilation': (topic) ->
				fn = 'b'

				# Compile function
				assert.isFunction Stalin fn, topic
				assert.isFunction Stalin[fn]
				initial = Stalin[fn]

				# Replace it
				assert.isFunction Stalin fn, topic
				assert.isFunction Stalin[fn]

				# Function recompiled
				assert.notEqual initial, Stalin[fn]

				# Right result
				assert.equal Stalin[fn](), topic
				assert.equal Stalin[fn]({}), topic

			'parameters': (topic) ->
				fn = 'c'

				# Buffer
				Stalin fn, new Buffer(topic)
				assert.equal Stalin[fn](), topic

				# Empty string
				Stalin fn, ''
				assert.equal Stalin[fn](), ''

				# Line ending
				# \r should be replaced by \n
				Stalin fn, '\n\r\n'
				assert.equal Stalin[fn](), '\n\n\n'

				# Number
				Stalin fn, 0
				assert.equal Stalin[fn](), 0

				# null
				assert.throws ->
					Stalin fn, null

				# undefined
				assert.throws ->
					Stalin fn

				# Compiled function was not modified
				assert.equal Stalin[fn](), 0

		'Stalin._.fn':
			topic: 'example'

			'compilation': (topic) ->
				count = Object.keys(Stalin).length
				fn = Stalin._.fn(topic)

				# Function compiled
				assert.isFunction fn

				# Keys count were not changed
				assert.equal count, Object.keys(Stalin).length

				# Function returns right result
				assert.equal fn(), topic
				assert.equal fn({}), topic

		'Stalin._.compile':
			topic: 'new example'

			'compilation': (topic) ->
				fn = Stalin._.compile
				template = fn topic
				result = null

				# Check compilation result
				assert.isString template
				assert.notEqual template, topic
				assert.include template, topic

				# Same result on second call
				assert.equal template, fn topic

				# Compile by hand
				assert.doesNotThrow ->
					result = new Function 'S', template

				assert.isFunction result

				# Execute and check  result
				assert.equal result(), topic

	.export module
