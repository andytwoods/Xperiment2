package xpt.ui.custom;

import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;

class Line extends Box {
	private var _startLabel:Text;
	private var _endLabel:Text;
	
	public var offsetX:Int = 30;
	public var offsetY:Int = -5;
	
	public function new() {
		super();
	}
	
	public override function paint():Void {
		_sprite.graphics.clear();

		_sprite.graphics.lineStyle(_baseStyle.borderSize, _baseStyle.borderColor);
		_sprite.graphics.moveTo(offsetX, offsetY);
		_sprite.graphics.lineTo(_width - offsetX, offsetY);
		
		_sprite.graphics.moveTo(offsetX, offsetY - 5);
		_sprite.graphics.lineTo(offsetX, offsetY + 5);
		
		_sprite.graphics.moveTo(_width - offsetX, offsetY - 5);
		_sprite.graphics.lineTo(_width - offsetX, offsetY + 5);
	}
	
	public var startLabel(get, set):String;
	private function get_startLabel():String {
		if (_startLabel == null) {
			return null;
		}
		return _startLabel.text;
	}
	private function set_startLabel(value:String):String {
		if (_startLabel == null) {
			_startLabel = new Text();
			_startLabel.horizontalAlign = "left";
			_startLabel.verticalAlign = "bottom";
			addChild(_startLabel);
		}
		_startLabel.text = value;
		return value;
	}
	
	public var endLabel(get, set):String;
	private function get_endLabel():String {
		if (_endLabel == null) {
			return null;
		}
		return _endLabel.text;
	}
	private function set_endLabel(value:String):String {
		if (_endLabel == null) {
			_endLabel = new Text();
			_endLabel.horizontalAlign = "right";
			_endLabel.verticalAlign = "bottom";
			addChild(_endLabel);
		}
		_endLabel.text = value;
		return value;
	}
}