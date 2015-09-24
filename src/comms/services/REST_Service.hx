package comms.services;
import com.imagination.delay.Delay;
import comms.CommsResult;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import restclient.RestClient;


class REST_Service
{

	public static var __url:String;
	public static var __wait:Int;
	
	public var success:CommsResult; 
	
	public var delay:Timer;
	
	private var __callBack:CommsResult -> String -> Void;
	
	
	public static function setup(url:String, wait:Int) {
		__url = url;
		__wait = wait;
	}
	
	
	public function new(data:Map<String,String>, callBackF:CommsResult -> String -> Void) 
	{
		__callBack = callBackF;
		
		delay = new Timer(__wait);
		delay.addEventListener(TimerEvent.TIMER, timerL);
		
		RestClient.getAsync(
				__url,
				fromCloud_f,
				data,
				err_f
			);
	}
	
	private function timerL(e:TimerEvent) {
		err_f("");
	}
	
	
	private function do_callBack(result:CommsResult, message:String) {
		delay.removeEventListener(TimerEvent.TIMER, timerL);
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