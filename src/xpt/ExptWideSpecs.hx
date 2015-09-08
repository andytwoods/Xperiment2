package xpt;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;

												
class ExptWideSpecs
{

	//below treated as constants
	public static var trial_sep:String = ";";
	public static var stim_sep:String = "---";
	public static var trialName:String = "trialName";
	
	public static var special_courseInfo;			
	public static var special_turkInfo;													
	public static var special_flyingFishInfo;
	public static var special_exptInfo;
	public static var list_static_vars:Array<String> = __getListStatic();
	
	//below potentially changeable on experiment to experiment basis

	static private var hack:Map<String,Dynamic>;
	
	
	public static function kill() {
		//dont want to wipe constants.
		for (nam in list_static_vars) {
			Reflect.setField(ExptWideSpecs, "special_"+nam, null);
		}
	}
	
	
	public static function IS(what:String):Dynamic {
			
		if (hack[what] != null) return hack[what];
		
		//n.b. list of static props generated automatically on compile.
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
		hack = new Map<String,Dynamic>();
		__setStaticVars();
		//hack['blockDepthOrder'] = "";		
		
	}
	
	static public function __setStaticVars() 
	{
		special_courseInfo = new SpecialProps([	'xpt_user_id', 
												'xpt_course_id']);			
		special_turkInfo = new SpecialProps([	'assignment_id,assignmentId', 											 'worker_id,workerId', 
												'hit_id,hitId']);													
		special_flyingFishInfo = new SpecialProps(['flyingfish_id', 
												   'flyingfish_study_id',											    'flyingfish_participant_id',											   'flyingfish_site_id']);	
		special_exptInfo = new SpecialProps([	'overSJs', 
												'one_key',
												'exptId']);	
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


class SpecialProps extends ObjectMap<String, String> {
	
	private var alternateKeys:StringMap<String> = new StringMap<String>();
	
	public function new(props:Array<String>) {
		super();	
		for (item in props) {
			__multiset(item);
		}
	}
	
	//note the first item in the list is the actual key
	function __multiset(prop:String) 
	{
		if (prop.length == 0) throw "";
		var list:Array<String> = prop.split(",");
		var orig:String = list.shift();
		
		set(orig, "");

		for (prop in list) {
			alternateKeys.set(prop, orig);
		}
	}
	

	
	public function special_get(prop:String, force:Bool = false):String {
		var val:String;
		
		if(exists(prop)){
			return get(prop);
		}
		
		if (alternateKeys.exists(prop)) {
			prop = alternateKeys.get(prop);
			return get(prop);
		}
		throw "devel error - asking for nonexisting prop";
		return "";
	}
	
	
	public function special_set(prop:String,val:String) {		

		if (alternateKeys.exists(prop)) {
			prop = alternateKeys.get(prop);
			set(prop,val);
		}
		else if(exists(val)){
			set(prop,val);
		}
		else throw "devel error";
	}

	
	
}