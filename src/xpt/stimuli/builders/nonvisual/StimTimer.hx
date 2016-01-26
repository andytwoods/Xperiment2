package xpt.stimuli.builders.nonvisual;

import haxe.ui.toolkit.core.Component;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import xpt.debug.DebugManager;
import xpt.stimuli.StimulusBuilder;

class StimTimer extends StimulusBuilder {
    private var _interval:Int;
    private var _timer:Timer;
    
    public function new() {
        super();
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;
        _interval = getInt("interval", -1);
        
	}
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrail() {
        if (_interval <= 0) { // one off fire
            _timer = new Timer(0, 1);
        } else {
            _timer = new Timer(_interval, 1);
        }
        _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
        _timer.start();
    }
    
    private function onTimer(event:TimerEvent) {
        runScriptEvent("action", event);
        if (_interval > 0) {
            _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
            _timer.stop();
            _timer = null;
            
            _timer = new Timer(_interval, 1);
            _timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
            _timer.start();
        }
    }
    
    public override function onRemovedFromTrail() {
        if (_timer  != null) {
            _timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
            _timer.stop();
            _timer = null;
        }
    }
}