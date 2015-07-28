m = require('mochainon')
_ = require('lodash')
BluebirdQueue = require('bluebird-queue')
wary = require('../lib/wary')

describe 'Wary:', ->

	afterEach ->

		# Hacky way to reset the tests
		wary.tests = new BluebirdQueue(concurrency: 1)

	describe '.it()', ->

		it 'should add a test', ->
			m.chai.expect(wary.tests._queue).to.have.length(0)
			wary.it('should pass', {}, _.noop)
			m.chai.expect(wary.tests._queue).to.have.length(1)

	describe '.run()', ->

		describe 'given one test', ->

			beforeEach ->
				@testSpy = m.sinon.spy()
				wary.it('should pass', {}, @testSpy)

			it 'should run the test', (done) ->
				wary.run().then =>
					m.chai.expect(@testSpy).to.have.been.calledOnce
				.nodeify(done)

		describe 'given multiple tests', ->

			beforeEach ->
				@test1Spy = m.sinon.spy()
				@test2Spy = m.sinon.spy()

				wary.it('first test', {}, @test1Spy)
				wary.it('second test', {}, @test2Spy)

			it 'should run all tests', (done) ->
				wary.run().then =>
					m.chai.expect(@test1Spy).to.have.been.calledOnce
					m.chai.expect(@test2Spy).to.have.been.calledOnce
				.nodeify(done)
