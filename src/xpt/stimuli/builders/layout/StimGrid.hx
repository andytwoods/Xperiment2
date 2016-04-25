package xpt.stimuli.builders.layout;

import haxe.ui.toolkit.containers.Grid;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;

class StimGrid extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Grid();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
	}	
}