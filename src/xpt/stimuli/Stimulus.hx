package xpt.stimuli;

/**
 * ...
 * @author 
 */
class Stimulus
{
	public var __properties:Map<String,Dynamic>;
	public var start:Int = -1;
	public var stop:Int = -1;
	public var duration:Int = -1;
	public var hideResults:Bool = false;

	public function new() 
	{
		__properties = new Map<String, Dynamic>();
	}
	
	public function tidy_beforeRun() {
	
		if (duration != -1) {
			stop = start += duration;
		}
	}
	
	public function get(what:String):Dynamic {
		switch(what) {
			case 'start': return start;
			case 'stop': return stop;		
			case 'duration': return duration;
		}

		return __properties.get(what);
	}
	
	public function set(what:String, val:Dynamic) {
		switch(what.toLowerCase()) {
			case 'start':
				start = Std.parseInt(val);
			case 'stop':
				stop = Std.parseInt(val);
			case 'duration':
				duration = Std.parseInt(val);
			case 'hideresults':
				var str:String = Std.string(val).toLowerCase();
				if (str == 'true') hideResults = true;
			default:
				__properties.set(what, val);
		}
	}
	
	public function results():Map<String,String> {
		if (hideResults == true) return null;
		return null;
	}
	
	public function kill() {
		__properties = null;
	}
}

