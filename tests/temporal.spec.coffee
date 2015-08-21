m = require('mochainon')
tmp = require('tmp')
path = require('path')
Promise = require('bluebird')
fs = Promise.promisifyAll(require('fs-extra'))
temporal = require('../lib/temporal')

describe 'Temporal:', ->

	describe '.fromFile()', ->

		describe 'given a file', ->

			beforeEach (done) ->
				tmp.file (error, file, fd) =>
					return done(error) if error?
					@filePath = file
					fs.writeFile(file, 'Hello World', done)

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

		describe 'given a directory', ->

			beforeEach (done) ->
				tmp.dir (error, directory, fd) =>
					return done(error) if error?
					@directoryPath = directory
					fs.writeFile(path.join(directory, 'foo.txt'), 'Hello World', done)

			afterEach (done) ->
				fs.remove(@directoryPath, done)

			it 'should create a temporal directory', (done) ->
				temporal.fromFile(@directoryPath).then (temporalPath) =>
					m.chai.expect(@directoryPath).to.not.equal(temporalPath)
					return fs.removeAsync(temporalPath)
				.nodeify(done)

			it 'should be a copy of the directory', (done) ->
				temporal.fromFile(@directoryPath).then (temporalPath) ->
					file = path.join(temporalPath, 'foo.txt')
					readPromise = fs.readFileAsync(file, encoding: 'utf8')
					m.chai.expect(readPromise).to.eventually.equal('Hello World')
					return fs.removeAsync(temporalPath)
				.nodeify(done)

		describe 'given the file does not exist', ->

			it 'should reject with an error message', ->
				promise = temporal.fromFile('foobar.baz')
				m.chai.expect(promise).to.be.rejectedWith('ENOENT')
