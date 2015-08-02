package xpt.stimuli;
import xpt.tools.XML_tools;
import xpt.tools.XTools;
import xpt.trial.Trial;
import xpt.trial.TrialSkeleton;

/**
 * ...
 * @author 
 */
class StimuliFactory
{
	static private var withinTrialSep:String;
	static private var overTrialSep:String;

	
	
	static public function generate(trial:Trial, skeleton:TrialSkeleton) {
	
		var stim:Stimulus;
		for (base_stim in skeleton.baseStimuli) {
			stim = getStim(base_stim.name);
			setProps(stim, base_stim.props,trial);
		}
	}
	
	static private function setProps(stim:Stimulus, props:Map<String,String>, trial:Trial) 
	{
		var howMany:Int = 1;
		var trialIteration:Int = trial.iteration;
		
		//trace("iteration:", trialIteration);
		if (props.exists("howMany")) {
			howMany = Std.parseInt(props.get("howMany"));
		}
		
		for(count in 0...howMany){
		
			for (key in props.keys()) {
				var val:String = props.get(key);
				//trace(1, val);
				val = XTools.multiCorrection(	val, overTrialSep, trialIteration);
				//trace(2, val,trialIteration);
				val = XTools.multiCorrection(	val, withinTrialSep, count);
				//trace(3, val,count);
				stim.set(key, specialType(key,val)	);
			}
			
			trial.addStimulus(stim);
			
		}
	}
	
	static private function specialType(name:String, val:Dynamic):Dynamic
	{
		return val;
		
	}
	
	static private function getStim(type:String):Stimulus {
	
		
		return new Stimulus();
	}
	
	static public function setLabels(within:String, outside:String) {
		withinTrialSep = within;
		overTrialSep = outside;
	}
}