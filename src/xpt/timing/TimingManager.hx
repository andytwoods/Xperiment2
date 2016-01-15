package xpt.timing;

import haxe.ui.toolkit.core.RootManager;
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
			
			if (duration != -1) {
				addTimingEvent(start, duration, function(e:TimingEvent) {
					switch (e) {
						case TimingEvent.SHOW:
							addToTrial(stim);
						case TimingEvent.HIDE:
							removeFromTrail(stim);
					}
				});
			}
		}
	}
	
	public function reset() {
		for (stim in _stims) {
			removeFromTrail(stim);
		}
		_stims = new Array<Stimulus>();
	}
	
	public function add(stim:Stimulus) {
		_stims.push(stim);
		if (stim.start <= 0) {
			addToTrial(stim);
		}
	}
	
	private function addToTrial(stim:Stimulus) {
		if (RootManager.instance.currentRoot.contains(stim.component) == false) {
			DebugManager.instance.stimulus("Adding stimulus, type: " + stim.get("stimType"));
			RootManager.instance.currentRoot.addChild(stim.component);
		}
	}
	
	private function removeFromTrail(stim:Stimulus) {
		if (RootManager.instance.currentRoot.contains(stim.component) == true) {
			DebugManager.instance.stimulus("Removing stimulus, type: " + stim.get("stimType"));
			RootManager.instance.currentRoot.removeChild(stim.component);
		}
	}
}