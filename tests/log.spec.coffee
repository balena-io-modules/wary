m = require('mochainon')
log = require('../lib/log')

describe 'Log:', ->

	describe '.unit()', ->

		it 'should return a string', ->
			m.chai.expect(log.unit('Hello')).to.be.a('string')

		it 'should return undefined if no description', ->
			m.chai.expect(log.unit(null)).to.be.undefined
