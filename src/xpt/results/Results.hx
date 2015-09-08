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
				
				//multiple
				__addResults(trialResults, ExptWideSpecs.IS("courseInfo"));
				__addResults(trialResults, ExptWideSpecs.IS("turkInfo"));
				
				//solitary
				__addResult(trialResults, "ip");
				__addResult(trialResults, ExptWideSpecs.IS("overSJs"));
				
			case Special_Trial.Last_Trial:
				__addResults(trialResults, ExptWideSpecs.IS("exptInfo"));
			default:
				//
		}
	}
	
	public static inline function __addResult(trialResults:TrialResults, what:String) {
		var val:String =  ExptWideSpecs.IS(what);
		if (val == "") return;
		trialResults.addResult(what, val);
	}
	
	public static inline function __addResults(trialResults:TrialResults, info:Map<String, String>) 
	{
		info = __removeEmpty(info);
		trialResults.addMultipleResults(info);
	}
	
	static public function __removeEmpty(info:Map<String, String>) 
	{
		var existing_info:Map<String,String> = new Map<String,String>();
		var val:String;
		for (key in info.keys()) {
			val = info.get(key);
			if (val != "") existing_info.set(key, val);
		}
		return existing_info;
	}
	

	
}