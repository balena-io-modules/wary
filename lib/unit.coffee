###
The MIT License

Copyright (c) 2015 Juan Cruz Viotti. https://jviotti.github.io.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###

Promise = require('bluebird')
fs = require('fs-extra')
_ = require('lodash')
utils = require('./utils')
temporal = require('./temporal')

###*
# @summary Run a test case unit
# @function
# @protected
#
# @param {String} name - unit test name
# @param {Object} images - images hash
# @param {Function} action - test action
#
# @example
# unit.run 'a simple test',
# 	lorem: 'path/to/lorem.txt'
# , (files) ->
# 	fs.readFileAsync(files.lorem, encoding: 'utf8')
###
exports.run = (name, files, action) ->
	utils.promiseMapValues(files, temporal.fromFile).then (temporals) ->

		Promise.try ->
			action(temporals)
		.finally ->

			unlink = _.map _.values(temporals), (file) ->
				return fs.unlinkAsync(file)

			return Promise.settle(unlink)
