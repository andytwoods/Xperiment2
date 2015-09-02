package xpt.trial;
import assets.manager.FolderTree.Error;
import xpt.stimuli.StimuliFactory;
import xpt.trial.TrialSkeleton;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class TrialFactory
{

	static public function GET(skeleton:TrialSkeleton, trialNum:Int):Trial
	{		
		var trial = new Trial();
		compose(trial, skeleton, trialNum);
		StimuliFactory.generate(trial, skeleton);
		return trial;
	}
	
	static function compose(trial:Trial, skeleton:TrialSkeleton, trialNum:Int) 
	{
		//trace(iteration,skeleton.names);
		trial.iteration = getIteration(skeleton, trialNum);
		trial.trialNum  = trialNum;
		trial.trialName = skeleton.names[trial.iteration];
		trial.trialBlock = skeleton.blockPosition;
	}
	
	static private function getIteration(skeleton:TrialSkeleton, trialNum:Int):Int
	{
		var i = skeleton.trials.indexOf(trialNum);
		if (i == -1) throw "devel err";
		return i;
	}
	

	

	
}