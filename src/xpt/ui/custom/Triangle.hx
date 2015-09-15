package xpt.ui.custom;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.core.StateComponent;
import openfl.events.MouseEvent;

class Triangle extends StateComponent {
	public static inline var STATE_NORMAL = "normal";
	public static inline var STATE_OVER = "over";
	public static inline var STATE_DOWN = "down";
	
	public var direction:String = "down";
	
	public function new() {
		super();
		sprite.mouseEnabled = true;
		sprite.buttonMode = true;
	}
	
	public override function initialize():Void {
		super.initialize();
		addEventListener(MouseEvent.MOUSE_OVER, _onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	public override function paint():Void {
		_sprite.graphics.clear();

		if (direction == "down") {
			_sprite.graphics.lineStyle(_baseStyle.borderSize, _baseStyle.borderColor);
			_sprite.graphics.beginFill(_baseStyle.backgroundColor);
			_sprite.graphics.moveTo(0, 0);
			_sprite.graphics.lineTo(_width, 0);
			_sprite.graphics.lineTo(_width / 2, _height);
			_sprite.graphics.lineTo(0, 0);
			_sprite.graphics.endFill();
		}
	}

	// ************************************************************************************************************
	// EVENTS
	// ************************************************************************************************************
	private var _down:Bool = false;
	private function _onMouseOver(event:MouseEvent):Void {
		if (event.buttonDown == false || _down == false) {
			state = STATE_OVER;
		} else {
			state = STATE_DOWN;
		}
	}
	
	private function _onMouseOut(event:MouseEvent):Void {
		if (event.buttonDown == false) {
			state = STATE_NORMAL;
		} else {
			//Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
	}
	
	private function _onMouseDown(event:MouseEvent):Void {
		_down = true;
		state = STATE_DOWN;
		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	private function _onMouseMove(event:MouseEvent):Void {
		
	}
	
	private function _onMouseUp(event:MouseEvent):Void {
		_down = false;
		if (hitTest(event.stageX, event.stageY)) {
			#if !(android)
				state = STATE_OVER;
			#else
				state = STATE_NORMAL;
			#end
		} else {
			state = STATE_NORMAL;
		}

		//if (_remainPressed == true) {
			Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		//}
	}
	
	//******************************************************************************************
	// IState
	//******************************************************************************************
	private override function get_states():Array<String> {
		return [STATE_NORMAL, STATE_OVER, STATE_DOWN];
	}
	
	private override function set_state(value:String):String {
		super.set_state(value);
		if (value == STATE_DOWN) {
			_down = true;
		}
		return value;
	}
}