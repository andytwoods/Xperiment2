package xpt;

import openfl.Assets;
import thx.Uuid;
import xpt.tools.XML_tools;

												
class ExptWideSpecs
{

	private static var map:Map<String,String> = new Map<String,String>();
	
	public static var trial_sep:String  = ';';
	public static var stim_sep:String = '---';
	public static var trialName:String = "trialName";
	public static var filename:String = "asset";
	
	public static function kill() {
		map = new Map<String,String>();
		
	}
	
	public static function init() {

		var xml:Xml = Xml.parse(Assets.getText("data/exptWideSpecs.xml"));
		
		var defaults:Map<String,String> = XML_tools.allNodes(xml);
		//trace(defaults, 22);
		for (key in defaults.keys()) {
			map.set(key, defaults.get(key));
		}
		map.set('stimuliFolder', Xpt.localExptDirectory + Xpt.exptName + "/");
		map.set('uuid',Uuid.create());
		map.set('timeStart', Date.now().toString());
		
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
		return map.get("expt_id");
	}
	
	public static function IS(what:String):Dynamic {
		if (map.exists(what) == false) {
			trace(map);
			throw "requested prop does not exist in ExptWideSpecs: "+what;
		}
		return map.get(what);
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
		map.set('expt_id', '17c23b394aab4c4da6f4acbcf458e065');
	}
	
	static public function updateExternalVars(params:Map<String, String>) 
	{
		if (params == null) return;
		for (key in params.keys()) {
			map.set(key, params.get(key));
		}
		
		
	}

	
}
