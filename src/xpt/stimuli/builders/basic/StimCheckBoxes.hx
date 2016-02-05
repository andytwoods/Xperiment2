package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.CheckBox;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import xpt.stimuli.StimulusBuilder;
import xpt.ui.custom.NumberStepper;

class StimCheckBoxes extends StimulusBuilder {
	private var _checkBoxes:Array<CheckBox>;

    private var _currentSelection:Array<String>;
    
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
		_checkBoxes = new Array<CheckBox>();
		
		var checkBoxWidth:Float = -1;
		var checkBoxPercentWidth:Float = -1;
		if (get("checkBoxWidth") != null) {
			var bw:String = get("checkBoxWidth");
			if (bw.indexOf("%") != -1) {
				checkBoxPercentWidth = Std.parseFloat(StringTools.replace(bw, "%", ""));
			} else {
				checkBoxWidth = Std.parseFloat(bw);
			}
		}

		var checkBoxHeight:Float = -1;
		var checkBoxPercentHeight:Float = -1;
		if (get("checkBoxHeight") != null) {
			var bh:String = get("checkBoxHeight");
			if (bh.indexOf("%") != -1) {
				checkBoxPercentHeight = Std.parseFloat(StringTools.replace(bh, "%", ""));
			} else {
				checkBoxHeight = Std.parseFloat(bh);
			}
		}
		
		var group:String = "" + Math.random();
		if (get("labels") != null) {
			var labels:String = get("labels");
			var labelsArr:Array<String> = labels.split(",");
			if (getBool('random', false)) Random.shuffle(labelsArr);
			for (label in labelsArr) {
				var checkBox:CheckBox = new CheckBox();
				checkBox.text = label;
				
				if (checkBoxWidth != -1) {
					checkBox.width = checkBoxWidth;
					checkBox.autoSize = false;
				}
				if (checkBoxPercentWidth != -1) {
					checkBox.percentWidth = checkBoxPercentWidth;
				}
                
				if (checkBoxHeight != -1) {
					checkBox.height = checkBoxHeight;
					checkBox.autoSize = false;
				}
				if (checkBoxPercentHeight != -1) {
					checkBox.percentHeight = checkBoxPercentHeight;
				}
                
				if (fontSize != -1) {
					checkBox.style.fontSize = fontSize;
				}
                checkBox.addEventListener(UIEvent.CHANGE, oncheckBoxChange);
				_checkBoxes.push(checkBox);

				hbox.addChild(checkBox);
			}
		}
		
		
	}
    
    private function oncheckBoxChange(event:UIEvent) {
        onStimValueChanged(_currentSelection);
		runScriptEvent("action", event);
    }
}