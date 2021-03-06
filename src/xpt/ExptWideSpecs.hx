package xpt;

import xpt.tools.Base64;
import openfl.Assets;
import thx.Uuid;
import xpt.tools.XML_tools;

												
class ExptWideSpecs
{

	private static var map:Map<String,String> = new Map<String,String>();
	
	public static var trial_sep:String  = '|'; //Alt 124
	public static var stim_sep:String = '---';
	public static var trialName:String = "trialName";
	public static var filename:String = "asset";
	static public var readabilitySpaces_props:Array<String> = ['groups','stims'];
	
	
	private static var testMods:Map<String,String>;
	public static var startTime:Date;
	
	public static function testingOff() {
		if (testMods == null)  return;
		if (testMods.exists('trial_sep')) {
			trial_sep = testMods.get('trial_sep');
		}
		if (testMods.exists('stim_sep')) {
			stim_sep = testMods.get('stim_sep');
		}
	}
	
	public static function testingOn(map:Map<String,String>) {

		function store(val:String, what :String) {
			if (testMods == null) testMods = new Map<String,String>();
			testMods.set(what, val );
		}
		
		if (map.exists('trial_sep')) {
			store(trial_sep, 'trial_sep');
			trial_sep = map.get('trial_sep');
		}
		if (map.exists('stim_sep')) {
			store(stim_sep, 'stim_sep');
			stim_sep = map.get('stim_sep');
		}		
	}
	
	public static function kill() {
		map = new Map<String,String>();
		
	}
	
	public static function init() {
		startTime = Date.now();

	//courseInfo
		map.set("xpt_user_id","");
		map.set("xpt_course_id","");
	//turkInfo
		map.set("assignment_id","");
		map.set("worker_id","");
		map.set("hit_id","");
	//flyingFishInfo
		map.set("flyingfish_id","");
		map.set("flyingfish_study_id","");
		map.set("flyingfish_site_id","");
	//exptInfo
		map.set("one_key","");
		map.set("exptId","");
	//encryption
		map.set("encryptKey","");
		map.set("one_key","");
	//general
		map.set('stimuliFolder', Xpt.localExptDirectory + Xpt.exptName + "/");
		map.set("mock","");
		map.set("autoCloseTimer","-1");
		map.set("overSJs","");
		map.set("ip","autoset");
		map.set("deviceUUID","");
		map.set('uuid', Uuid.create().split("-").join(""));
		map.set('backgroundColour', 'white');
		map.set('orientation', 'horizontal');
		map.set('csrftoken', 'debug');
	//blocking
		map.set("blockDepthOrder","");
	//saving
		map.set("save", 'true');
		map.set("do_not_prepend_data", 'false');
		map.set("email", "backup@xperiment.mobi");
		map.set("saveFailMessage", "There was a problem when trying to save your results.\n\nCould you try to send us your results again? If this is unsuccessful after several attempts, could you download your results and send them to EMAIL? WE are really sorry about this and appreciate your help. Your results are very valuable to us. Thankyou.");
		map.set("saveSuccessMessage","Successfully saved your data! Thankyou.");
		map.set("saveClose","close when ready");
		map.set("trickleToCloud","true");
		map.set("cloudUrl", "https://www.xpt.mobi/api/sj_data");
		map.set("evolveUrl", "https://www.xpt.mobi/evolve/");
		map.set("saveWaitDuration","5000");
	//timing
		map.set("ITI", "500");		
	//validation
		map.set('invalidTrialBehaviour', 'disable');
	//devices
		map.set('devices', 'desktop,tablet'); //https://github.com/matthewhudson/device.js?#conditional-javascript
		//above uses slightly odd logic. If the device is a forbidden device (!prefixed), study wont run. But, if it is one of the permitted devices, it will run.

	}
	
	public static function set(xml:Xml) {

		if (xml != null) {

			var XMLiterator:Iterator<Xml> = XML_tools.findNode(xml, "SETUP");
			if (XMLiterator.hasNext()) {
				var attribs = XML_tools.getAttribs_map(XMLiterator.next() );
						
				for (key in attribs.keys()) {
					map.set(key, attribs.get(key));
				}
			}
			
			var email:String = map.get('email');
			var failSaved:String = map.get('saveFailMessage');
			map.set('saveFailMessage', failSaved.split('EMAIL').join(email));
			
		}
	}
	
	public static function exptId():String {
		return map.get("exptId");
	}
	
	public static function getMTurkCode():String {
			
		var assignment_id:String = get("assignment_id", '');
		if (assignment_id == null || assignment_id.length == 0) return 'ERROR!';
		
		var s1:Int = 0;
		var s2:Int = 0;
		var tempInt:Int;
		for (i in 0...assignment_id.length)
		{
			tempInt = assignment_id.charCodeAt(i);
			s1+=Math.floor(tempInt/10);
			s2+=tempInt-(Math.floor(tempInt*.1)*10);
		}
		return Std.string(s1+s2);

	}
	
	public static function get(what, _default:Dynamic = null):Dynamic {
		var found = IS(what, false);
		if (found == null) {
			return _default;
		}
		return found;
	}
	
	public static function IS(what:String, throwException:Bool = true):Dynamic {
		if (map.exists(what) == false) { 
			if (what == 'startTime') return startTime;
			if (what == 'duration') return getDuration();
			if(throwException == true) {
				trace(map);
				throw "requested prop does not exist in ExptWideSpecs: "+what;
			}
		}
		return map.get(what);
	}
	
	static private function getDuration():Float
	{
		return Date.now().getTime() - startTime.getTime();
	}
	
	static public function __testSet(what:String, to:String) {
		map.set(what, to);
	}

	static public function print() {
		trace("----------------------");
		trace("ExptWideSpecs params and vals");
		for (key in map.keys()) {
			trace(key, map.get(key));
		}
		trace("----------------------");
	}
	

	
	static public function override_for_develServer() 
	{	
		//map.set('evolveUrl', 'http://127.0.0.1:8000/evolve/');
		//map.set('cloudUrl', 'http://127.0.0.1:8000/api/sj_data');
	}
	
	static public function updateExternalVars(params:Map<String, String>) 
	{
		if (params == null) return;
		
		for (key in params.keys()) {
			//trace(key, params.get(key));
			map.set(key, params.get(key));
		}		
		
	}

	
}
