package xpt.comms.services;
import thx.Maps;
import xpt.results.TrialResults;

/**
 * ...
 * @author Andy Woods
 */
class PackageRESTservices_Tool
{
	public static inline var packageChars:Int = 1000;
	public static inline var extraChars:Int = 2; // &=
	
	var restServices:Array<REST_Service> = new Array<REST_Service>();
	var grandCallBack:CommsResult -> String -> Map<String,String> -> Void;
	var backupData:Map < String, String>;
	var messages:Array<String>;
	var total:Int;
	

	public function new(results:Map<String,String>, callBackF:CommsResult -> String -> Map<String,String> -> Void, identifiers:Map<String, String>) 
	{
		this.grandCallBack = callBackF;
		if (results == null) return; //for testing
	
		var list:Array<Map<String,String>> = partition_results(results, identifiers, packageChars, extraChars);
trace(list.length, 3434343);
		for (freshResults in list) {
			restServices.push(	new REST_Service(freshResults, eventL)  );
		}
		
		total = restServices.length;
		

	}
	
	
	static inline function partition_results(results:Map<String,String>,identifiers:Map<String, String>, maxLen:Int, extraLen:Int):Array<Map<String,String>> 
	{
		
		var list:Array<Map<String,String>> = new Array<Map<String,String>>();
		
		var empty:Bool;
		var freshResults:Map<String,String>;
		
		var loopMax:Int = 50;
		
		do { 
			loopMax--;
			if (loopMax <= 0) throw 'Devel err: potentially trying to partition something >1000 characters in length.';
			freshResults = genResults(identifiers);
			empty = fill(results, freshResults, maxLen, extraLen);
			list.push(freshResults);
		}while (empty == false);
		
		return list;
	}
		
	
	static function fill(map:Map<String,String>, fresh:Map<String,String>, maxLen:Int, extraLen:Int):Bool
	{
		var charCount:Int = 0;
		
		var val:String;

		for (key in map.keys()) {
			val = map.get(key);
			charCount += val.length + key.length + extraLen;
			if (charCount > maxLen) {
				return false;
			}
			fresh.set(key, val);
			map.remove(key);
			
		}
		return true; //only returns when orig map is empty
	}
	
	function eventL(success:CommsResult, message:String, data:Map<String,String>) {
			total --;

			if (success != CommsResult.Success) {
				
				if (backupData == null) {
					backupData = genResults(null);
					messages = new Array<String>();
				}
				
				for (key in data.keys()) {
					backupData.set(key, data.get(key));
				}
				messages.push(message);

			}
			
			if (total == 0) {
				if(grandCallBack !=null){
					if (backupData == null) {
						grandCallBack(CommsResult.Success, '', null);	
					}
					else {
						grandCallBack(CommsResult.Fail, messages.join(','), backupData);
					}
				
			}
		}
	}
	

	private static function genResults(identifiers:Map<String,String>) {
		var m:Map<String,String> = new Map<String,String>();
		if(identifiers != null){
			for (key in identifiers.keys()) {
				m.set(key, identifiers.get(key));
			}
		}
		return m;
	}
	
	
}