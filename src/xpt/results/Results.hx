package xpt.results;
import comms.CommsResult;
import comms.services.CrossDomain_service;
import comms.services.REST_Service;
import haxe.ds.StringMap;
import xpt.debug.DebugManager;
import xpt.trial.ExtractResults;
import xpt.trial.Special_Trial;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class Results
{

	private static var trickeToCloud:Bool;
	private static var expt_id:String;
	private static var uuid:String;
	private static inline var specialTag:String = 'info_';
	
	public static function setup(_expt_id:String, _uuid:String, _trickleToCloud:Bool) {
		expt_id = _expt_id;
		uuid = _uuid;
		trickeToCloud = _trickleToCloud;
	}
	
	public function new() 
	{	
	}
	
	public function add(trialResults:TrialResults, special:Special_Trial) 
	{
		if (trialResults == null) return;
	
		if(trickeToCloud)	__send_to_cloud(trialResults, special);
		
	}
	
public inline function __send_to_cloud(trialResults:TrialResults, special:Special_Trial) 
	{
		
		
		
		trialResults.addResult(specialTag+'expt_id', expt_id);
		trialResults.addResult(specialTag + 'uuid', uuid);
		trace(111, trialResults.results);

		if( special !=null ){
			switch(special) {
				case Special_Trial.First_Trial:
					//required
					trialResults.addMultipleResults(ComputerInfo.GET(), specialTag);					
					trialResults.addResult(specialTag+"ip",'ip');
					trialResults.addResult(specialTag+'overSJs',ExptWideSpecs.IS("overSJs"));
					
					var test:String;
					//courseInfo
					test = ExptWideSpecs.IS("xpt_user_id");
					if(test!=''){
						trialResults.addResult("xpt_user_id", test);
						trialResults.addResult("xpt_course_id", ExptWideSpecs.IS("xpt_course_id"));
					}
					
					//turkInfo
					test = ExptWideSpecs.IS("assignment_id");
					if(test!=''){
						trialResults.addResult("turk_assignment_id", test);
						trialResults.addResult("turk_worker_id", ExptWideSpecs.IS("worker_id"));
						trialResults.addResult("turk_hit_id", ExptWideSpecs.IS("hit_id"));
					}
					//flyingFishInfo
					test = ExptWideSpecs.IS("flyingfish_id");
					if(test!=''){
						trialResults.addResult("flyingfish_id", test);
						trialResults.addResult("flyingfish_study_id", ExptWideSpecs.IS("flyingfish_study_id"));
						trialResults.addResult("flyingfish_participant_id", ExptWideSpecs.IS("flyingfish_participant_id"));
						trialResults.addResult("flyingfish_site_id", ExptWideSpecs.IS("flyingfish_site_id"));
					}
					
				case Special_Trial.Last_Trial:
					//solitary
						//trialResults
						trialResults.addResult(specialTag+"final","True");
					
				case Special_Trial.Not_Special:
					//
			}
		}
		
		var restService:REST_Service = new REST_Service(trialResults.results, serviceResult('REST'));

		
		
		
	}
	
	private static function serviceResult(service:String) {
			return function(success:CommsResult, message:String) {
			trace(success,message);
			if (success == CommsResult.Success) DebugManager.instance.info(service +' service sent trial data successully');
			else DebugManager.instance.error(service + ' service failed to send trial data / data was not accepted by the backend',message);
		}
	}
	
	public static inline function __addMultipleParams(info:StringMap<String>,toAdd:StringMap<String>) {
		for (key in toAdd) {
			info.set(key, toAdd.get(key));
		}
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