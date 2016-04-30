package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.CheckBox;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import openfl.events.MouseEvent;
import thx.Arrays;
import thx.Strings;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.XRandom;
import xpt.ui.custom.NumberStepper;

class StimCheckBoxes extends StimulusBuilder {
	private var _checkBoxes:Array<CheckBox>;
    private var _currentSelection:Array<String>;
	private var selectMany:Bool;
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		var h:HBox = new HBox();
		return h;
	}
	
	
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		c.removeAllChildren();
		selectMany = getBool('selectMany', true);
		create(cast(c, HBox));
	}
	
	function create(hbox:HBox) 
	{
		var fontSize:Int = getInt("fontSize");
		var checkBox:CheckBox = null;
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
		
		var group:String = "" + XRandom.string(10);
		if (get("labels") != null) {
			var labels:String = get("labels");
			var labelsArr:Array<String> = labels.split(",");
			if (getBool('random', false)) XRandom.shuffle(labelsArr);
			for (label in labelsArr) {
				checkBox = new CheckBox();
				checkBox.text = label;
				
                checkBox.sprite.addEventListener(MouseEvent.CLICK, oncheckBoxChange);
				_checkBoxes.push(checkBox);
				hbox.addChild(checkBox);
			}
		}
		
		hbox.x -= hbox.width * .5;
		hbox.y -= hbox.height * .5;
	
	}
	
	override public function results():Map<String,String> {
		var map:Map<String,String> = new Map<String,String>();
		var score:String;
		for (checkBox in _checkBoxes) {
			if (checkBox.selected == true) score = '1';
			else score = '0';
			map.set(checkBox.text, score);
		}
		return map;
	}
	

    
    private function oncheckBoxChange(e:MouseEvent) {
		trace(1);
		_currentSelection = [];
		if(selectMany == true){
			for (checkBox in _checkBoxes) {
				if (checkBox.selected == true) {
					_currentSelection.push(checkBox.text);
				}
			}
		}
		else {
			for (checkBox in _checkBoxes) {
				if (e.target == checkBox.sprite) {
					_currentSelection.push(checkBox.text);
					checkBox.selected = true;
				}
				else {
					checkBox.selected = false;
				}
			}

		}
        onStimValueChanged(_currentSelection);
		runScriptEvent("action", e);
    }
}