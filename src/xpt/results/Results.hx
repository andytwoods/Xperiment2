package xpt.results;
import haxe.Serializer;
import thx.Bools;
import xpt.comms.CommsResult;
import xpt.comms.services.AbstractService;
import xpt.comms.services.CrossDomain_service;
import haxe.ds.StringMap;
import xpt.comms.services.PackageRESTservices_Tool;
import xpt.comms.services.REST_Service;
import xpt.debug.DebugManager;
import xpt.tools.Base64;
import xpt.tools.XRandom;
import xpt.tools.XTools;
import xpt.trial.Special_Trial;
import xpt.trial.Trial;
import xpt.ui.Xpt2Info;

/**
 * ...
 * @author 
 */

@:allow(xpt.results.Test_Results)
class Results
{
	public static var testing:Bool = false;
	static public var url:String;
	
	private static var trickleToCloud:Bool;
	private static var expt_id:String;
	private static var uuid:String;
	private static var csrftoken:String;
	
	private static inline var specialTag:String = 'info_';
	private static inline var EXPT_ID_TAG:String = specialTag + 'expt_id';
	private static inline var UUID_TAG:String = specialTag + 'uuid';
	private static inline var SPECIAL_TAG:String = specialTag + 'special';
	private static inline var DURATION_TAG:String = specialTag + 'duration';
	private static inline var FAILED_SEND_COUNTER_TAG:String = "failedSendCounter";
	private static inline var FAILED_SEND_END_OF_STUDY_COUNTER_TAG:String = "failedSend_endOfStudy_Counter";
	private static inline var CSRF_TAG:String = 'csrfmiddlewaretoken';
	
	private var callbacks:Array<Bool->String->Void>;
	private var failedSend_counters:Map<String,Int> = [FAILED_SEND_COUNTER_TAG => 0, FAILED_SEND_END_OF_STUDY_COUNTER_TAG => 0];
	private var failedSend_backup:Map<String,String>;
	private var combinedResults:TrialResults;
	
	public static function setup(_expt_id:String, _uuid:String, _trickleToCloud:String, _csrftoken:String) {
		expt_id = _expt_id;
		uuid = _uuid;

		trickleToCloud = Bools.parse(_trickleToCloud);
		csrftoken = _csrftoken;
		
	}
	
	public function new() 
	{	
		combinedResults = new TrialResults();
	}
	
	public function add(trialResults:TrialResults, special:Special_Trial) 
	{
		if (trialResults == null) return;

		if(trickleToCloud)	__send_to_cloud(trialResults, special);
		
	}
	
	public function startOfStudy() 
	{
		__send_to_cloud(new TrialResults(), Special_Trial.First_Submit);
	}
	
	public function endOfStudy(callback:Bool->String->Void) 
	{
		if (callbacks == null) callbacks = new Array<Bool->String->Void>();
		callbacks.push(callback);
		
		if (combinedResults == null) combinedResults = new TrialResults();
		
		__send_to_cloud(combinedResults, Special_Trial.Final_Submit);
	}
	
	public function __send_to_cloud(trialResults:TrialResults, special:Special_Trial) 
	{
		trace(trialResults.results);

		if ( special != null ) {
			switch(special) {
				case Special_Trial.First_Submit:
					
					//required
					trialResults.addMultipleResults(ComputerInfo.GET(), specialTag);					
					trialResults.addMultipleResults(Xpt2Info.GET(), specialTag);
					trialResults.addResult(specialTag+"ip",'ip');
					trialResults.addResult(specialTag + 'overSJs', ExptWideSpecs.IS("overSJs"));
					trialResults.addResult('random_seed', XRandom.getSeed());
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
					finalSubmit_params(trialResults, true);
								
				case Special_Trial.First_Trial:
					//
				case Special_Trial.Last_Trial:
					//
				case Special_Trial.Not_Special:
					//
			}
		}

		if (testing) return;
		
		//compiling all results, which are sent on very last trial (as a backup).
		if (combinedResults != null && combinedResults != trialResults) {
			combinedResults.addMultipleResults(trialResults.results);
		}

		//if data does not save on one trial, data is attempted to be saved on the next (etc)
		if (failedSend_backup != null && special != Special_Trial.Final_Submit) {
			trialResults.add_failed_to_send_Results(failedSend_backup);		
			failedSend_backup = null;
		}
		
		//seperated from above so we can cleanly add new data to combinedResults.
		if ( special != null ) {
			switch(special) {
				case Special_Trial.First_Submit:
					trialResults.addResult(specialTag + "special", "first");
				case Special_Trial.Final_Submit:
					trialResults.addResult(SPECIAL_TAG, "last");
				case Special_Trial.First_Trial:
					//
				case Special_Trial.Last_Trial:
					//
				case Special_Trial.Not_Special:
					//
			}
		}
		
		trialResults.addResult(EXPT_ID_TAG, expt_id);
		trialResults.addResult(UUID_TAG, uuid);
		trialResults.addResult(CSRF_TAG, csrftoken);
		
		if (trialResults.results.exists(specialTag+"ip") == true) {
			trialResults.addResult(specialTag + "special", "first");
		}
		
		//trace(trialResults.results);
		
		//new PackageRESTservices_Tool(trialResults.results, serviceResult('REST', special), [EXPT_ID_TAG => expt_id, UUID_TAG => uuid]);
		new REST_Service(trialResults.results, serviceResult('REST', special), 'POST', url);
	}

	
	private function finalSubmit_params(trialResults:TrialResults, add:Bool) {
		if (add == true) {
			trialResults.addResult(DURATION_TAG, Std.string(ExptWideSpecs.IS('duration') / 1000));
			if (failedSend_counters.get(FAILED_SEND_COUNTER_TAG) > 0) {
				trialResults.addResult(FAILED_SEND_COUNTER_TAG, Std.string(failedSend_counters.get(FAILED_SEND_COUNTER_TAG)));
			}	
		}
		else {
			trialResults.results.remove(DURATION_TAG);
			trialResults.results.remove(FAILED_SEND_COUNTER_TAG);
			trialResults.results.remove(SPECIAL_TAG);
		}
	}
	
	private function serviceResult(service:String, special:Special_Trial) {
		return function(success:CommsResult, message:String, data:Map<String,String>) {
			//trace(success, message, 22);
			if (success == CommsResult.Success) {
				DebugManager.instance.info(service +' service sent trial data successully');
			}
			else {
				
				DebugManager.instance.error(service + ' service failed to send trial data / data was not accepted by the backend', message);
				
				if (special == Special_Trial.Final_Submit) {
					combinedResults.results = data;
					finalSubmit_params(combinedResults, false);
					plus1_failedSend_counter(FAILED_SEND_END_OF_STUDY_COUNTER_TAG);
				}
				else {
					plus1_failedSend_counter(FAILED_SEND_COUNTER_TAG);
							
					for (exclude in [EXPT_ID_TAG, UUID_TAG, FAILED_SEND_END_OF_STUDY_COUNTER_TAG, FAILED_SEND_COUNTER_TAG, SPECIAL_TAG, DURATION_TAG,CSRF_TAG]) {
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
			}
			
			

			if (special == Special_Trial.Final_Submit) {		
				if (callbacks != null) {
					if (failedSend_backup != null) {
						failedSend_backup.set(FAILED_SEND_END_OF_STUDY_COUNTER_TAG, Std.string(failedSend_counters.get(FAILED_SEND_END_OF_STUDY_COUNTER_TAG)));
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
	
	private function plus1_failedSend_counter(what:String) {
		var val:Int = failedSend_counters.get(what)+1;
		failedSend_counters.set(what, val);
		
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