package xpt.experiment;
import thx.Strings;
import xpt.stimuli.BaseStimulus;
import xpt.trial.TrialSkeleton;

/**
 * ...
 * @author 
 */

class Translate
{
	static private inline var DEFAULT:String = '.default';
	
	
	static public function DO(trialSkeletons:Array<TrialSkeleton>, lang:String, all_langs:Array<String>, _default:String) 
	{
		for (trialSkeleton in trialSkeletons) {
			for (base_stim in trialSkeleton.baseStimuli) {
				//__translate(base_stim.props, lang, all_langs, _default);
			}
		}
	}
	
	
	static public function __translate(props:Map<String,String>, lang:String, all_langs:Array<String>, _default:String) 
	{
	
		var find:String = "." + lang;
		var len:Int = find.length;
		var actual:String;
		var old_val:String;
		
		var addBack:Map<String,String> = null;
		
		for (prop in props.keys()) {
		
			if (prop.substr(prop.length - len) == find) {
				if (addBack == null) addBack = new Map<String,String>();
				actual = prop.substr(0, prop.length - len);
				if (_default.length > 0) {
					old_val = props.get(actual);
					if (old_val == null) old_val = '';
					addBack.set(actual+"."+_default, old_val); 
				}
				
				addBack.set(actual, props.get(prop)); 
			}
		}
		
		if (addBack != null) {
			for (prop in addBack.keys()) {
				props.set(prop, addBack.get(prop));
			}
		}
	}
	
	
}