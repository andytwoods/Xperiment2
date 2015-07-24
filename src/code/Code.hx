package code;
import openfl.errors.Error;

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
	
}