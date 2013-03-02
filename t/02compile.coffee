assert = require 'assert'
Ulfsaar = require '../lib/main'

(vows = require 'vows')
	.describe('Check compilation')
	.addBatch
		'Ulfsaar':
			topic: 'template'

			'compilation': (topic) ->
				Ulfsaar('a', topic)

				assert.isFunction Ulfsaar.a
				assert.equal Ulfsaar.a(), topic

			'recompilation': (topic) ->
				fn = 'b'

				# Compile function
				Ulfsaar fn, topic
				assert.isFunction Ulfsaar[fn]
				initial = Ulfsaar[fn]

				# Replace it
				Ulfsaar fn, topic
				assert.isFunction Ulfsaar[fn]

				# Function recompiled
				assert.notEqual initial, Ulfsaar[fn]

				# Right result
				assert.equal Ulfsaar[fn](), topic
				assert.equal Ulfsaar[fn]({}), topic

			'parameters': (topic) ->
				fn = 'c'

				# Buffer
				Ulfsaar fn, new Buffer(topic)
				assert.equal Ulfsaar[fn](), topic

				# Empty string
				Ulfsaar fn, ''
				assert.equal Ulfsaar[fn](), ''

				# Line ending
				# \r should be replaced by \n
				Ulfsaar fn, '\n\r\n'
				assert.equal Ulfsaar[fn](), '\n\n\n'

				# Number
				Ulfsaar fn, 0
				assert.equal Ulfsaar[fn](), 0

				# null
				assert.throws ->
					Ulfsaar fn, null

				# undefined
				assert.throws ->
					Ulfsaar fn

				# Compiled function was not modified
				assert.equal Ulfsaar[fn](), 0

		'Ulfsaar._.fn':
			topic: 'example'

			'compilation': (topic) ->
				count = Object.keys(Ulfsaar).length
				fn = Ulfsaar._.fn(topic)

				# Function compiled
				assert.isFunction fn

				# Keys count were not changed
				assert.equal count, Object.keys(Ulfsaar).length

				# Function returns right result
				assert.equal fn(), topic
				assert.equal fn({}), topic

		'Ulfsaar._.compile':
			topic: 'new example'

			'compilation': (topic) ->
				fn = Ulfsaar._.compile
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
