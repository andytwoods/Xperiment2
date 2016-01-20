package xpt.tools;

import haxe.ui.toolkit.hscript.ScriptInterp;

class ScriptTools {
    public static function expandScriptValues(script:String, vars:Map<String, Dynamic> = null):String {
        var finalResult:String = script;
        var scriptEngine:ScriptInterp = new ScriptInterp();
        if (vars != null) {
            for (key in vars.keys()) {
                scriptEngine.variables.set(key, vars.get(key));
            }
        }

		var parser = new hscript.Parser();
        var n1:Int = finalResult.indexOf("${");
        while (n1 != -1) {
            var n2:Int = finalResult.indexOf("}", n1);
            var e:String = finalResult.substring(n1 + 2, n2);
            var expr = parser.parseString(e);
            var r = scriptEngine.execute(expr);
            var before:String = finalResult.substring(0, n1);
            var after:String = finalResult.substring(n2 + 1, finalResult.length);
            finalResult = before + r + after;
            n1 = finalResult.indexOf("${");
        }
        
        return finalResult;
    }
}