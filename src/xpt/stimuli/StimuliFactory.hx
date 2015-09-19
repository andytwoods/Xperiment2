package xpt.stimuli;

import xpt.stimuli.BaseStimuli.BaseStimulus;
import xpt.tools.XTools;
import xpt.trial.Trial;
import xpt.trial.TrialSkeleton;

class StimuliFactory {
	private static var withinTrialSep:String;
	private static var overTrialSep:String;
	private static var _stimBuilderMap:Map<String, Class<StimulusBuilder>>;
	private static var _stimParams:Map<String, Map<String, String>>;

	static public function generate(trial:Trial, skeleton:TrialSkeleton) {
		__recursiveGenerate(trial, null, skeleton.baseStimuli, 0);
	}
	
	private static function __recursiveGenerate(trial:Trial, parent:Stimulus, baseStimuli:Array<BaseStimulus>, unknownIdCount:Int) {
		var baseStimulus:BaseStimulus;
		var stim:Stimulus;
		
		for (i in 0...baseStimuli.length) {
			
			baseStimulus = baseStimuli[i];
			
			stim = getStim(baseStimulus.name);
			stim.parent = parent;
			if (parent != null) {
				parent.children.push(stim);
			}
			
			setProps(stim, baseStimulus.howMany, baseStimulus.props, trial);
			
			if (stim.id == null) {
				stim.id = "id" + Std.string(unknownIdCount++);
			}
			
			trial.stimuli.push(stim);
			if (parent != null) {
				parent.addUnderling(stim);
			}

			if (baseStimulus.children.length > 0) {
				__recursiveGenerate(trial, stim, baseStimulus.children, unknownIdCount);
			}
			
			if (parent == null) {
				trial.addStimulus(stim);
			}
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
			
			stim.set("trial", trial);
			if (stim.parent == null) {
				//trial.addStimulus(stim);
			}
		}
	}
	
	private static function specialType(name:String, val:Dynamic):Dynamic {
		return val;
	}
	
	private static function getStim(type:String, stimParams:Map<String, String> = null):Stimulus {
		if (_stimBuilderMap == null) {
			return null;
		}
		type = type.toLowerCase();
		var cls:Class<StimulusBuilder> = _stimBuilderMap.get(type);
		var instance:Stimulus = null;
		if (cls != null) {
			instance = new Stimulus();
			instance.set("stimType", type);
			
			if (stimParams != null) {
				for (k in stimParams.keys()) {
					instance.set(k, stimParams.get(k));
				}
			}
			
			var params:Map<String, String> = getStimParams(type);
			if (params != null) {
				for (k in params.keys()) {
					instance.set(k, params.get(k));
				}
			}
			
			if (_stimChildDefs != null) {
				var defs:Array<Xml> = _stimChildDefs.get(type);
				if (defs != null) {
					for (defNode in defs) {
						var defParams:Map<String, String> = new Map<String, String>();
						for (attr in defNode.attributes()) {
							defParams.set(attr, defNode.get(attr));
						}
						for (defChild in defNode.elements()) {
							defParams.set(defChild.nodeName, defChild.firstChild().nodeValue);
						}
						
						instance.children.push(getStim(defNode.nodeName, defParams));
					}
				}
			}
			
			instance.builder = Type.createInstance(cls, []);
		}
		return instance;
	}
	
	public static function registerStimBuilderClass(type:String, cls:Class<StimulusBuilder>):Void {
		if (_stimBuilderMap == null) {
			_stimBuilderMap = new Map<String, Class<StimulusBuilder>>();
		}
		_stimBuilderMap.set(type.toLowerCase(), cls);
	}
	
	public static function getPermittedStimuli():Array<String> {
		if (_stimBuilderMap == null) {
			return [];
		}
		var array = [];
		for (k in _stimBuilderMap.keys()) {
			array.push(k);
		}
		return array;
	}
	
	public static function addStimParam(type:String, name:String, value:String):Void {
		if (name == "children") {
			return;
		}
		
		if (_stimParams == null) {
			_stimParams = new Map<String, Map<String, String>>();
		}
		
		type = type.toLowerCase();
		var params:Map<String, String> = _stimParams.get(type);
		if (params  == null) {
			params = new Map<String, String>();
			_stimParams.set(type, params);
		}
		params.set(name, value);
	}
	
	public static function getStimParams(type:String):Map<String, String> {
		if (_stimParams == null) {
			return null;
		}
		var params:Map<String, String> = _stimParams.get(type);
		return params;
	}
	
	private static var _stimChildDefs:Map<String, Array<Xml>>;
	public static function addStimChildDef(type:String, childDef:Xml) {
		if (_stimChildDefs == null) {
			_stimChildDefs = new Map<String, Array<Xml>>();
		}
		
		var defs:Array<Xml> = _stimChildDefs.get(type);
		if (defs == null) {
			defs = new Array<Xml>();
			_stimChildDefs.set(type, defs);
		}
		
		defs.push(childDef);
	}
	
	public static function getStimPreloadList(type:String, props:Map<String, String>):Array<String> {
		if (_stimBuilderMap == null) {
			return null;
		}
		type = type.toLowerCase();
		var cls:Class<StimulusBuilder> = _stimBuilderMap.get(type);
		var array:Array<String> = null;
		if (cls != null) {
			var builder:StimulusBuilder = Type.createInstance(cls, []);
			array = builder.buildPreloadList(props);
		}
		return array;
	}
	
	public static function setLabels(within:String, outside:String) {
		withinTrialSep = within;
		overTrialSep = outside;
	}
}