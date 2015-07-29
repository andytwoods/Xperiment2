package xpt.stimuli;

/**
 * ...
 * @author 
 */
class Stimulus
{
	var properties:Map<String,Dynamic>;
	

	public function new() 
	{
		properties = new Map<String, Dynamic>();
	}
	
	public function get(what:String):Dynamic {
		return properties.get(what);
	}
	
	public function set(what:String, val:Dynamic) {
		properties.set(what, val);
	}
	
}