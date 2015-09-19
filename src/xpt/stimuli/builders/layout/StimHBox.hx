package xpt.stimuli.builders.layout;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;

class StimHBox extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new HBox();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
	}	
}