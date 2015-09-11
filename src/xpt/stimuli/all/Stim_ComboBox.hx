package xpt.stimuli.all;

import haxe.ui.toolkit.controls.selection.ListSelector;
import haxe.ui.toolkit.controls.selection.ListSelector.DropDownList;
import haxe.ui.toolkit.core.Component;

class Stim_ComboBox extends HaxeUIStimulus {
	private var _dropDownList:ListSelector;
	
	public function new() {
		super();
	}
	
	public override function applyProps(c:Component):Void {
		super.applyProps(c);
		_dropDownList.text = get("label");
	}
	
	public override function buildComponent():Component {
		dispose(_dropDownList);
		_dropDownList = new ListSelector();
		applyProps(_dropDownList);
		return _dropDownList;
	}
}