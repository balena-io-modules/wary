wary
----

[![npm version](https://badge.fury.io/js/wary.svg)](http://badge.fury.io/js/wary)
[![dependencies](https://david-dm.org/jviotti/wary.png)](https://david-dm.org/jviotti/wary.png)
[![Build Status](https://travis-ci.org/jviotti/wary.svg?branch=master)](https://travis-ci.org/jviotti/wary)
[![Build status](https://ci.appveyor.com/api/projects/status/1g5c8bh782tnfh2s?svg=true)](https://ci.appveyor.com/project/jviotti/wary)

Tiny unit test framework to test code with real files.

Motivation
----------

Running tests that interact with real files has usually been a mess. Tipic solutions include mocking the filesystem module, which can reduce the effectiveness of your test code, or use modules that create a virtual filesystem in RAM.

Wary allows you to easily run test cases on real files, allowing you to increase your trust in the code, by taking the required files as inputs and copying them to a temporal location allowing the test to freely modify them, remove them, etc without harming the original file. The temporal files are later removed for you automatically.

Installation
------------

Install `wary` by running:

```sh
$ npm install --save wary
```

Documentation
-------------


* [wary](#module_wary)
  * [.it(name, files, action)](#module_wary.it)
  * [.run()](#module_wary.run) ⇒ <code>Promise</code>

<a name="module_wary.it"></a>
### wary.it(name, files, action)
The files declared in the second argument are copied to a temporary location and then automatically removed, so you can freely interact with them within your tests.

**Kind**: static method of <code>[wary](#module_wary)</code>  
**Summary**: Declare a unit test  
**Access:** public  

| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | test name |
| files | <code>Object</code> | files to use in the test |
| action | <code>function</code> | test action |

**Example**  
```js
Promise = require('bluebird')
fs = Promise.promisifyAll(require('fs'))
wary = require('wary')
assert = require('assert')

wary.it 'should write to a file',
	text: 'path/to/text.txt'
, (files) ->
	fs.writeFileAsync(files.text, 'Hello World', encoding: 'utf8').then ->
		fs.readFileAsync(files.text, encoding: 'utf8').then (contents) ->
			assert.equal(contents, 'Hello World')
```
<a name="module_wary.run"></a>
### wary.run() ⇒ <code>Promise</code>
**Kind**: static method of <code>[wary](#module_wary)</code>  
**Summary**: Run all tests  
**Access:** public  
**Example**  
```js
wary.run()
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/jviotti/wary/issues/new) on GitHub and I'll be happy to help.

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/jviotti/wary/issues](https://github.com/jviotti/wary/issues)
- Source Code: [github.com/jviotti/wary](https://github.com/jviotti/wary)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

License
-------

The project is licensed under the MIT license.
