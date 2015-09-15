package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;
import xpt.ui.custom.LineScale;

class StimLineScale extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new LineScale();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var lineScale:LineScale = cast c;
		if (get("startLabel") != null) {
			lineScale.startLabel = get("startLabel");
		}
		if (get("endLabel") != null) {
			lineScale.endLabel = get("endLabel");
		}
	}

}