package xpt.stimuli.all;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.OptionBox;
import haxe.ui.toolkit.controls.Spacer;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;

class Stim_MultipleChoice extends HaxeUIStimulus {
	
	private var _hbox:HBox;
	private var _options:Array<Button>;
	
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
		
		if (get("icons") != null) {
			var icon:Array<String> = cast(get("icons"), String).split(",");
			for (n in 0..._options.length) {
				_options[n].icon = icon[n];
			}
		}
		
		for (n in 0..._options.length) {
			_options[n].group = get("peg");
			
			if (getInt("fontSize") != -1) {
				_options[n].style.fontSize = getInt("fontSize");
			} else {
				_options[n].style.fontSize = 20;
			}
		}
	}
	
	public override function buildComponent():Component {
		dispose(_hbox);
		_hbox = new HBox();
		_hbox.style.spacingX = 100;
		_options = new Array<Button>();

		
		var labels:Array<String> = cast(get("labels"), String).split(",");
		for (l in labels) {
			var option:Button = new Button();
			option.verticalAlign = "center";
			option.width = 150;
			option.percentHeight = 100;
			option.autoSize = false;
			option.toggle = true;
			_options.push(option);
			_hbox.addChild(option);
		}
		
		applyProps(_hbox);
		_component = _hbox;
		return _hbox;
	}
}