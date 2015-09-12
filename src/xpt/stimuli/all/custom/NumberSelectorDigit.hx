package xpt.stimuli.all.custom;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.events.UIEvent;
import openfl.events.MouseEvent;

class NumberSelectorDigit extends VBox {
	private var _inc:Button;
	private var _deinc:Button;
	private var _value:TextInput;

	public function new() {
		super();
		
		this.style.spacingY = 0;
		
		_inc = new Button();
		_inc.icon = "img/plus.png";
		_inc.iconPosition = "center";
		_inc.percentWidth = 100;
		_inc.style.cornerRadiusBottomLeft = 0;
		_inc.style.cornerRadiusBottomRight = 0;
		_inc.onClick = function(e) {
			digit++;
		}
		addChild(_inc);

		_value = new TextInput();
		_value.percentWidth = 100;
		_value.percentHeight = 100;
		_value.style.fontSize = 20;
		_value.style.textAlign = "center";
		_value.style.cornerRadius = 0;
		addChild(_value);
		
		_deinc = new Button();
		_deinc.icon = "img/minus.png";
		_deinc.iconPosition = "center";
		_deinc.percentWidth = 100;
		_deinc.style.cornerRadiusTopLeft = 0;
		_deinc.style.cornerRadiusTopRight = 0;
		_deinc.onClick = function(e) {
			digit--;
		}
		addChild(_deinc);
		
		this.addEventListener(MouseEvent.MOUSE_WHEEL, _onMouseWheel);
	}
	
	private function _onMouseWheel(event:MouseEvent) {
		digit += event.delta;
	}
	
	public var digit(get, set):Int;
	private function get_digit():Int {
		return Std.parseInt(_value.text);
	}
	private function set_digit(value:Int):Int {
		if (value < 0) {
			value = 0;
		}
		if (value > 9) {
			value = 9;
		}
		_value.text = "" + value;
		return value;
	}
}