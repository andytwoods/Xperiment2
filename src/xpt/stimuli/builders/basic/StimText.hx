package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;

class StimText extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Text();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var text:Text = cast c;
		text.wrapLines = true;
		if (get("textAlign") != null) {
			text.textAlign = get("textAlign");
		}
	}
}