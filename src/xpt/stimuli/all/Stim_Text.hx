package xpt.stimuli.all;

import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.Stimulus;

class Stim_Text extends HaxeUIStimulus {
	private var _text:Text;
	public function new() {
		super();
	}
	
	public override function applyProps(c:Component):Void {
		super.applyProps(c);
	}
	
	public override function buildComponent():Component {
		dispose(_text);
		_text = new Text();
		_text.verticalAlign = "center";
		applyProps(_text);
		return _text;
	}
}