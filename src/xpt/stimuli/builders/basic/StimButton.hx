package xpt.stimuli.builders.basic;

import diagnositics.DiagnosticsManager;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import openfl.events.MouseEvent;
import xpt.stimuli.builders.basic.StimButton;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.KeyPress;
import xpt.tools.XTools;

class StimButton extends StimulusBuilder {
	public var clicked:Int = 0;
	public var b:Button;
	
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Button();
	}
	
	override public function set_text(txt:String) {
		b.text = txt;
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		b = cast c;
		if (get("action") != null || getBool("reactionTime") == true) listenClick();
		if (get("icon") != null) {
			b.icon = get("icon");
		}
		if (get("iconPosition") != null) {
			b.iconPosition = get("iconPosition");
		}
		
		b.disabled = getBool("disabled", false);
		
	}
	
	private function listenClick() {
        b.removeEventListener(MouseEvent.CLICK, onClick);
		b.addEventListener(MouseEvent.CLICK, onClick);
	}
	
	override public function onAddedToTrial() {
		super.onAddedToTrial();
		if (get("key") != null) {
			KeyPress.instance.listen(this, get("key"), function(char:Int) { 
				
				if (getBool('keyEnabled',false)) return;

					var disabled:Bool = b.disabled;
					if (disabled == true) {
						if (getBool('ignoreButtonDisabled', false) == false) return;
					}
					b.disabled = false;
					simButtonDown(b);
					b.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					b.disabled = disabled;
				}
			);
				
		}
    }
	
	function simButtonDown(button:Button) 
	{
		button.state = Button.STATE_DOWN;
		XTools.delay(100, function() { 
			if (button !=null ) button.state = Button.STATE_NORMAL;
		} );
	}
    
    override public function onRemovedFromTrial() {
		super.onRemovedFromTrial();
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