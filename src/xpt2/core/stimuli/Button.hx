package xpt2.core.stimuli;

import xpt2.core.entities.Stimulas;
import xpt2.core.IClonable;

class Button extends Stimulas implements IClonable<Button> {
	public var action:String;
	public var text:String;
	
	public function new() {
		super();
		type = "button";
	}
	
	private override function self():Button {
		return new Button();
	}
	
	public override function clone():Button {
		var c:Button = cast super.clone();
		c.action = this.action;
		c.text = this.text;
		return c;
	}
}