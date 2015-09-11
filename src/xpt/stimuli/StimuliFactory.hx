package xpt.stimuli;
import xpt.stimuli.all.*;
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
		
		__recursiveGenerate(trial, null, skeleton.baseStimuli, 0);
	}
	
	public static function __recursiveGenerate(trial:Trial, parent:Stimulus, baseStimuli:Array<BaseStimulus>, unknownIdCount:Int) {
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
		
		
		
	
	static private function setProps(stim:Stimulus, howMany:Int, props:Map<String,String>, trial:Trial) 
	{
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
	
	static private function specialType(name:String, val:Dynamic):Dynamic
	{
		return val;
		
	}
	
	static private function getStim(type:String):Stimulus {
		switch(type.toLowerCase()) {
			case 'button':
				return new Stim_Button();
			case 'addbutton':
				return new Stim_Button();
			case 'addtext':
				return new Stim_Text();
			case 'addloadingindicator':
				return new Stim_LoadingIndicator();
			
			
			
			
			
			case 'teststim':
				return new Stimulus();
		}

		return null;
	}
	
	static public function setLabels(within:String, outside:String) {
		withinTrialSep = within;
		overTrialSep = outside;
	}
}