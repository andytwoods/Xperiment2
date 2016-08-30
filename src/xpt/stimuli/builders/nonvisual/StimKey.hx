package xpt.stimuli.builders.nonvisual;

import haxe.ui.toolkit.core.Component;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.ui.Keyboard;
import xpt.events.ExperimentEvent;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.KeyPress;

class StimKey extends StimulusBuilder_nonvisual {
   

    public function new() {
        super();
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;   
	}
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() {
		if (get("key") != null) {
			KeyPress.instance.listen(this, get("key"), function(char:Int) { 
				runScriptEvent("action", new KeyboardEvent(KeyboardEvent.KEY_DOWN));
			} );
		}
		super.onAddedToTrial();
	}
	
	

   
    
    public override function onRemovedFromTrial() {
       super.onRemovedFromTrial();
    }
	
	

}