package xpt.stimuli.builders.basic;

import diagnositics.DiagnosticsManager;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import openfl.events.MouseEvent;
import xpt.stimuli.builders.basic.StimButton;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.KeyPress;

class StimButton extends StimulusBuilder {
	public var clicked:Int = 0;
	private var b:Button;
	
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Button();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		b = cast c;
		if (get("action") != null || getBool("reactionTime") == true) {
            b.removeEventListener(MouseEvent.CLICK, onClick);
			b.addEventListener(MouseEvent.CLICK, onClick);
		}
		if (get("icon") != null) {
			b.icon = get("icon");
		}
		if (get("iconPosition") != null) {
			b.iconPosition = get("iconPosition");
		}
		
		
	}
	
	override public function onAddedToTrial() {
		super.onAddedToTrial();
		if (get("key") != null) {
			KeyPress.instance.listen(this, get("key"), function(char:Int) { 
				b.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			} );
		}
    }
    
    override public function onRemovedFromTrial() {
		super.onAddedToTrial();
		if (get("key") != null) {
			KeyPress.instance.forget(this);
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