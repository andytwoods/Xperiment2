package xpt2.core.stimuli;

import xpt2.core.entities.Stimulas;
import xpt2.core.IClonable;

class Image extends Stimulas implements IClonable<Image> {
	public var resource:String;
	
	public function new() {
		super();
		type = "image";
	}
	
	private override function self():Image {
		return new Image();
	}
	
	public override function clone():Image {
		var c:Image = cast super.clone();
		c.resource = this.resource;
		return c;
	}
}