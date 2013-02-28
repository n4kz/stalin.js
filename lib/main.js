(function () {
	'use strict';

	function value (_) { return "\nv(" + _ + ");" }
	function uvalue (_) { return "\nu(" + _ + ");" }
	function variable (_, p) { return "s('" + _ + "')" + (p? "['" + p + "']" : "") }
	function call (_) { return "\nc('" + _ + "',s);" }
	function esc (_) { return _.replace(/[<>"'&]/g, enc) }
	function enc (_) { return "&#" + _.charCodeAt(0) + ";" }
	function ewrap (_) { return "e(" + _ + ");" }
	function plain (_) { return (_ = _.replace(/'/g, "\\'"))? uvalue("'" + _ + "'") : "" }

	function make (l, r) {
		var _ = new RegExp('(.*?)' + l + ' *((?:([=&!#^>/]) *)?([\\S\\s]*?) *(=)?) *' + r, 'ig');
		_.lastIndex = this;
		return _;
	}

	function wrap (_) {
		_ = _.split('.');
		return variable(_.shift(), _.join("']['"));
	}

	function compile (template) {
		var pattern = make.call(0, '{{', '}}'),
			stack = [], i = 0, match, tag, path;

		if (!template) throw new Error('Template required');
		template = String(template).replace(/[\n\r]/g, '\\n');

		var r = [
		"var r=''",
		"_=this",
		"p=Object.prototype",
		"t=p.toString",
		"h=p.hasOwnProperty",
		"e=function(_){ return _.replace(/[<>\"'&]/g,function(_){ return '&#' + _.charCodeAt(0) + ';' }) }",
		"s=typeof S === 'function'? S : function(_){ return S[_] }",
		"v=function($){ if($ || $ === 0) r += e($) }",
		"u=function($){ if($ || $ === 0) r += $ }",
		"l=function($){ return t.call($) === '[object Array]'? $ : $? [$] : [] }",
		"c=function($,s){ r += _[$](s); };"
		].join();

		for (; match = pattern.exec(template); i = pattern.lastIndex) {
			r += plain(match[1]);

			switch (match[3]) {
				case '!':
					break;

				case '#':
					stack.unshift([match[4]]);
					r += '\nl(' + wrap(match[4]) + ').forEach(function($){(function(s){';
					break;

				case '^':
					stack.unshift([match[4], 1]);
					r += '\nif(' + wrap(match[4]) + '){';
					break;

				case '/':
					if ((tag = stack.shift()) && tag[0] === match[4])
						r += tag[1]? '\n}' : '\n}(null==$?s:function(_){return h.call($,_)?$[_]:s(_)}))});';
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
					r += uvalue(wrap(match[2]));
					break;

				default:
					r += value(wrap(match[2]));
			}
		}

		r += plain(template.slice(i));
		r += 'return r';

		return r;
	}

	function fn (template) { return new Function('S', compile(template)) }
	function Ulfsaar (name, template) { Ulfsaar[name] = fn(template) };

	Ulfsaar._ = { escape: esc, fn: fn, compile: compile };

	module? module.exports = Ulfsaar : this.Ulfsaar = Ulfsaar;
}());
