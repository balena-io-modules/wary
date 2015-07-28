m = require('mochainon')
Promise = require('bluebird')
utils = require('../lib/utils')

describe 'Utils:', ->

	describe '.promiseMapValues()', ->

		describe 'given a promised iterator that exclamates strings', ->

			beforeEach ->
				@iterator = (value) ->
					return Promise.delay(100).return("#{value}!!")

			it 'should map trough object values', (done) ->
				object =
					foo: 'foo'
					bar: 'bar'
					baz: 'baz'

				utils.promiseMapValues(object, @iterator).then (mappedObject) ->
					m.chai.expect(mappedObject).to.deep.equal
						foo: 'foo!!'
						bar: 'bar!!'
						baz: 'baz!!'
				.nodeify(done)

		describe 'given an iterator that rejects', ->

			beforeEach ->
				@iterator = ->
					return Promise.reject(new Error('iterator error'))

			it 'should be rejected', ->
				promise = utils.promiseMapValues(foo: 'bar', @iterator)
				m.chai.expect(promise).to.be.rejectedWith('iterator error')
