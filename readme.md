# Stalin

Badass [mustache](http://mustache.github.com) compiler

# Why?

* In Soviet Russia template compiles you
* Compiled templates have no dependencies
* Minified and gzipped version is 1KB in size
* Joseph Stalin => stalin.js

# Installation

```bash
# Global
npm -g install stalin

# Local
npm install stalin
```

# Difference

* Lambdas are not supported (no simple way to get template source from compiled one)
* Partials are functions (templates or helpers at your choise, see below)
* `{{{ }}}` Not supported, use `{{& }}` instead to get unescaped output
* All CRs are converted to LFs before processing
* LFs from lines with standalone tags are not removed

# Usage

## API

```javascript
var Stalin = require('stalin');

/* Compile template and save reference */
Stalin('example', '{{#first}}{{example}}{{/first}}');

/* Render compiled template */
console.log(Stalin.example({ first: true, example: 'Hello world' }));
```

Some internal functions are accessible via `Stalin._`

* `compile` - compile template to string and return it
* `fn` - compile, eval and return reference

## Partials

Partials can be defined as another template

```javascript
Stalin('link', '<a href="{{&href}}">{{title}}</a>');
```

or as custom function

```javascript
Stalin.link = function (scope, escape) {
	/* Call to scope() does scope lookup and returns unescaped value */
	return '<a href="' + scope('href') + '">' + escape(scope('title')) + '</a>';
};
```

and used later

```javascript
Stalin('linkbar', '{{#linkbar.length}}<ul>{{#linkbar}}<li>{{>link}}</li>{{/linkbar}}</ul>{{/linkbar.length}}');

console.log(Stalin.linkbar({
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
stalin public/templates/

# Compile single file and print it
stalin public/index.mustache
```

## Client

To use compiled templates without Stalin itself you need to define `window.Stalin` before loading any template. Templates
will register themselves on Stalin object when loaded.

```html
<script>var Stalin = {};</script>
<script src="/templates/index.js"></script>
<script>console.log(Stalin.index({ test: true }));</script>
```

# Copyright and License

Copyright 2013 Alexander Nazarov. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
