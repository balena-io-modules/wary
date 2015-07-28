m = require('mochainon')
Promise = require('bluebird')
fs = Promise.promisifyAll(require('fs'))
tmp = Promise.promisifyAll(require('tmp'))
_ = require('lodash')
unit = require('../lib/unit')

createFile = (contents) ->
	tmp.fileAsync().spread (path, fd) ->
		fs.writeFileAsync(path, contents).return(path)

describe 'Unit:', ->

	describe '.run()', ->

		describe 'given promised actions', ->

			it 'should throw an error if a file does not exist', ->
				promise = unit.run('should throw if file does not exist', hello: 'hellofoo', _.noop)
				m.chai.expect(promise).to.be.rejectedWith('ENOENT')

			describe 'given a temporal file', ->

				beforeEach (done) ->
					createFile('Hello World').then (path) =>
						@filePath = path
					.nodeify(done)

				afterEach (done) ->
					fs.unlink(@filePath, done)

				it 'should run a successful action with one file', (done) ->
					unit.run 'one file successful action', hello: @filePath, (files) ->
						m.chai.expect(_.keys(files)).to.deep.equal([ 'hello' ])
						readPromise = fs.readFileAsync(files.hello, encoding: 'utf8')
						m.chai.expect(readPromise).to.eventually.equal('Hello World')
					.nodeify(done)

				it 'should reject if the action rejects', ->
					promise = unit.run 'one file error action', hello: @filePath, (files) ->
						return Promise.reject(new Error('action error'))
					m.chai.expect(promise).to.be.rejectedWith('action error')

				it 'should remove the temporal file once it is done', (done) ->
					filePath = null
					unit.run 'one file error action', hello: @filePath, (files) ->
						filePath = files.hello
					.then ->
						existsPromise = Promise.fromNode (callback) ->
							fs.exists(filePath, _.partial(callback, null))
						m.chai.expect(existsPromise).to.eventually.be.false
					.nodeify(done)

				it 'should not reject if the file in test is removed by the action', ->
					promise = unit.run 'one file successful action', hello: @filePath, (files) ->
						fs.unlinkAsync(files.hello)
					m.chai.expect(promise).to.not.be.rejected

			describe 'given multiple temporal files', ->

				beforeEach (done) ->
					Promise.props
						foo: createFile('Foo Bar')
						hello: createFile('Hello World')
					.then (results) =>
						@files = results
					.nodeify(done)

				afterEach (done) ->
					Promise.all [
						fs.unlinkAsync(@files.foo)
						fs.unlinkAsync(@files.hello)
					]
					.nodeify(done)

				it 'should run a successful action with two file', (done) ->
					unit.run 'one file successful action', @files, (files) ->
						m.chai.expect(_.keys(files)).to.deep.equal([ 'foo', 'hello' ])

						helloReadPromise = fs.readFileAsync(files.hello, encoding: 'utf8')
						m.chai.expect(helloReadPromise).to.eventually.equal('Hello World')

						fooReadPromise = fs.readFileAsync(files.foo, encoding: 'utf8')
						m.chai.expect(fooReadPromise).to.eventually.equal('Foo Bar')
					.nodeify(done)
