package xpt.stimuli.all;

import haxe.ui.toolkit.core.Component;
import xpt.stimuli.all.custom.MyCustomComponent;

class Stim_MyCustom extends HaxeUIStimulus {
	private var _custom:MyCustomComponent;
	
	public function new() {
		super();
	}
	
	public override function applyProps(c:Component):Void {
		super.applyProps(c);
		if (get("resultString") != null) {
			_custom.resultString = "" + get("resultString");
		}
	}
	
	public override function buildComponent():Component {
		dispose(_custom);
		_custom = new MyCustomComponent();
		applyProps(_custom);
		_component = _custom;
		return _custom;
	}
}