package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import openfl.events.MouseEvent;
import xpt.stimuli.StimulusBuilder;

class StimButton extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Button();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var b:Button = cast c;
		if (get("action") != null) {
			b.addEventListener(MouseEvent.CLICK, onClick);
		}
		if (get("icon") != null) {
			b.icon = get("icon");
		}
		if (get("iconPosition") != null) {
			b.iconPosition = get("iconPosition");
		}
	}
	
	private function onClick(event:MouseEvent) {
		runScriptEvent("action", event);
	}
}