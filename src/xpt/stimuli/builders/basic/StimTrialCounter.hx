package xpt.stimuli.builders.basic;

import code.Scripting;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.text.ITextDisplay;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import xpt.events.ExperimentEvent;
import xpt.stimuli.StimulusBuilder;

class StimTrialCounter extends StimulusBuilder {
	
	private static var counters:Map<String,Int>;
	private var once:Bool = false;
	
    public function new() {
        super();
    }
	
	private override function createComponentInstance():Component {
		return new Text();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		if (counters == null) counters = new Map<String,Int>();
		
		if (counters.exists(stimId) == false) {
			counters.set(stimId, 0);
		}
		else {
			if (once == false) {
				counters.set(stimId, counters.get(stimId) + 1);
				once = true;
			}
		}
		
		var totalStr:String;
		var totalInt:Int = getInt("total",-1);
		if (totalInt != -1) totalStr = " / " + Std.string(totalInt);
		else totalStr = "";
		
		
		var text:Text = cast c;
		text.text = text.text + " " + counters.get(stimId) + totalStr;
		
		
		if (get("textAlign") != null) {
			text.textAlign = get("textAlign");
		}
		
	}
    
}

