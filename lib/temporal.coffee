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

fs = require('fs-extra')
Promise = require('bluebird')
tmp = Promise.promisifyAll(require('tmp'))
tmp.setGracefulCleanup()

###*
# @summary Make temporal copy from a file
# @function
# @protected
#
# @param {String} filePath - file path
# @returns {Promise<String>} temporal path
#
# @example
# temporal.fromFile('images/rpi.img').then (temporalPath) ->
# 	console.log("The temporal copy is in #{temporalPath}")
###
exports.fromFile = (filePath) ->
	fs.statAsync(filePath).then (stat) ->
		return stat.isDirectory()

	.then (isDirectory) ->
		if isDirectory
			return tmp.dirAsync()
		return tmp.fileAsync()
	.spread (temporalPath) ->

		# Use sync version since async fails on Windows
		# with EPERM issues for some reason.
		fs.copySync(filePath, temporalPath)

		return temporalPath
