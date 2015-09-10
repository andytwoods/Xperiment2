package xpt2.core.stimuli;

import xpt2.core.entities.Stimulas;
import xpt2.core.IClonable;

class Label extends Stimulas implements IClonable<Label> {
	public var text:String;
	
	public function new() {
		super();
		type = "label";
	}
	
	private override function self():Label {
		return new Label();
	}
	
	public override function clone():Label {
		var c:Label = cast super.clone();
		c.text = this.text;
		return c;
	}
}