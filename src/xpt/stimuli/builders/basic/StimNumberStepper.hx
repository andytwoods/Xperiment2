package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;
import xpt.ui.custom.NumberStepper;

class StimNumberStepper extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new NumberStepper();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
	}
}