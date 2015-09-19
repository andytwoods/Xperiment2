package comms.services;
import haxe.ds.StringMap;

/**
 * ...
 * @author 
 */
class REST_Service_SaveResults extends REST_Service
{

	public function new(info:StringMap<String>, data:StringMap<String>, callBackF:CommsResult -> String -> Void) 
	{
		trace(info);
		trace(data);
		
		var combined:StringMap<String> = ['info' => __parse(info), 'data' => __parse(data)];
		
		super(combined, callBackF);
	}
	
	public function __parse(map:StringMap<String>):String {
		
		return map.toString();
	}
	
}