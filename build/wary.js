
/*
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
 */

/**
 * @module wary
 */
var BluebirdQueue, log, unit;

BluebirdQueue = require('bluebird-queue');

unit = require('./unit');

log = require('./log');


/**
 * @summary Unit tests queue
 * @private
 */

exports.tests = new BluebirdQueue({
  concurrency: 1
});


/**
 * @summary Declare a unit test
 * @function
 * @public
 *
 * @description
 * The files declared in the second argument are copied to a temporary location and then automatically removed, so you can freely interact with them within your tests.
 *
 * @param {String} name - test name
 * @param {Object} files - files to use in the test
 * @param {Function} action - test action
 *
 * @example
 * Promise = require('bluebird')
 * fs = Promise.promisifyAll(require('fs'))
 * wary = require('wary')
 * assert = require('assert')
 *
 * wary.it 'should write to a file',
 * 	text: 'path/to/text.txt'
 * , (files) ->
 * 	fs.writeFileAsync(files.text, 'Hello World', encoding: 'utf8').then ->
 * 		fs.readFileAsync(files.text, encoding: 'utf8').then (contents) ->
 * 			assert.equal(contents, 'Hello World')
 */

exports.it = function(name, files, action) {
  return exports.tests.add(function() {
    console.log(log.unit(name));
    return unit.run(name, files, action);
  });
};


/**
 * @summary Run all tests
 * @function
 * @public
 *
 * @returns {Promise}
 *
 * @example
 * wary.run()
 */

exports.run = function() {
  return exports.tests.start();
};
