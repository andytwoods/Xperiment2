package xpt.results;
import haxe.Serializer;
import xpt.comms.CommsResult;
import xpt.comms.services.AbstractService;
import xpt.comms.services.CrossDomain_service;
import haxe.ds.StringMap;
import xpt.comms.services.REST_Service;
import xpt.debug.DebugManager;
import xpt.tools.Base64;
import xpt.tools.XTools;
import xpt.trial.Special_Trial;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */

@:allow(xpt.results.Test_Results)
class Results
{

	private static var trickeToCloud:Bool;
	private static var expt_id:String;
	private static var uuid:String;
	
	private static inline var specialTag:String = 'info_';
	
	private static var EXPT_ID_TAG:String = specialTag + 'expt_id';
	private static var UUID_TAG:String = specialTag + 'uuid';
	
	private var callbacks:Array<Bool->String->Void>;

	
	public static var testing:Bool = false;
	
	private var failedSend_backup:Map<String,String>;
	
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
	
	public function startOfStudy() 
	{
		__send_to_cloud(new TrialResults(), Special_Trial.First_Submit);
	}
	
	public function endOfStudy(callback:Bool->String->Void) 
	{
		if (callbacks == null) callbacks = new Array<Bool->String->Void>();
		callbacks.push(callback);
		__send_to_cloud(new TrialResults(), Special_Trial.Final_Submit);
	}
	
	public function __send_to_cloud(trialResults:TrialResults, special:Special_Trial) 
	{
		trialResults.addResult(EXPT_ID_TAG, expt_id);
		trialResults.addResult(UUID_TAG, uuid);

		if ( special != null ) {
			switch(special) {
				case Special_Trial.First_Submit:
					
					
					//required
					trialResults.addMultipleResults(ComputerInfo.GET(), specialTag);					
					trialResults.addResult(specialTag+"ip",'ip');
					trialResults.addResult(specialTag + 'overSJs', ExptWideSpecs.IS("overSJs"));
					trialResults.addResult(specialTag + "special", "first");
					#if html5
						var tzOffset = untyped Date.now().getTimezoneOffset();
						trialResults.addResult(specialTag + "timeZone", tzOffset);
					#end
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
					
				case Special_Trial.Final_Submit:
					trialResults.addResult(specialTag + "special", "last");
					trialResults.addResult(specialTag + "duration", Std.string(ExptWideSpecs.IS('duration')/1000));
					
				case Special_Trial.First_Trial:
					//
				case Special_Trial.Last_Trial:
					//
				case Special_Trial.Not_Special:
					//
			}
		}

		if (failedSend_backup != null) {
			trialResults.add_failed_to_send_Results(failedSend_backup);		
			failedSend_backup = null;
		}

		if (testing) return;
		
		trace(trialResults.results);
		
		var restService:AbstractService = new REST_Service(trialResults.results, serviceResult('REST', special));
	}
	
	private function serviceResult(service:String, special:Special_Trial) {
		return function(success:CommsResult, message:String, data:Map<String,String>) {
			
			if (success == CommsResult.Success) {
				DebugManager.instance.info(service +' service sent trial data successully');
			}
			else {
				DebugManager.instance.error(service + ' service failed to send trial data / data was not accepted by the backend', message);
				
				for (exclude in [EXPT_ID_TAG, UUID_TAG]) {
					data.remove(exclude);
				}
				
				if (failedSend_backup == null) failedSend_backup = new Map<String,String>();
				var val:String;
				var safeKey:String;
				for (key in data.keys()) {
					val = data.get(key);
					safeKey = XTools.safeProp(key, failedSend_backup);
					if (safeKey != key) safeKey += "_DEVEL_ERR";
					failedSend_backup.set(safeKey, val);
				}
			}

			if (special == Special_Trial.Final_Submit) {		
				if (callbacks != null) {
					if(failedSend_backup!=null){
						failedSend_backup.set(EXPT_ID_TAG, expt_id);
						failedSend_backup.set(UUID_TAG, uuid);
					}
					var data:String = null;
					if (failedSend_backup != null) {
						data = crunch(failedSend_backup.toString());
					}
					while (callbacks.length > 0) {
						callbacks.shift()( success == CommsResult.Success, data);
					}
				}
			}
				
		}
	}
	
	inline function crunch(failed_to_send:String):String
	{
		return Base64.encode(failed_to_send);
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