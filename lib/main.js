(function () {
	'use strict';

	function value (_) { return "v(" + _ + ");" }
	function uvalue (_) { return "u(" + _ + ");" }
	function variable (_) { return (1 in _? "p(s,'" : "s('") + _.join("','") + "')" }
	function esc (_) { return _.replace(/[<>"'&\/]/g, enc) }
	function enc (_) { return "&#" + _.charCodeAt(0) + ";" }
	function plain (_) { return (_ = _.replace(/'/g, "\\'"))? uvalue("'" + _ + "'") : "" }

	function make (l, r) {
		var _ = new RegExp('(.*?)' + l + ' *((?:([=&!#^>/]) *)?([\\S\\s]*?) *?(=)?) *' + r, 'ig');
		_.lastIndex = this;
		return _;
	}

	function compile (template) {
		var pattern = make.call(0, '{{', '}}'),
			stack = [], i = 0, match, tag, r = [
				"var _=this,r='',y=r.replace,q=/[<>\"'&\/]/g,x={}",
				"a=Array.prototype.slice",
				"t=x.toString",
				"h=x.hasOwnProperty",
				"e=function($){return y.call($,q,function($){return x[$]})}",
				"s=typeof S ==='function'?S:function($){return S[$]}",
				"v=function($){if($||$===0)r+=e($)}",
				"u=function($){if($||$===0)r+=$}",
				"l=function($){return t.call($)==='[object Array]'?$:$?[$]:[]}",
				"i=function($){return t.call($)==='[object Array]'?$.length:$}",
				"p=function(s,$,_){for($=s($),_=a.call(arguments,2);$!=null&&_.length;$=$[_.shift()]);return $}",
				"d=function($,s){return function(_){return h.call($,_)?$[_]:s(_)}}",
				"m=function($,s,f){for(var _=l($),j=0,k=_.length;j<k;)f(null==($=_[j++])?s:d($,s),$,u,v)}"+
				";S=Object(S);'<>\"\\'&/'.split(r).map(function($){x[$]='&#'+$.charCodeAt(0)+';'});"
			].join();

		function wrap (_) {
			if (_[0] === '.') if (stack.length) return '$'; else throw new Error('Not in section');
			return variable(_.split('.'));
		}

		if (null == template) throw new Error('Template required');
		template = String(template).replace(/[\n\r]/g, '\\n');

		for (; match = pattern.exec(template); i = pattern.lastIndex) {
			r += plain(match[1]);

			switch (match[3]) {
				case '!':
					break;

				case '#':
					stack.unshift([match[4]]);
					r += 'm(' + wrap(match[4]) + ',s,function(s,$,u,v){';
					break;

				case '^':
					stack.unshift([match[4], 1]);
					r += 'if(!i(' + wrap(match[4]) + ')){';
					break;

				case '/':
					if ((tag = stack.shift()) && tag[0] === match[4])
						r += tag[1]? '}' : '});';
					else throw new Error('Section mismatch');
					break;

				case '>':
					r += "r+=_['" + match[4] + "'](s,e);";
					break;

				case '=':
					if (match[5] === '=')
						pattern = make.apply(pattern.lastIndex, match[4].split(/ +/, 2));
					else throw new Error('Delimiter mismatch');
					break;

				case '&':
					r += uvalue(wrap(match[4]));
					break;

				default:
					r += value(wrap(match[2]));
			}
		}

		r += plain(template.slice(i));

		return r + 'return r';
	}

	function fn (template) { return new Function('S', compile(template)) }
	function Stalin (name, template) { return Stalin[name] = fn(template) }

	Stalin._ = { escape: esc, fn: fn, compile: compile };

	typeof module === 'object'? module.exports = Stalin : window.Stalin = Stalin;
}());
