package xpt.stimuli;

/**
 * ...
 * @author 
 */
class Stimulus
{
	public var __properties:Map<String,Dynamic>;
	

	public function new() 
	{
		__properties = new Map<String, Dynamic>();
	}
	
	public function get(what:String):Dynamic {
		return __properties.get(what);
	}
	
	public function set(what:String, val:Dynamic) {
		__properties.set(what, val);
	}
	
	public function kill() {
		__properties = null;
	}
}