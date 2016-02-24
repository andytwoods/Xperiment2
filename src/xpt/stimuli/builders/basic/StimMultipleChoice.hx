package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.XRandom;
import xpt.tools.XTools;
import xpt.ui.custom.NumberStepper;

class StimMultipleChoice extends StimulusBuilder {
	private var _buttons:Array<Button>;

    private var _currentSelection:String;
    
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new HBox();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
        
        c.removeAllChildren();
        
		var hbox:HBox = cast c;
		
		var fontSize:Int = getInt("fontSize");
		_buttons = new Array<Button>();
		
		var buttonWidth:Float = -1;
		var buttonPercentWidth:Float = -1;
		if (get("buttonWidth") != null) {
			var bw:String = get("buttonWidth");
			if (bw.indexOf("%") != -1) {
				buttonPercentWidth = Std.parseFloat(StringTools.replace(bw, "%", ""));
			} else {
				buttonWidth = Std.parseFloat(bw);
			}
		}

		var buttonHeight:Float = -1;
		var buttonPercentHeight:Float = -1;
		if (get("buttonHeight") != null) {
			var bh:String = get("buttonHeight");
			if (bh.indexOf("%") != -1) {
				buttonPercentHeight = Std.parseFloat(StringTools.replace(bh, "%", ""));
			} else {
				buttonHeight = Std.parseFloat(bh);
			}
		}
		
		var iconPosition:String = get("iconPosition");
		var group:String = "" + XRandom.string(10);
		if (get("labels") != null) {
			var labels:String = get("labels");
			var labelsArr:Array<String> = labels.split(",");
			if (getBool('random', false)) XRandom.shuffle(labelsArr);
			for (label in labelsArr) {
				var button:Button = new Button();
				button.text = label;
				button.toggle = true;
				button.group = group + "_group";
				if (buttonWidth != -1) {
					button.width = buttonWidth;
					button.autoSize = false;
				}
				if (buttonPercentWidth != -1) {
					button.percentWidth = buttonPercentWidth;
				}
                
				if (buttonHeight != -1) {
					button.height = buttonHeight;
					button.autoSize = false;
				}
				if (buttonPercentHeight != -1) {
					button.percentHeight = buttonPercentHeight;
				}
				if (iconPosition != null) {
					button.iconPosition = iconPosition;
				}
                
				if (fontSize != -1) {
					button.style.fontSize = fontSize;
				}
                button.addEventListener(UIEvent.CHANGE, onButtonChange);
				_buttons.push(button);
				hbox.addChild(button);
			}
		}
		
		if (get("icons") != null) {
			var icon:Array<String> = cast(get("icons"), String).split(",");
			for (n in 0..._buttons.length) {
				_buttons[n].icon = icon[n];
			}
		}
	}
    
    private function onButtonChange(event:UIEvent) {
        var selection:String = event.component.text;
        if (cast(event.component, Button).selected == true && selection != _currentSelection) {
            _currentSelection = selection;
            onStimValueChanged(_currentSelection);
			runScriptEvent("action", event);
        }
		
    }
}