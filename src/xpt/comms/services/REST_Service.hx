package xpt.comms.services;
import xpt.comms.CommsResult;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import restclient.RestClient;


class REST_Service extends AbstractService
{

	public static inline var CLOUD_SUCCESS_MESSAGE:String = '';
	
	public function new(_data:Map<String,String>, callBackF:CommsResult -> String -> Map<String,String> -> Void, type:String, url:String) 
	{
		super(_data, callBackF);
		switch(type.toUpperCase()) {
			case 'GET':
				RestClient.getAsync(
						url,
						fromCloud_f,
						_data,
						err_f
					);
			case 'POST':
				if (url.charAt(url.length - 1) != '/') url += '/';
				RestClient.postAsync(
						url,
						fromCloud_f,
						_data,
						err_f
					);
			default: throw 'unknown request';
		}
	}
	
	override public function check_cloudMessageSuccess(message:String) 
	{
		return message == CLOUD_SUCCESS_MESSAGE;
	}
}