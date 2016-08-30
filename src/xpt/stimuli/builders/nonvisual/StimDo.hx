package xpt.stimuli.builders.nonvisual;

import flash.events.Event;
import haxe.ui.toolkit.core.Component;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import xpt.debug.DebugManager;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.StimulusBuilder;

class StimDo extends StimulusBuilder_nonvisual {
    private var _interval:Int;
    private var _timer:Timer;
    
    public function new() {
        super();
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;        
	}
    
    public override function onAddedToTrial() {
		var e:Event = new Event(Event.ADDED);
		runScriptEvent("action", e);
    }

}