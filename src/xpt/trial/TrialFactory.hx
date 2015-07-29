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
		var iteration:Int = getIteration(skeleton, trialNum);
		trial.iteration = iteration;
		trial.trialNum  = trialNum;
		trial.name      = skeleton.names[iteration];
		
		trace(trial.name, 232323, skeleton.names[iteration],iteration);
	}
	
	static private function getIteration(skeleton:TrialSkeleton, trialNum:Int):Int
	{
		var i = skeleton.trials.indexOf(trialNum);
		if (i == -1) throw "";
		//trace(1111111, trialNum, skeleton.trials);
		return i;
	}
	

	

	
}