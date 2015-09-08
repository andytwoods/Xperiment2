package xpt.results;


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
	
	
	public function addMultipleResults(stimRes:Map<String, String>) 
	{
		if(stimRes != null)	__combinedMaps(results, stimRes);
	}
	
	public function addResult(what:String, val:String) {
		__addResult(results, what, val);
	}
	
	
	static public inline function __combinedMaps(trialResults:Map<String, String>, stimResults:Map<String, String>) 
	{
		if (stimResults == null) return;
		
		var val:String;
		for (prop in stimResults.keys()) {
			val = stimResults.get(prop);
			__addResult(trialResults, prop, val);
		}
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
	

	
}