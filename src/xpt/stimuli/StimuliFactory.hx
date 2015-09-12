package xpt.stimuli;

import xpt.stimuli.BaseStimuli.BaseStimulus;
import xpt.tools.XTools;
import xpt.trial.Trial;
import xpt.trial.TrialSkeleton;

/**
 * ...
 * @author 
 */
class StimuliFactory {
	private static var withinTrialSep:String;
	private static var overTrialSep:String;
	private static var _stimClassMap:Map<String, Class<Stimulus>>;

	static public function generate(trial:Trial, skeleton:TrialSkeleton) {
		__recursiveGenerate(trial, null, skeleton.baseStimuli, 0);
	}
	
	private static function __recursiveGenerate(trial:Trial, parent:Stimulus, baseStimuli:Array<BaseStimulus>, unknownIdCount:Int) {
		var baseStimulus:BaseStimulus;
		var stim:Stimulus;
		
		for (i in 0...baseStimuli.length) {
			
			baseStimulus = baseStimuli[i];
			
			stim = getStim(baseStimulus.name);
			setProps(stim, baseStimulus.howMany, baseStimulus.props, trial);
			
			if (stim.id == null) {
				stim.id = "id" + Std.string(unknownIdCount++);
			}
			
			trial.stimuli.push(stim);
			if (parent != null) parent.addUnderling(stim);
			

			if(baseStimulus.children.length>0)	__recursiveGenerate(trial, stim, baseStimulus.children, unknownIdCount);
			
		}
	}
	
	private static function setProps(stim:Stimulus, howMany:Int, props:Map<String,String>, trial:Trial) {
		//var howMany:Int = 1;
		var trialIteration:Int = trial.iteration;

		for(count in 0...howMany){
			for (key in props.keys()) {
				var val:String = props.get(key);
				val = XTools.multiCorrection(	val, overTrialSep, trialIteration);
				val = XTools.multiCorrection(	val, withinTrialSep, count);
				stim.set(key, specialType(key,val)	);
			}
			
			trial.addStimulus(stim);
		}
	}
	
	private static function specialType(name:String, val:Dynamic):Dynamic {
		return val;
	}
	
	private static function getStim(type:String):Stimulus {
		if (_stimClassMap == null) {
			return null;
		}
		type = type.toLowerCase();
		var cls:Class<Stimulus> = _stimClassMap.get(type);
		var instance:Stimulus = null;
		if (cls != null) {
			instance = Type.createInstance(cls, []);
		}
		return instance;
	}
	
	public static function registerStimClass(type:String, cls:Class<Stimulus>):Void {
		if (_stimClassMap == null) {
			_stimClassMap = new Map<String, Class<Stimulus>>();
		}
		_stimClassMap.set(type, cls);
	}
	
	public static function getPermittedStimuli():Array<String> {
		if (_stimClassMap == null) {
			return [];
		}
		var array = [];
		for (k in _stimClassMap.keys()) {
			array.push(k);
		}
		return array;
	}
	
	public static function setLabels(within:String, outside:String) {
		withinTrialSep = within;
		overTrialSep = outside;
	}
}