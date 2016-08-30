package xpt.stimuli.builders.nonvisual;

import haxe.ui.toolkit.core.Component;
import xpt.events.ExperimentEvent;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.StimulusBuilder;

class StimRT extends StimulusBuilder_nonvisual {
   
	var startTime:Float;
	var endTime:Float = -1;
	
    public function new() {
        super();
    }
	
	private function trialEndL(e:ExperimentEvent):Void 
	{
		experiment.removeEventListener(ExperimentEvent.TRIAL_END, trialEndL);
		if (endTime == -1) endTime = getTimeStamp();
	}
    
	private override function applyProperties(c:Component) {
        c.visible = false;
       
	}
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() {
		startTime = getTimeStamp();
		experiment.addEventListener(ExperimentEvent.TRIAL_END, trialEndL);
		super.onAddedToTrial();
    }
	
	function getTimeStamp():Float {
	
		return Date.now().getTime();
	}
    
   
    
    public override function onRemovedFromTrial() {
		endTime = getTimeStamp();
       super.onRemovedFromTrial();
    }
	
	
	override public function results():Map<String,String> {
		var map:Map<String,String> = new Map<String,String>();
		map.set('', Std.string(endTime - startTime));
		return map;
	}
}