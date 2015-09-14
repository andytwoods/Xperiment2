package comms.services;
import comms.CommsResult;

/**
 * ...
 * @author 
 */
class BodgeTest_REST_Service
{

	public static function test() {
	
		var results:Map<String,String> = new Map<String,String>();
		results.set("bla", "bla");
		
		var rest:REST_Service = new REST_Service(results, function(info:CommsResult) {
			trace(111, info);
		});
		
		
	}
	
}