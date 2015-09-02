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
	
	public function add(results:Xml, special:Special_Trial) 
	{
		if (results == null) return;
		
		if(trickeToCloud)	__send_to_cloud(results, special);
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
	
	public function __send_to_cloud(results:Xml, special:Special_Trial) 
	{
		switch(special) {
			case Special_Trial.First_Trial:
				__addResultsInfo(results, courseInfo);
				__addResultsInfo(results, turkInfo);
			case Special_Trial.Last_Trial:
				//
			default:
				//
		}
	}
	
	public static function __addResultsInfo(results:Xml, courseInfo:Map<String, String>) 
	{
		var xml:Xml;
		for (key in courseInfo.keys()) {
			xml = Xml.createElement(key);
			xml.addChild(Xml.createPCData(courseInfo.get(key)));
			results.firstChild().addChild(xml);
		}
	}
	

	
}