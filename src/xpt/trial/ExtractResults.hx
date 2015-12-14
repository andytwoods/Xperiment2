package xpt.trial;
import thx.Maps;
import xpt.results.TrialResults;
import xpt.stimuli.Stimulus;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class ExtractResults
{
	
	static public inline function DO(trial:Trial):TrialResults
	{

		if (trial.hideResults == true) return null;
		
		var trialResults:TrialResults = new TrialResults();
		
		extract(trial, trialResults);

		if (trialResults.results.keys().hasNext() == false) return null;
		
		trialResults.trialNum = trial.trialNum;
		trialResults.trialBlock = trial.trialBlock;
		trialResults.iteration = trial.iteration;
			
		return trialResults;
	}
	
	static public inline function extract(trial:Trial,trialResults:TrialResults):TrialResults {
		

		var stimRes:Map<String,String>;
		var stimulus:Stimulus;
		
		for (i in 0...trial.stimuli.length) {
			stimulus = trial.stimuli[i]; //ensures order
			if (stimulus.hideResults == false) {
				stimRes = stimulus.results();
				trialResults.addMultipleResults(stimRes);		
			}
		}
		return trialResults;
	}	
	
	
}