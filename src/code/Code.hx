package code;
import code.CheckIsCode.Checks;
import openfl.errors.Error;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class Code
{

	private static var instance:Code;
	
	public function new() 
	{
		
	}
	
	public static function init() {
		if (instance != null)	throw new Error("only instantiated once per session");
		instance = new Code();
	}
	
	static public function DO(script:Xml, c:Checks, trial:Trial = null):Xml {
	
		var code:Xml = CheckIsCode.DO(script,c);
		if (code == null) return null;
		
		return code;
	}
	
	
	
}