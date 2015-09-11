package xpt.stimuli.all;

import haxe.ui.toolkit.controls.Button;
import xpt.stimuli.Stimulus;
import haxe.ui.toolkit.core.Component;

class Stim_Button extends HaxeUIStimulus {
	private var _button:Button;
		
	public function new() {
		super();
	}

	public override function buildComponent():Component {
		dispose(_button);
		_button = new Button();
		applyProps(_button);
		return _button;
	}
}