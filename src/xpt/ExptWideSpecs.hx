package xpt;

/**
 * ...
 * @author 
 */
class ExptWideSpecs
{

	//below treated as constants
	public static var trial_sep:String = ";";
	public static var stim_sep:String = "---";
	public static var trialName:String = "trialName";
	
	//below potentially changeable on experiment to experiment basis
	public static var list_static_vars:Array<String>;
	public static var special_courseInfo:Map<String,String>;
	public static var special_turkInfo:Map<String,String>;
	
	static private var hack:Map<String,Dynamic>;
	
	
	public static function kill() {
		//dont want to wipe constants.
		for (nam in list_static_vars) {
			Reflect.setField(ExptWideSpecs, "special_"+nam, null);
		}
	}
	
	
	public static function IS(what:String):Dynamic {
			
		if (hack[what] != null) return hack[what];
		if (list_static_vars.indexOf(what) != -1) {
			return Reflect.field(ExptWideSpecs, "special_"+what);
		}
		
		
		
		return '';
	}
	
	static public function __testSet(what:String, to:Dynamic) {
		hack.set(what, to);
	}
	
	static public function __init() 
	{
		hack= new Map<String,Dynamic>();
		//hack['blockDepthOrder'] = "";
		
		list_static_vars = __getListStatic();
		
	}
	
	static public function __getListStatic():Array<String>
	{
		var list:Array<String> = [];
		
		for (field in Type.getClassFields(ExptWideSpecs)) {
			if (field.charAt(0) != "_") {
			
				//if a function, don't add.
				if(Reflect.isFunction(Reflect.field(ExptWideSpecs, field)) == false)	list.push(field.split("special_").join(""));
			}
		}
 		return list;
	}
	
	

	static public function DO(script:Xml) 
	{
		
		//mturk and ff Stuff
	}
	
}