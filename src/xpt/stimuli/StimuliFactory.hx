package xpt.stimuli;
import xpt.stimuli.BaseStimuli.BaseStimulus;
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
		var baseStimulus:BaseStimulus;
		
		var unknown:Int = 1;
		
		for (i in 0...skeleton.baseStimuli.length) {
			baseStimulus = skeleton.baseStimuli[i];
			stim = getStim(baseStimulus.name);
			setProps(stim, baseStimulus.howMany, baseStimulus.props, trial);
			if (stim.id == null) {
				stim.id = "id" + Std.string(unknown++);
			}
			trial.stimuli.push(stim);
		}
		
	}
	
	static private function setProps(stim:Stimulus, howMany:Int, props:Map<String,String>, trial:Trial) 
	{
		//var howMany:Int = 1;
		var trialIteration:Int = trial.iteration;

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