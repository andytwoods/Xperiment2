package xpt.stimuli.all;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.all.custom.NumberSelectorDigit;

class Stim_MultiNumberSelector extends HaxeUIStimulus {
	private var _hbox:HBox;
	private var _digits:Array<NumberSelectorDigit>;
	
	public function new() {
		super();
	}

	public override function applyProps(c:Component):Void {
		super.applyProps(c);
		var startingVal:String = cast(get("startingVal"), String);
		for (n in 0...startingVal.length) {
			_digits[n].digit = Std.parseInt(startingVal.charAt(n));
		}
	}
	
	public override function buildComponent():Component {
		dispose(_hbox);
		
		_digits = new Array<NumberSelectorDigit>();
		
		_hbox = new HBox();
		
		var startingVal:String = cast(get("startingVal"), String);
		for (n in 0...startingVal.length) {
			var digit:NumberSelectorDigit = new NumberSelectorDigit();
			digit.percentWidth = 100 / startingVal.length;
			digit.percentHeight = 100;
			digit.autoSize = false;
			_hbox.addChild(digit);
			_digits.push(digit);
		}
		
		applyProps(_hbox);
		_component = _hbox;
		return _hbox;
	}
}
