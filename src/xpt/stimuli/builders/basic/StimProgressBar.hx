package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.controls.HProgress;
import haxe.ui.toolkit.controls.Progress;
import haxe.ui.toolkit.core.Component;
import xpt.experiment.Preloader.PreloaderEvent;
import xpt.stimuli.StimulusBuilder;

class StimProgressBar extends StimulusBuilder {
	private var _progress:Progress;
	
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		_progress = new HProgress();
		return _progress;
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var progress:Progress = cast c;
		progress.min = getInt("min", 0);
		progress.max = getInt("max", 100);
		progress.pos = getInt("value", 0);
		if (getBool("preloader", false) == true) {
			experiment.addEventListener(PreloaderEvent.PROGRESS, onPreloaderProgress);
			experiment.addEventListener(PreloaderEvent.COMPLETE, onPreloaderComplete);
		}
	}
	
	private function onPreloaderProgress(event:PreloaderEvent) {
		_progress.max = event.total;
		_progress.pos = event.current;
	}
	
	private function onPreloaderComplete(event:PreloaderEvent) {
		experiment.removeEventListener(PreloaderEvent.PROGRESS, onPreloaderProgress);
		experiment.removeEventListener(PreloaderEvent.COMPLETE, onPreloaderComplete);
	}
}