package xpt;
import haxe.ds.ObjectMap;
import haxe.ds.StringMap;
import thx.Bools;
import thx.macro.Macros;
import thx.Types;
import xpt.ExptWideSpecs.GeneralInfo;
import xpt.tools.XML_tools;

												
class ExptWideSpecs
{

	//todo:
		//urlparams
	
	//below treated as constants
	public static var trial_sep:String = ";";
	public static var stim_sep:String = "---";
	public static var trialName:String = "trialName";
	
	public static var special_courseInfo:MultipleKeysMap;			
	public static var special_turkInfo:MultipleKeysMap;													
	public static var special_flyingFishInfo:MultipleKeysMap;
	public static var special_exptInfo:MultipleKeysMap;
	public static var special_urlParams:MultipleKeysMap;
	public static var list_static_vars:Array<String> = ["special_courseInfo","special_turkInfo","special_flyingFishInfo","special_exptInfo","special_urlParams"];
	
	//below potentially changeable on experiment to experiment basis

	public static var __generalInfo:GeneralInfo;
	
	
	public static function kill() {
		//dont want to wipe constants.
		for (nam in list_static_vars) {
			Reflect.setField(ExptWideSpecs, nam, null);
		}
		__generalInfo = null;
	}
	
	public static function set(xml:Xml) {
		__setStaticVars();
		
		var setup:Xml = XML_tools.findNode(xml, "SETUP").next();

		__generalInfo = new GeneralInfo(setup);
		
		__updateStaticVars(__generalInfo.rawPropVals) ;
		
	}
	

	
	public static function IS(what:String):Dynamic {
		var val:Dynamic = __generalInfo.get(what);

		if (val != null && val != "") return val;
		
		
		if (list_static_vars.indexOf("special_"+what) != -1) {

			return Reflect.field(ExptWideSpecs, "special_"+what);
		}
		
		return '';
	}
	
	static public function __testSet(what:String, to:Dynamic) {
		__generalInfo.__testSet(what, to);
	}
	
	
	static public function __setStaticVars() 
	{
		special_courseInfo = new MultipleKeysMap([	'xpt_user_id', 
													'xpt_course_id']);			
		special_turkInfo = new MultipleKeysMap([	'assignment_id,assignmentId',
													'worker_id,workerId', 
													'hit_id,hitId']);													
		special_flyingFishInfo = new MultipleKeysMap(['flyingfish_id', 
													'flyingfish_study_id',
													'flyingfish_site_id']);	
		special_exptInfo = new MultipleKeysMap([	'overSJs', 
													'one_key',
													'exptId']);	
		special_urlParams = new MultipleKeysMap(null);											
		
	}
	
	static private function __updateStaticVars(rawPropVals:StringMap<String>) 
	{
		var specialMap:MultipleKeysMap;
		
		for (special in list_static_vars) {
			specialMap =  Reflect.field(ExptWideSpecs, special);
			
			if (specialMap != null) {//for testing purposes
				specialMap.special_update(rawPropVals);
			}
		}
	}


	
}

//different platforms can call the same param slightly different names. This lets a given value be referred to my multiple names.
class MultipleKeysMap  {
	
	private var alternateKeys:StringMap<String> = new StringMap<String>();
	public var __actualMap:StringMap<String> = new StringMap<String> ();
	
	public function new(props:Array<String>) {

		if (props == null) return;
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
		
		__actualMap.set(orig, "");

		for (prop in list) {
			alternateKeys.set(prop, orig);
		}
	}
	

	
	public function special_get(prop:String, force:Bool = false):String {
		var val:String;
		
		if(__actualMap.exists(prop)){
			return __actualMap.get(prop);
		}
		
		if (alternateKeys.exists(prop)) {
			prop = alternateKeys.get(prop);
			return __actualMap.get(prop);
		}
		throw "devel error - asking for nonexisting prop";
		return "";
	}
	
	//when ignoreErr is false, we are setting up the permissable vals in this dataClass. When true, we are letting defaults be overridden when they are available.
	public function special_set(prop:String,val:String, ignoreErr:Bool = false) {		

		if (alternateKeys.exists(prop)) {
			prop = alternateKeys.get(prop);
			__actualMap.set(prop,val);
		}
		else if(val != null && __actualMap.exists(val)){
			__actualMap.set(prop,val);
		}
		else if(ignoreErr == false) throw "devel error";
	}

	public function special_update(with :StringMap<String>) {
		if (with == null) return;
		for (prop in with ) {
			//trace(prop, 22);
			special_set(prop, with.get(prop), true);
		}
	}
	
}


class GeneralInfo  {

	//generating data
	public var mock:Bool = false; 
	public var autoCloseTimer:Int = -1;		
	
	
	//id stuff
	public var ip:String = '';	
	public var deviceUUID:Null<String>;
		
	//encryption
	public var encryptKey:Null<String>;
	public var one_key:Null<String>;
	
	//saving	
	public var saveFailMessage:String ="<font size= '20'><b>There was a problem when trying to save your results.</b></font>\n\n<font size= '20'>We hope you don't mind, but could you send the text below to EMAILADDRESS. For your convenience, this text has been copied to your clipboard.\n\n Are you a <b>Mechanical Turker</b>? Make sure to close this window when done to retrieve your code. Thanks.";		
	public var saveSuccessMessage:String="<font size= '20'><b>Successfully saved your data. You can close this message-window. Thankyou.<font size= '15'>";
	public var saveClose:String = "close when ready";
	public var cloudUrl:String = 'https://www.xpt.mobi/haxeGateway';
	public var saveWaitDuration:Int = 15;
	
	//expt stuff
	public var blockDepthOrder:String = '';
	public var timeStart:String;
	public var ITI:Int = 500;
	public var overSJs:Null<String>;
	
	
	//internal stuff
	public var rawPropVals:StringMap<String>;
			
	static public var listProps:Array<String> =  Type.getInstanceFields(GeneralInfo);
			
	public function new(params:Xml) {
		autogenerated();
		
		if (params == null) { //for testing
			return;
		}
		
		var actualProp:Dynamic;
		var val:String;

		rawPropVals = XML_tools.flattened_attribsToMap(params, []);
		//trace(rawPropVals);

		for (prop in rawPropVals.keys()) {
			
			if (listProps.indexOf(prop) != -1){
				val = rawPropVals.get(prop);
				actualProp = Reflect.field(this, prop);

				try{
					switch(Types.valueTypeToString(actualProp)) {
						case "String":	Reflect.setField(this, prop, val);
						case "Int": 	Reflect.setField(this, prop, Std.parseInt(val));
						case "Float":	Reflect.setField(this, prop, Std.parseFloat(val));
						case "Bool":	Reflect.setField(this, prop, Bools.parse(val));
						default: throw "devel err - unknown type";
					}
				}
				catch (e:String) {
					throw("Problem trying to set a value in SETUP: " + e);
				}
		
			}
			else {
				//sometimes useful to rename a prop to an unknown
			}
		}	
	}
	
	
	
	private function autogenerated() 
	{
		timeStart = Date.now().toString();
	}
	

	

	
	public function get(what:String):Dynamic {
		if (listProps.indexOf(what) != -1) return Reflect.getProperty(this,what);
		return null;
		//throw "devel err - known var requested";
	}
	
	public function __testSet(what:String, to:Dynamic) 
	{
		Reflect.setField(this, what, to);
	}
	


	
}