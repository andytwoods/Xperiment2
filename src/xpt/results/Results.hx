package xpt.results;
import comms.CommsResult;
import comms.services.REST_Service;
import haxe.ds.StringMap;
import xpt.trial.ExtractResults;
import xpt.trial.Special_Trial;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class Results
{

	public static var trickeToCloud:Bool;
	public static var expt_id:String;
	
	public static function setup(_expt_id:String, _trickleToCloud:Bool) {
		expt_id = _expt_id;
		trickeToCloud = _trickleToCloud;
	}
	
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
	
public inline function __send_to_cloud(trialResults:TrialResults, special:Special_Trial) 
	{
		trialResults.addResult('expt_id', expt_id);
		
		switch(special) {
			case Special_Trial.First_Trial:
				//multiple
					__addResults(trialResults, ExptWideSpecs.IS("courseInfo"));
					__addResults(trialResults, ExptWideSpecs.IS("turkInfo"));
					__addResults(trialResults, ExptWideSpecs.IS("flyingFishInfo"));
				//solitary
				__addResult(trialResults, "ip");
				__addResult(trialResults, ExptWideSpecs.IS("overSJs"));
				
			case Special_Trial.Last_Trial:
				//solitary
					//trialResults
					trialResults.addResult("final","True");
				
			default:
				//
		}
		
		var restService:REST_Service = new REST_Service(trialResults.results, function(success:CommsResult, message:String) {
			trace(success);
		});
		
	}
	
	public static inline function __addInfo(info:StringMap<String>,toAdd:StringMap<String>) {
		for (key in toAdd) {
			info.set(key, toAdd.get(key));
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