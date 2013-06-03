(function () {
	'use strict';

	function value (_) { return "v(" + _ + ");" }
	function uvalue (_) { return "u(" + _ + ");" }
	function variable (_) { return (1 in _? "p(s,'" : "s('") + _.join("','") + "')" }
	function call (_) { return "c('" + _ + "',s);" }
	function esc (_) { return _.replace(/[<>"'&\/]/g, enc) }
	function enc (_) { return "&#" + _.charCodeAt(0) + ";" }
	function plain (_) { return (_ = _.replace(/'/g, "\\'"))? uvalue("'" + _ + "'") : "" }

	function make (l, r) {
		var _ = new RegExp('(.*?)' + l + ' *((?:([=&!#^>/]) *)?([\\S\\s]*?) *?(=)?) *' + r, 'ig');
		_.lastIndex = this;
		return _;
	}

	function wrap (_, depth) {
		if (_[0] === '.') if (depth) return '$'; else throw new Error('Not in section');
		return variable(_.split('.'));
	}

	function compile (template) {
		var pattern = make.call(0, '{{', '}}'),
			stack = [], i = 0, depth = 0, match, tag, r = [
				"var _=this,r='',y=r.replace",
				"a=Array.prototype.slice",
				"t=Object.prototype.toString",
				"e=function($){return y.call($,/[<>\"'&\/]/g,function($){return '&#'+$.charCodeAt(0)+';'})}",
				"s=typeof S ==='function'?S:function($){return S[$]}",
				"v=function($){if($||$===0)r+=e($)}",
				"u=function($){if($||$===0)r+=$}",
				"l=function($){return t.call($)==='[object Array]'?$:$?[$]:[]}",
				"i=function($){return t.call($)==='[object Array]'?$.length:$}",
				"p=function(s,$,_){for($=s($),_=a.call(arguments,2);$!=null&&_.length;$=$[_.shift()]);return $}",
				"c=function($,s){r+=_[$](s,e);};S=Object(S);"
			].join();

		if (null == template) throw new Error('Template required');
		template = String(template).replace(/[\n\r]/g, '\\n');

		for (; match = pattern.exec(template); i = pattern.lastIndex) {
			r += plain(match[1]);

			switch (match[3]) {
				case '!':
					break;

				case '#':
					stack.unshift([match[4]]);
					depth++;
					r += '(function(a){for(var $,j=0,k=a.length,h=Object.prototype.hasOwnProperty;j<k;j++)(function(s){';
					break;

				case '^':
					stack.unshift([match[4], 1]);
					r += 'if(!i(' + wrap(match[4], depth) + ')){';
					break;

				case '/':
					if ((tag = stack.shift()) && tag[0] === match[4])
						r += tag[1]? '}' : depth-- && '}(null==($=a[j])?s:function(_){return h.call($,_)?$[_]:s(_)}));}(l(' + wrap(match[4], depth) + ')));';
					else throw new Error('Section mismatch');
					break;

				case '>':
					r += call(match[4]);
					break;

				case '=':
					if (match[5] === '=')
						pattern = make.apply(pattern.lastIndex, match[4].split(/ +/, 2));
					else throw new Error('Delimiter mismatch');
					break;

				case '&':
					r += uvalue(wrap(match[4], depth));
					break;

				default:
					r += value(wrap(match[2], depth));
			}
		}

		r += plain(template.slice(i));

		return r + 'return r';
	}

	function fn (template) { return new Function('S', compile(template)) }
	function Ulfsaar (name, template) { return Ulfsaar[name] = fn(template) }

	Ulfsaar._ = { escape: esc, fn: fn, compile: compile };

	typeof module === 'object'? module.exports = Ulfsaar : window.Ulfsaar = Ulfsaar;
}());
