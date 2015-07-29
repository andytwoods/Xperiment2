package xpt;

/**
 * ...
 * @author 
 */
class ExptWideSpecs
{

	public static var trial_sep:String = ";";
	public static var stim_sep:String = "---";
	public static var trialName:String = "trialName";	
	static private var hack:Map<String,Dynamic>;
	
	
	
	
	
	public static function IS(what:String):Dynamic {
			
		if (hack[what] != null) return hack[what];
		
		
		return '';
	}
	
	static public function __testSet(what:String, to:Dynamic) {
		hack.set(what, to);
	}
	
	static public function __init() 
	{
		hack= new Map<String,Dynamic>();
		//hack['blockDepthOrder'] = "";
		
	}
	
}