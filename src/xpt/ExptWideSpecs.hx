package xpt;

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
	//blocking
		map.set("blockDepthOrder","");
	//saving
		map.set("saveFailMessage", "<font size= '20'><b>There was a problem when trying to save your results.</b></font>\n\n<font size= '20'>We hope you don't mind, but could you send the text below to EMAILADDRESS. For your convenience, this text has been copied to your clipboard.\n\n Are you a <b>Mechanical Turker</b>? Make sure to close this window when done to retrieve your code. Thanks.");
		map.set("saveSuccessMessage","<font size= '20'><b>Successfully saved your data. You can close this message-window. Thankyou.<font size= '15'>");
		map.set("saveClose","close when ready");
		map.set("trickleToCloud","true");
		map.set("cloudUrl","https://www.xpt.mobi/api/sj_data");
		map.set("saveWaitDuration","10");
	//timing
		map.set("ITI", "500");
		
	//validation
		map.set('invalidTrialBehaviour', 'disable');

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
		}
	}
	
	public static function exptId():String {
		return map.get("exptId");
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
		map.set('cloudUrl', 'http://127.0.0.1:8000/api/sj_data');
		//map.set('exptId', '17c23b394aab4c4da6f4acbcf458e065');
	}
	
	static public function updateExternalVars(params:Map<String, String>) 
	{
		if (params == null) return;
		
		for (key in params.keys()) {
			map.set(key, params.get(key));
		}
		
		
	}

	
}
