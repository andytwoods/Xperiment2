package xpt.behaviour.engine;

import hscript.Interp;
import hscript.Parser;
import openfl.utils.Object;

/**
 * ...
 * @author ...
 */
class Engine
{

	public var a:Int = 4;
	
	public function new()
	{

	var obj:Object = { a:1, b:function():Int {
		return 3;
		}
	};
		
	var expr = "var x = 4; 1 + 2 * obj.b(); obj.a=2; me.a=22; obj.t = function(){return 113;}";
	var parser = new Parser();
	var ast = parser.parseString(expr);
	var interp = new Interp();
	interp.variables.set("obj", obj);
	interp.variables.set("me", this);
	//trace(22, interp.execute(ast), 222, obj.t(),obj.a,this.a);
	
	

	
	
	
	
	}
	
}