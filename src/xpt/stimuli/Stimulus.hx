package xpt.stimuli;
import openfl.display.Sprite;

/**
 * ...
 * @author 
 */
class Stimulus extends Sprite
{
	public var __properties:Map<String,Dynamic>;
	public var start:Float = -1;
	public var stop:Float = -1;
	public var duration:Float = -1;
	public var hideResults:Bool = false;
	public var id:String;
	public var depth:Int;
	public var ran:Bool = false;
	
	public var __underlings:Array<Stimulus> = [];

	public function new() 
	{
		super();
		__properties = new Map<String, Dynamic>();
	}
	
	public function addUnderling(stim:Stimulus) {
		__underlings.push(stim);
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
				start = Std.parseFloat(val);
			case 'stop':
				stop = Std.parseFloat(val);
			case 'duration':
				duration = Std.parseFloat(val);
			case 'hideresults':
				var str:String = Std.string(val).toLowerCase();
				if (str == 'true') hideResults = true;
			case 'id':
				id = Std.string(val);
			case 'depth':
				depth = Std.parseInt(val);
			default:
				__properties.set(what, val);
		}
	}
	
	public function results():Map<String,String> {
		if (hideResults == true) return null;
		return null;
	}
	
	public function kill() {
		__underlings = null;
		__properties = null;
	}
}

