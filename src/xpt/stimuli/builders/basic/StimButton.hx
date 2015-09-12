package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;

class StimButton extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		trace("creaeting buttin");
		return new Button();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
	}
}