package xpt.trial;
import xpt.stimuli.Stimulus;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class ExtractResults
{
	
	static public function DO(trial:Trial):Xml
	{
		if (trial.hideResults == true) return null;
		
		var stimResults:Array<Xml> = extract(trial);
		if (stimResults.length == 0) return null;
		
		var trialName:String = _getName(trial);
		
		var results = Xml.parse("<trialData name='"+trialName+"'><trialOrder>"+trial.trialNum+"</trialOrder></trialData>");
				
		_addChildren(results, stimResults);
			
		return results;
	}
	
	static public function _addChildren(results:Xml, stimResults:Array<Xml>) 
	{
		for (xml in stimResults) {
			results.firstChild().addChild(xml);
		}
	}
	
	static public inline function _getName(trial:Trial) 
	{
		var trialName:String = trial.trialName;
		if (trialName == "") trialName = "t";
		trialName += "|b" + trial.trialBlock + "i" + trial.iteration;
		return trialName;
	}
	
	static public inline function extract(trial:Trial):Array<Xml> {
		
		var results:Map<String,String> = new Map<String,String>();
		var stimRes:Map<String,String>;
		var stimulus:Stimulus;
		
		for (i in 0...trial.stimuli.length) {
			stimulus = trial.stimuli[i]; //ensures order
			stimRes = stimulus.results();
			if(stimRes != null)	_combinedMaps(results, stimRes);			
		}
		return _mapToXmlList(results);
	}
	
	static public inline function _mapToXmlList(results:Map<String, String>):Array<Xml>
	{
		var list:Array<Xml> = [];
		
		for (key in results.keys()) {
			var xml:Xml = Xml.createElement(key);
			xml.addChild(Xml.createPCData(results.get(key)));
			list[list.length] = xml;
		}
		return list;
	}
	
	
	
	static public inline function _combinedMaps(trialResults:Map<String, String>, stimResults:Map<String, String>) 
	{
		if (stimResults == null) return;
		
		var val:String;
		for (prop in stimResults.keys()) {
			val = stimResults.get(prop);
			
			if (trialResults.exists(prop) == true) prop = _safeProp(prop, trialResults); 
			trialResults.set(prop, val);	
		}
	}
		
	static public inline function _safeProp(nam:String, results:Map<String, String>):String
	{
		var temp_nam:String = nam;
		var count:Int=1;
		
		while(results.exists(temp_nam)){
			temp_nam = nam + Std.string(count); 
			count++;
		}
		return temp_nam;
		
	}	
}