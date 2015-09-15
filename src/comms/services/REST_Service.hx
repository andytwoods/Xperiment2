package comms.services;
import com.imagination.delay.Delay;
import comms.CommsResult;
import restclient.RestClient;


/**
 * ...
 * @author 
 */
class REST_Service
{

	public static var __url:String;
	public static var __wait:Int;
	
	public var success:CommsResult; 
	
	public var delay:Delay;
	
	private var __callBack:CommsResult -> Void;
	
	
	public static function setup(url:String, wait:Int) {
		__url = url;
		__wait = wait;
	}
	
	
	public function new(data:Map<String,String>, callBackF:CommsResult -> Void) 
	{
		__callBack = callBackF;
		
		Delay.byTime(__wait, delayCallBack);
		
		RestClient.getAsync(
				__url,
				fromCloud_f,
				data,
				err_f
			);
	}
	
	private function delayCallBack() {
		err_f("");
		
	}
	
	private function do_callBack(result:CommsResult) {
		success = result;
		__callBack(success);
	}
	
	private function fromCloud_f(message:String) {	
		trace(message);
		do_callBack(Success);
		
	}
	
	private function err_f(message:String) {
		Delay.killDelay(delayCallBack);
		do_callBack(Fail);
	}
	
}