package xpt.timing;

import diagnositics.DiagnosticsManager;
import flash.events.Event;
import haxe.ds.ArraySort;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.events.UIEvent;
import xpt.debug.DebugManager;
import xpt.stimuli.Stimulus;

enum TimingEvent {
	SHOW;
	HIDE;
}

class TimingManager {
	private static var _instance:TimingManager;
	public static var instance(get, never):TimingManager;
	private static function get_instance():TimingManager {
		if (_instance == null) {
			_instance = new TimingManagerFactory().create();
		}
		return _instance;
	}

	////////////////////////////////////////////////////////////////////////
	// INSTANCE
	////////////////////////////////////////////////////////////////////////
	private var _stims:Array<Stimulus>;
	
	private function addTimingEvent(start:Float, duration:Float, callback:TimingEvent->Void) {
		throw "TimingManager::addTimingEvent not implemented";
	}
	
	public function new() {
		_stims = new Array<Stimulus>();
	}

	public function start() {
		for (stim in _stims) {
			var start:Float = stim.start;
			var stop:Float = stim.stop;
			var duration:Float = stim.duration;
			
			if (stop != -1 || duration != -1) {
				if (start < 0) {
					start = 0;
				}
				if (stop != -1) {
					duration = stop - start;
				}
			}
			
            addTimingEvent(start, duration, function(e:TimingEvent) {
                switch (e) {
                    case TimingEvent.SHOW:
                        addToTrial(stim);
                    case TimingEvent.HIDE:
                        removeFromTrial(stim);
                }
            });
		}
	}
	
	public function reset() {
		for (stim in _stims) {
			removeFromTrial(stim);
		}
		_stims = new Array<Stimulus>();
	}
	
	public function add(stim:Stimulus) {
		_stims.push(stim);
		ArraySort.sort(_stims, function(a:Stimulus, b:Stimulus):Int {
			if (a.depth == b.depth) return 0;
			if (a.depth < b.depth) return 1;
			return -1;
			
		});
		if (stim.start <= 0) {
			addToTrial(stim);
		}
	}
	
	private function addToTrial(stim:Stimulus) {
		if (RootManager.instance.currentRoot.contains(stim.component) == false) {
			DebugManager.instance.stimulus("Adding stimulus, type: " + stim.get("stimType"));
            DiagnosticsManager.add(DiagnosticsManager.STIMULUS_SHOW, stim.id, stim.get("stimType"));
            stim.component.addEventListener(UIEvent.ADDED_TO_STAGE, onStimAddedToStage);
		    
			RootManager.instance.currentRoot.addChild(stim.component);
			

			for (s in _stims) {
				if(s.depth < stim.depth){
					if (RootManager.instance.currentRoot.contains(s.component)) {
						s.component.parent.setChildIndex(s.component, s.component.parent.numChildren - 1);
					}
				}
			}
			
			
            stim.onAddedToTrial();
		}
	}
    
    private function onStimAddedToStage(event:UIEvent) {
        event.component.removeEventListener(UIEvent.ADDED_TO_STAGE, onStimAddedToStage);
        var stim:Stimulus = findStimFromComponent(event.component);
        if (stim != null) {
            stim.updateComponent();
        }
    }
	
    private function findStimFromComponent(c:Component):Stimulus {
        var stim:Stimulus = null;
        for (test in _stims) {
            if (test.component == c) {
                stim = test;
                break;
            }
        }
        return stim;
    }
    
	private function removeFromTrial(stim:Stimulus) {
		if (RootManager.instance.currentRoot.contains(stim.component) == true) {
			DebugManager.instance.stimulus("Removing stimulus, type: " + stim.get("stimType"));
            DiagnosticsManager.add(DiagnosticsManager.STIMULUS_HIDE, stim.id, stim.get("stimType"));
			RootManager.instance.currentRoot.removeChild(stim.component);
            stim.onRemovedFromTrial();
		}
	}
}