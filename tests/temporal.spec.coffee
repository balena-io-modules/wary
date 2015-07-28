m = require('mochainon')
tmp = require('tmp')
Promise = require('bluebird')
fs = Promise.promisifyAll(require('fs'))
temporal = require('../lib/temporal')

describe 'Temporal:', ->

	describe '.fromFile()', ->

		describe 'given a file', ->

			beforeEach (done) ->
				tmp.file (error, path, fd) =>
					return done(error) if error?
					@filePath = path
					fs.writeFile(path, 'Hello World', done)

			afterEach (done) ->
				fs.unlink(@filePath, done)

			it 'should create a temporal file', (done) ->
				temporal.fromFile(@filePath).then (temporalPath) =>
					m.chai.expect(@filePath).to.not.equal(temporalPath)
					return fs.unlinkAsync(temporalPath)
				.nodeify(done)

			it 'should be a copy of the file', (done) ->
				temporal.fromFile(@filePath).then (temporalPath) ->
					readPromise = fs.readFileAsync(temporalPath, encoding: 'utf8')
					m.chai.expect(readPromise).to.eventually.equal('Hello World')
					return fs.unlinkAsync(temporalPath)
				.nodeify(done)

		describe 'given the file does not exist', ->

			it 'should reject with an error message', ->
				promise = temporal.fromFile('foobar.baz')
				m.chai.expect(promise).to.be.rejectedWith('ENOENT')
