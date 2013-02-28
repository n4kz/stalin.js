# Ulfsaar

Lightweight [mustache](http://mustache.github.com) template compiler

# Why?

* Compile your mustache
* Compiled templates have no dependencies
* Minified and gzipped version is less than one KB in size

# Installation

```bash
# Global
npm -g install ulfsaar

# Local
npm install ulfsaar
```

# Difference

* You need to compile templates
* Lambdas are not supported (no simple way to get template source from compiled one)
* Partials are functions (templates or helpers at your choise, see below)
* `{{{ }}}` Not supported, use `{{& }}` instead to get unescaped output

# Usage

## API

```javascript
var Ulfsaar = require('ulfsaar');

/* Compile template and save reference */
Ulfsaar('example', '{{#first}}{{example}}{{/first}}');

/* Render compiled template */
console.log(Ulfsaar.example({ first: true, example: 'Hello world' }));
```

Some internal functions are accessible via `Ulfsaar._`

* `escape`
* `compile`
* `fn`

## Partials

Partials can be defined as another template

```javascript
Ulfsaar('link', '<a href="{{&href}}">{{title}}</a>');
```

or as custom function

```javascript
Ulfsaar.link = function (s) {
	/* Call to s() does scope lookup and returns unescaped value */
	return '<a href="' + s('href') + '">' + Ulfsaar._.escape(s('title')) + '</a>';
};
```

and used later

```javascript
Ulfsaar('linkbar', '{{#linkbar.length}}<ul>{{#linkbar}}<li>{{>link}}</li>{{/linkbar}}</ul>{{/linkbar.length}}');

console.log(Ulfsaar.linkbar({
	linkbar: [
		{ href: '/about',    title: 'About' },
		{ href: '/contacts', title: 'Contacts' }
	]
}));
```

to get result like that

```html
<ul><li><a href="/about">About</a></li><li><a href="/contacts">Contacts</a></li></ul>
```

## Compilation

```bash
# Compile all *.mustache files in folder
# and subfolders and save with .js extension
ulfsaar public/templates/

# Compile single file and print it
ulfsaar public/index.mustache
```

## Client

To use compiled templates without Ulfsaar itself you need to define `window.Ulfsaar` before loading any template. Templates
will register themselves on Ulfsaar object when loaded.

```html
<script>var Ulfsaar = {};</script>
<script src="/templates/index.js"></script>
<script>console.log(Ulfsaar.index({ test: true }));</script>
```

# TODO

* AMD compatibility
* Tests
* Performance comparison
* Extension to use blocks (like jade or many others)
* Direct access to escape from helpers

# Copyright and License

Copyright 2013 Alexander Nazarov. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
