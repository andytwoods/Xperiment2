package xpt.stimuli.all;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.OptionBox;
import haxe.ui.toolkit.core.Component;

class Stim_MultipleChoice extends HaxeUIStimulus {
	
	private var _hbox:HBox;
	private var _options:Array<OptionBox>;
	
	public function new() {
		super();
	}

	public override function applyProps(c:Component):Void {
		super.applyProps(c);
		if (get("labels") != null) {
			var label:Array<String> = cast(get("labels"), String).split(",");
			for (n in 0..._options.length) {
				_options[n].text = label[n];
			}
		}
		for (n in 0..._options.length) {
			_options[n].group = get("peg");
		}
	}
	
	public override function buildComponent():Component {
		dispose(_hbox);
		_hbox = new HBox();
		_options = new Array<OptionBox>();
		
		var option:OptionBox = new OptionBox();
		_options.push(option);
		_hbox.addChild(option);

		var option:OptionBox = new OptionBox();
		_options.push(option);
		_hbox.addChild(option);
		
		applyProps(_hbox);
		
		return _hbox;
	}
}