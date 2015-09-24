package comms.services;
import com.imagination.delay.Delay;
import comms.CommsResult;
import restclient.RestClient;


class REST_Service
{

	public static var __url:String;
	public static var __wait:Int;
	
	public var success:CommsResult; 
	
	public var delay:Delay;
	
	private var __callBack:CommsResult -> String -> Void;
	
	
	public static function setup(url:String, wait:Int) {
		__url = url;
		__wait = wait;
	}
	
	
	public function new(data:Map<String,String>, callBackF:CommsResult -> String -> Void) 
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
	
	private function do_callBack(result:CommsResult, message:String) {
		Delay.killDelay(delayCallBack);
		success = result;
		__callBack(success, message);
	}
	
	private function fromCloud_f(message:String) {	
		var commsResult:CommsResult;
		if (message.indexOf("success") != -1) commsResult = Success;
		else commsResult = Fail;
		do_callBack(commsResult, message);
		
	}
	
	private function err_f(message:String) {
		do_callBack(Fail,"");
	}
	
}