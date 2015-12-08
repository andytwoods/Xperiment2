package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;

class StimImage extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Image();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var image:Image = cast c;
		if (get("asset") != null) {
			trace(11, StimulusBuilder.stimuliFolder + get("asset"));
			image.resource = StimulusBuilder.stimuliFolder + get("asset");
		}
	}
}