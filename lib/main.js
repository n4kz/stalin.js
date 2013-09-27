(function () {
	'use strict';

	function process (template) {
		var pattern, stack = [], i = 0, match, tag, r = [
				"var _=this,r='',q=/[<>\"'&\/]/g,x={}",
				"t=x.toString",
				"h=x.hasOwnProperty",
				"e=function($){return String($).replace(q,function($){return x[$]})}",
				"s=/^f/.test(typeof S)?S:function($){return S[$]}",
				"v=function($){if($||$===0)r+=e($)}",
				"u=function($){if($||$===0)r+=$}",
				"l=function($){return t.call($)[8]=='A'?$:$?[$]:[]}",
				"i=function($){return t.call($)[8]=='A'?$.length:$}",
				"p=function($,s){for(var j=0,l=s.length;$!=null&&j<l;$=$[s[j++]]);return $}",
				"d=function($,s){return function(_){return h.call($,_)?$[_]:s(_)}}",
				"m=function($,s,f){for(var _=l($),j=0,k=_.length;j<k;)f(null==($=_[j++])?s:d($,s),$)}"+
				";S=Object(S);'<>\"\\'&/'.replace(/./g,function($){x[$]='&#'+$.charCodeAt(0)+';'});"
			].join();

		function make (i, braces) {
			pattern = RegExp('(.*?)' + braces[0] + ' *((?:([=&!#^>/]) *)?([\\S\\s]*?) *?(=)?) *' + braces[1], 'ig');
			pattern.lastIndex = i;
		}

		function value (_, e) { r += "uv"[~~e] + "(" + _ + ");" }
		function plain (_) { (_ = _.replace(/'/g, "\\'"))? value("'" + _ + "'") : "" }

		function wrap (_) {
			if (_ === '.') if (stack.length) return '$'; else throw Error('Not in section');
			return _=_.split('.'), 1 in _? "p(s('" + _.shift() + "'),['" + _.join("','") + "'])" : "s('" + _ + "')";
		}

		make(0, ['{{', '}}']);

		if (null == template) throw Error('Template required');
		template = String(template).replace(/[\n\r]/g, '\\n');

		for (; match = pattern.exec(template); i = pattern.lastIndex) {
			plain(match[1]);

			switch (match[3]) {
				case '!':
					break;

				case '#':
					stack.unshift([match[4]]);
					r += 'm(' + wrap(match[4]) + ',s,function(s,$){';
					break;

				case '^':
					stack.unshift([match[4], 1]);
					r += 'if(!i(' + wrap(match[4]) + ')){';
					break;

				case '/':
					if ((tag = stack.shift()) && tag[0] === match[4])
						r += tag[1]? '}' : '});';
					else throw Error('Section mismatch');
					break;

				case '>':
					r += "r+=_['" + match[4] + "'](s,e);";
					break;

				case '=':
					if (match[5]) make(pattern.lastIndex, match[4].split(/ +/));
					else throw Error('Delimiter mismatch');
					break;

				case '&':
					value(wrap(match[4]));
					break;

				default:
					value(wrap(match[2]), 1);
			}
		}

		plain(template.slice(i));

		return r + 'return r'
	}

	function fn (template) { return Function('S', process(template)) }
	function Stalin (name, template) { return Stalin[name] = fn(template) }

	Stalin.compile = fn;
	Stalin.process = process;

	typeof module === 'object'? module.exports = Stalin : window.Stalin = Stalin
}());
