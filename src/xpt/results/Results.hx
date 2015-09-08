package xpt.results;
import xpt.trial.ExtractResults;
import xpt.trial.Special_Trial;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class Results
{

	public static var trickeToCloud:Bool = true;
	public static var courseInfo:Map<String,String>;
	public static var turkInfo:Map<String,String>;
	
	
	public function new() 
	{	
	}
	
	public function add(trialResults:TrialResults, special:Special_Trial) 
	{
		if (trialResults == null) return;
		
		if(trickeToCloud)	__send_to_cloud(trialResults, special);
		/*
		switch(special) {
			case Special_Trial.First_Trial:
				//
			case Special_Trial.Last_Trial:
				//
			default:
				//
		}
			*/
			
		
	}
	
	public function __send_to_cloud(trialResults:TrialResults, special:Special_Trial) 
	{
		switch(special) {
			case Special_Trial.First_Trial:
				__addResultsInfo(trialResults, courseInfo);
				__addResultsInfo(trialResults, turkInfo);
			case Special_Trial.Last_Trial:
				//
			default:
				//
		}
	}
	
	public static function __addResultsInfo(trialResults:TrialResults, courseInfo:Map<String, String>) 
	{
			trialResults.addMultipleResults(courseInfo);
	}
	

	
}