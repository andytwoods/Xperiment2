package xpt.preloader;
import code.Scripting;
import thx.Arrays;
import thx.Ints;
import xpt.tools.PathTools;
import xpt.tools.XTools;
import xpt.trial.TrialSkeleton;


class Preloader_extract_loadable
{
	static private var trial_sep:String = "|";
	static private var stim_sep:String = "---";
	static private var resourcePattern:String = "resourcePattern";
	static private var loadableWords:Array<String> = ["resource",resourcePattern];
	
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
		var stripped_to_loadable:Map<String, String>;
		for (skeleton in skeletons) {
			for (baseStim in skeleton.baseStimuli) {
				for (loadableWord in loadableWords) {
					if (baseStim.props.exists(loadableWord) == true) {
						stripped_to_loadable = strip_to_loadable(baseStim.props, loadableWord);
						var stimPreload:Array<String> = findLoadable(	stripped_to_loadable, 
																		skeleton.trials.length, 
																		baseStim.howMany , 
																		loadableWord,
																		baseStim.props	);
						
						if (stimPreload.length>0) {
							preloadList = preloadList.concat(stimPreload);
						}
					}
				}
			}
		}
		
        var distinct:Array<String> = Arrays.distinct(preloadList);
        var final:Array<String> = [];
        for (path in distinct) {
            final.push(PathTools.fixPath(path));
        }
        
		return final;
	}
	
	
	
	@:allow(xpt.preloader.Test_Preloader_extract_loadable)
	function findLoadable(stripped:Map<String, String>, trials:Int, howMany:Int, loadableWord:String, props:Map<String,String>):Array<String> 
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
					if (Ints.canParse(modKey.charAt(modKey.length - 1)) == false) {
						if (loadableWord == resourcePattern) arr = arr.concat(resourcePatternMultiply(modVal, props));
						else if (modVal.indexOf("${")!=-1) arr.push(Scripting.expandScriptValues(modVal));
						else arr.push(modVal);
					}
				}
			}
		}
			
		return arr;
	}
	

	
	function resourcePatternMultiply(modVal:String, props:Map<String, String>):Array<String>
	{
		var arr:Array<String> = new Array<String>();
		
		if (props.exists('count') == false) return arr;
		
		var count:Int = Std.parseInt(props.get('count'));
		
		for (i in 1...count) {
			arr.push(modVal.split("${value}").join(Std.string(i)));
		}
		return arr;
	}
	
	
	
	function strip_to_loadable(map:Map<String,String>, nam:String):Map<String,String> 
	{
		var found:Map<String,String> = new Map<String,String>();
		
		found.set(nam, map.get(nam));
		
		for (key in map.keys()) {
			if (key.substr(0, nam.length) == nam) {
				found.set(key, map.get(key));
			}
		}
		
		return found;
	}
	

	

	
	
}