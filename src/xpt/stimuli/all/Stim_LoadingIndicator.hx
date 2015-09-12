package xpt.stimuli.all;

import haxe.ui.toolkit.controls.HProgress;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.Stimulus;

class Stim_LoadingIndicator extends HaxeUIStimulus {
	private var _progress:HProgress;
	
	public function new() {
		super();
	}
	
	public override function buildComponent():Component {
		dispose(_progress);
		_progress = new HProgress();
		applyProps(_progress);
		_progress.pos = 50; //  just for visual look
		_component = _progress;
		return _progress;
	}
}