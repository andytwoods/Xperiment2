package xpt.results;
import xpt.stimuli.Stimulus;
import xpt.trial.Trial;


/**
 * ...
 * @author 
 */
class TrialResults
{
	public var results:Map<String, String> = new Map<String,String>();
	public var trialName:String;
	public var trialNum:Int;
	public var iteration:Int;
	public var trialBlock:Int;
	public var info:Map<String,String> = new Map<String,String>();
	
	public function new() 
	{
		
	}
	
	
	public function generateXml():Xml {
	
		var xml = Xml.parse("<trialData name='"+getName()+"'><trialOrder>"+trialNum+"</trialOrder></trialData>");
		return xml;
	}
	
	
	public inline function getName():String
	{
		return trialName + "|b" + trialBlock + "i" + iteration;
	}
	
	static public function _mapToXmlList(results:Map<String, String>):Array<Xml>
	{
		var list:Array<Xml> = [];
		
		for (key in results.keys()) {
			var xml:Xml = Xml.createElement(key);
			xml.addChild(Xml.createPCData(results.get(key)));
			list[list.length] = xml;
		}
		return list;
	}
	
	
	public function addMultipleResults(stimRes:Map<String, String>, prepend:String = '') 
	{
		if(stimRes != null)	__combinedMaps(results, stimRes, prepend);
	}
	
	public function addResult(what:String, val:String) {
		__addResult(results, what, val);
	}
	
	
	static public inline function __combinedMaps(trialResults:Map<String, String>, stimResults:Map<String, String>,prepend:String = '') 
	{
		if (stimResults == null) return;
		
		var val:String;
		for (prop in stimResults.keys()) {
			val = stimResults.get(prop);
			__addResult(trialResults, removeFullStops(prepend+prop), val);
		}
	}
	
	static private inline function removeFullStops(str:String):String 
	{
		return str.split(".").join("_");
	}
	
	static public inline function __addResult(trialResults:Map<String, String>, prop:String, val:String) 
	{
		if (trialResults.exists(prop) == true) prop = __safeProp(prop, trialResults); 
		trialResults.set(prop, val);	
	}
		
	static public inline function __safeProp(nam:String, results:Map<String, String>):String
	{
		var temp_nam:String = nam;
		var count:Int=1;
		
		while(results.exists(temp_nam)){
			temp_nam = nam + Std.string(count); 
			count++;
		}
		return temp_nam;
		
	}	
	
	static public function extract_trial_results(trial:Trial):TrialResults
	{

		if (trial.hideResults == true) return null;
		
		var trialResults:TrialResults = new TrialResults();
		
		extract_helper(trial, trialResults);

		if (trialResults.results.keys().hasNext() == false) return null;

		
		trialResults.trialNum = trial.trialNum;
		trialResults.trialBlock = trial.trialBlock;
		trialResults.iteration = trial.iteration;
			
		return trialResults;
	}
	
	static private inline function extract_helper(trial:Trial,trialResults:TrialResults):TrialResults {
		

		var stimRes:Map<String,String>;
		var stimulus:Stimulus;
		var prepend_trial_id:String = 'b' + Std.string(trial.trialBlock) + 'i' + Std.string(trial.trialNum)+"_";
		
		for (i in 0...trial.stimuli.length) {
			stimulus = trial.stimuli[i]; //ensures order
			if (stimulus.hideResults == false) {
				stimRes = stimulus.results(prepend_trial_id);
				trialResults.addMultipleResults(stimRes);		
			}
		}
		return trialResults;
	}	
	

	
}