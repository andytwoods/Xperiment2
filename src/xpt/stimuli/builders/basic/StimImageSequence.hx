package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;
import xpt.ui.custom.ImageSequence;

class StimImageSequence extends StimulusBuilder {
	public function new() {
		super();
	}

	private override function createComponentInstance():Component {
		return new ImageSequence();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var s:ImageSequence = cast c;
		
		s.resourcePattern = get("resourcePattern");
		s.min = 1;// getInt("start", 1);
		s.max = getInt("count", 1);
		s.val = 1;// getInt("start", 1);
	}
}