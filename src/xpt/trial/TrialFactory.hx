package xpt.trial;
import assets.manager.FolderTree.Error;
import code.CheckIsCode;
import xpt.experiment.Experiment;
import xpt.stimuli.StimuliFactory;
import xpt.tools.XML_tools;
import xpt.tools.XTools;
import xpt.trial.TrialSkeleton;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class TrialFactory
{
	public function new() { }
		
	private var stimuliFactory:StimuliFactory = new StimuliFactory();
	private static var withinTrialSep:String;
	private static var overTrialSep:String;
	
	public function GET(skeleton:TrialSkeleton, trialNum:Int, experiment:Experiment):Trial
	{		
		var trial = new Trial(experiment);
		compose(trial, skeleton, trialNum);
		stimuliFactory.generate(trial, skeleton);

		return trial;
	}
	
	function compose(trial:Trial, skeleton:TrialSkeleton, trialNum:Int) 
	{
		//trace(iteration,skeleton.names);
		trial.iteration = getIteration(skeleton, trialNum);
		trial.trialNum  = trialNum;
		trial.trialName = skeleton.names[trial.iteration];
		trial.trialBlock = skeleton.blockPosition;
		trial.stimuliFactory = stimuliFactory;
		seeIfOverrideDefaults(trial, skeleton.otherParams); 
		CheckIsCode.seekScripts(trial, skeleton.xml);
	}
	
	function seeIfOverrideDefaults(trial:Trial, otherParams:Map<String,String>) 
	{
		var overrideDefaults:Map<String,String> = new Map<String,String>();

		for(prop in otherParams.keys()){
			var val:String = otherParams.get(prop);
			if(val!=null){
				val = XTools.multiCorrection(	val, overTrialSep, trial.iteration);
				overrideDefaults.set(prop,  val	);
			}
		}

		trial.overrideDefaults(overrideDefaults);
	}
		
	private function getIteration(skeleton:TrialSkeleton, trialNum:Int):Int
	{
		var i = skeleton.trials.indexOf(trialNum);
		if (i == -1) throw "devel err";
		return i;
	}
	
	static public function setLabels(stim_sep:String, trial_sep:String) 
	{
		withinTrialSep = stim_sep;
		overTrialSep = trial_sep;
	}
	
}