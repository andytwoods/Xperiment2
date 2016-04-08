package xpt.screenManager;

/**
 * ...
 * @author Andy Woods
 */
@:allow(xpt.screenManager.Test_DeviceManager)
class DeviceManager
{
	//https://github.com/matthewhudson/device.js?
	
	public static var error:String;
	
	
	//ios , iphone , ipod , ipad , android , androidPhone , androidTablet , blackberry , blackberryPhone , blackberryTablet , windows , windowsPhone , windowsTablet , fxos , fxosPhone , fxosTablet , meego , cordova , nodeWebkit , mobile , tablet , desktop , television , portrait , landscape , noConflict
	
	public static function check(devicesStr :String):Bool {
		var checks:Array<Check> = generateChecks(devicesStr);
		
		var complain:Bool = false;
		var success:Bool = false;
		for (check in checks) {
			#if html5
			trace(untyped device[check.device](), check.sign , check.sign);
			if (untyped device.hasOwnProperty(check.device) == false) {
				 trace('complain', check.device);
			}
			else if(untyped device[check.device]() == check.sign && check.sign == false) {
					error = generateError(check, checks);
					return false; 
			}
			else {
				success = true; 
			}	
			#end
		}
		return success;
	}
	
	static private function generateError(prob_check:Check,checks:Array<Check>):String
	{
		var good:Array<String> = new Array<String>();
		var bad:Array<String> = new Array<String>();
		for (check in checks) {
			if (check.sign == true) {
				good.push(check.device);
			}
			else {
				bad.push(check.device);
			}
		}
		
		var str:String = "";
		if(good.length>0 )str += 'this experiment is designed to only run on these devices: ' + good.join(", ") +".";
		if(good.length>0 )str += 'this experiment is designed to only run on these devices: ' + good.join(", ") +".";
		if (bad.length > 0) {
			str += ' The experimenter did not want it to run on these devices:'+bad.join(", ") +".";
		}
		str += ' Your device seems to be a/an ' + prob_check.device + '.'; 
		
		return str;
	}
	
	static private function generateChecks(devicesStr:String) 
	{
		devicesStr = devicesStr.split(" ").join("");
		var checks:Array<Check> = new Array<Check>();
		
		for (device in devicesStr.split(",")) {
			checks[checks.length] = new Check(device);
		}
		
		return checks;
	}
}

class Check {
	
	public var sign:Bool = true;
	public var device:String;

	
	public function new(d:String) {
		
		if (d.charAt(0) == "!"){
			sign = false;
			device = d.substr(1);
		}
		else {
			device = d;
		}
	}
}