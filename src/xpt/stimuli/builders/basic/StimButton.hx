package xpt.stimuli.builders.basic;

import diagnositics.DiagnosticsManager;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import openfl.events.MouseEvent;
import xpt.stimuli.StimulusBuilder;

class StimButton extends StimulusBuilder {
	
	public var clicked:Int = 0;
	
	
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Button();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var b:Button = cast c;
		if (get("action") != null || getBool("reactionTime") == true) {
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
        addMouseDiagnostics(event);
		clicked++;
		runScriptEvent("action", event);
	}
	
	override public function results():Map<String,String> {
		var val:String;
		if (clicked> 0) val = '1';
		else val = '0';
		return ['' => val];
	}
}