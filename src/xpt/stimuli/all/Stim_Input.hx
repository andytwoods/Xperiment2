package xpt.stimuli.all;

import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.core.Component;

class Stim_Input extends HaxeUIStimulus {
	private var _textfield:TextInput;
	
	public function new() {
		super();
	}
	
	public override function applyProps(c:Component):Void {
		super.applyProps(c);
		_textfield.text = "";
		_textfield.placeholderText = get("text");
	}
	
	public override function buildComponent():Component {
		dispose(_textfield);
		_textfield = new TextInput();
		applyProps(_textfield);
		_component = _textfield;
		return _textfield;
	}
}