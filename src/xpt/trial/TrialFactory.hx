package xpt.trial;
import assets.manager.FolderTree.Error;
import xpt.experiment.Experiment;
import xpt.stimuli.StimuliFactory;
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
		seekScripts(trial, skeleton.xml);
	}
	
	function seekScripts(trial:Trial, xml:Xml) 
	{
		trace(xml);
	}
	
	private function getIteration(skeleton:TrialSkeleton, trialNum:Int):Int
	{
		var i = skeleton.trials.indexOf(trialNum);
		if (i == -1) throw "devel err";
		return i;
	}
	

	

	
}