package code;
import code.CheckIsCode.Checks;
import code.Code.HScriptLayer;
import haxe.io.StringInput;
import hscript.Interp;
import hscript.Parser;
import openfl.errors.Error;
import openfl.utils.Object;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class Code
{

	private static var layer:HScriptLayer;
	private static var scope:HScriptScope;
	
	public static var testing:Bool = true; //for testing
	
	static public function DO(script:Xml, c:Checks, trial:Trial = null):String {
		if (layer == null) {
			layer = new HScriptLayer();
			scope = layer.__scope;
		}

		
		
		var code:String = CheckIsCode.DO(script,c);
		if (code == null) return null;
		
		scope.trial = trial;
		scope.script = script;
		if(testing==false) layer.crunch(code);
		
		return code;
	}
	
	static public function __codingCode(code:String, script:Xml, trial:Trial) 
	{
		
	}
	
	static public function __codingXML(code:String, script:Xml) 
	{
		
	}
	
	
	
}



class HScriptLayer {
	
	public var __scope:HScriptScope = new HScriptScope();
	
	var parser:Parser;
	var interp:Interp;
	
	//var ast:StringInput;
	
	
	public var a:Int;
	
	public function new() 
	{
		init();
	}
	
	function init() 
	{
		parser = new Parser();
		interp = new Interp();
	}
	
	public function crunch(code:String) 
	{
		var obj:Object = { a:1, b:function():Int {
			return 3;
		}};
			
		var expr = "var x = 4; 1 + 2 * obj.b(); obj.a=2; me.a=22; obj.t = function(){return 113;}";

		var ast = parser.parseString(expr);

		interp.variables.set("obj", obj);
		interp.variables.set("me", this);
		//trace(22, interp.execute(ast), 222, obj.t(),obj.a,this.a);
	}
	

	
}