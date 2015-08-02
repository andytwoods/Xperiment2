package xpt.script;
import xpt.script.ProcessBetweenSJs.BetweenSJParams;
import xpt.tools.XML_tools;

/**
 * ...
 * @author 
 */
class ProcessBetweenSJs
{
	static public var betweenSJ_nodeName = "multi";
	
	
	static public function DO(script:Xml) 
	{
		var betweenSJParams = BetweenSJParams.check(script);
		if (betweenSJParams != null) {
		
			//to do
			
		}
		
		
	}

	
}

class BetweenSJParams {

	public var forceCondition:String;
	
	public function new() { }
	
	static public function check(script:Xml):BetweenSJParams {
	
		
		var name:String = XML_tools.nodeName(script);
		if (name == ProcessBetweenSJs.betweenSJ_nodeName) {
			var instance = new BetweenSJParams();
			specify(instance, script);
			return instance;
		}
		
		return null;
	}
	
	static private function specify(instance:BetweenSJParams, script:Xml) 
	{
		
	}
	
	
	
}