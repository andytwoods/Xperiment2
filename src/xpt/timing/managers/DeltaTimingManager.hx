package xpt.timing.managers;

import haxe.ui.toolkit.core.RootManager;
import openfl.events.Event;
import xpt.timing.TimingManager.TimingEvent;
import tween.Delta;
import tween.utils.Stopwatch;

class DeltaTimingManager extends BaseTimingManager {
	public function new() {
		super();
		RootManager.instance.currentRoot.sprite.addEventListener(Event.ENTER_FRAME, update);
	}
	
	private override function addTimingEvent(start:Float, duration:Float, callback:TimingEvent->Void) {
        if (duration > -1) {
            Delta.tween(RootManager.instance.currentRoot.sprite)
                .wait(start / 1000)
                .onComplete(function() {
                    callback(TimingEvent.SHOW);
                })
                .wait(duration / 1000)
                .onComplete(function() {
                    callback(TimingEvent.HIDE);
                });
        } else {
            Delta.tween(RootManager.instance.currentRoot.sprite)
                .wait(start / 1000)
                .onComplete(function() {
                    callback(TimingEvent.SHOW);
                });
        }
	}
	
	private function update(e:Event):Void  {
        Delta.step(Stopwatch.tock()); //Update the tween engine with a delta in seconds using the stopwatch util
        Stopwatch.tick(); //Store frame time for next tock
	}
}