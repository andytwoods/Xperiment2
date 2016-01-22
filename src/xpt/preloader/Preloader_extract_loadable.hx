package xpt.preloader;
import thx.Arrays;
import thx.Ints;
import xpt.tools.XTools;
import xpt.trial.TrialSkeleton;


class Preloader_extract_loadable
{
	static private var trial_sep:String = "|";
	static private var stim_sep:String = "---";
	static private var loadableWords:Array<String> = ["resource","resourcePattern"];
	
	public function new() {}
	
	static public function setLabels(_stim_sep:String, _trial_sep:String) 
	{
		stim_sep = _stim_sep;
		trial_sep = _trial_sep;
	}
	
	
	public function buildPreloadList(props:Map<String, String>):Array<String> {
		var array:Array<String> = new Array<String>();
		var resourcePattern:String = props.get("resourcePattern");
		
		var startString:String = props.get("start");
		var start:Int = 1;
		if (startString != null) {
			start = Std.parseInt(startString);
		}
		
		var countString:String = props.get("count");
		var count = 1;
		if (countString != null) {
			count = Std.parseInt(countString);
		}
		
		if (resourcePattern != null && count >= 1) {
			for (n in start...count + 1) {
				array.push(StringTools.replace(resourcePattern, "${value}", "" + n));
			}
		}
		return array;
	}
	
	public function extract(skeletons:Array<TrialSkeleton>):Array<String>
	{
		var preloadList:Array<String> = new Array<String>();
		
		for (skeleton in skeletons) {
			for (baseStim in skeleton.baseStimuli) {
				for(loadableWord in loadableWords){
					var stimPreload:Array<String> = findLoadable( 
							strip_to_loadable(baseStim.props, loadableWord),
							skeleton.trials.length, baseStim.howMany 
						);
					if (stimPreload.length>0) {
						preloadList = preloadList.concat(stimPreload);
					}
				}
			}
		}
		
		return Arrays.distinct(preloadList);
	}
	
	
	@:allow(xpt.preloader.Test_Preloader_extract_loadable)
	function findLoadable(stripped:Map<String, String>, trials:Int, howMany:Int):Array<String> 
	{
		var arr:Array<String> = new Array<String>();
		var str:String;
		var map:Map<String,String>;
		var val:String;
		var modVal:String;
		

		for (trial in 0...trials) {
			for (howM in 0...howMany) {
				map = new Map<String,String>();

				for (key in stripped.keys()) {
					val = stripped.get(key);
					str = XTools.multiCorrection(val, trial_sep, trial);
					str = XTools.multiCorrection(str, stim_sep, howM);
					map.set(key, str);
				}

				XTools.appendUpNumberedProps(map);
				for (modKey in map.keys()) {
					modVal = map.get(modKey);
					if(Ints.canParse(modKey.charAt(modKey.length-1)) == false){
						arr.push(modVal);
					}
				}
			}
		}
			
		
		return arr;
	}
	
	function strip_to_loadable(map:Map<String,String>, nam:String):Map<String,String> 
	{
		var found:Map<String,String> = new Map<String,String>();
		
		for (key in map.keys()) {
			trace(111, key,key.length >= nam.length && key.substr(0, nam.length-1) == nam);
			if (key.substr(0, nam.length-1) == nam) {
				found.set(key, map.get(key));
			}
		}
		
		return found;
	}
	

	

	
	
}