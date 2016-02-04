package xpt.ui.custom;

import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.layout.BoxLayout;
import haxe.ui.toolkit.layout.VerticalLayout;
import openfl.events.MouseEvent;

class LineScale extends StateComponent {
	private var _selection:Triangle;
	private var _line:Line;
	
	public function new() {
		super();
		layout = new LineScaleLayout();
		
		_line = new Line();
		_line.height = 30;
		_line.percentWidth = 100;
		_line.id = "line";
		_line.verticalAlign = "bottom";
		addChild(_line);
		
		_selection = new Triangle();
		_selection.x = 10;
		_selection.y = 10;
		_selection.width = 50;
		_selection.height = 50;
		_selection.id = "selection";
		_selection.addEventListener(MouseEvent.MOUSE_DOWN, _onTriangleMouseDown);
		addChild(_selection);
		
	}
	
	public override function initialize():Void {
		super.initialize();
	}
	

	private var _mouseDownOffset:Float = -1;
	private function _onTriangleMouseDown(event:MouseEvent):Void {
		_mouseDownOffset = event.stageX - _selection.stageX;
		Screen.instance.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		Screen.instance.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	private function _onMouseMove(event:MouseEvent):Void {
		if (_mouseDownOffset == -1) {
			return;
		}
		var xpos:Float = event.stageX - this.stageX - _mouseDownOffset;
		var newVal = calcPosFromCoord(xpos + _mouseDownOffset);
		val = newVal;
		
	}
	
	private function _onMouseUp(event:MouseEvent):Void {
		_mouseDownOffset = -1;
		Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onMouseMove);
		Screen.instance.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	private function calcPosFromCoord(xpos:Float):Float {
		var minX:Float = _line.offsetX;
		var maxX:Float = _line.width - (_line.offsetX);
		
		if (xpos < minX) {
			xpos = minX;
		} else if (xpos > maxX) {
			xpos = maxX;
		}
		
		var ucx:Float = _line.width - (_line.offsetX * 2);
		var m:Int = Std.int(max - min);
		var v:Float = xpos - minX;
		var newValue:Float = min + ((v / ucx) * m);
		return newValue;
	}
	
	// ************************************************************************************************************
	// PROPERTIES
	// ************************************************************************************************************
	private var _min:Float = 0;
	public var min(get, set):Float;
	private function get_min():Float {
		return _min;
	}
	private function set_min(v:Float):Float {
		_min = v;
		return v;
	}
	
	private var _max:Float = 100;
	public var max(get, set):Float;
	private function get_max():Float {
		return _max;
	}
	private function set_max(v:Float):Float {
		_max = v;
		return v;
	}
	
	private var _val:Float = 0;
	public var val(get, set):Float;
	private function get_val():Float {
		return _val;
	}
	private function set_val(v:Float):Float {
		if (v < _min) {
			v = _min;
		}
		if (v > _max) {
			v = _max;
		}
        if (v == _val) {
            return v;
        }
        
		_val = v;
		invalidate(InvalidationFlag.LAYOUT);
        
        var event:UIEvent = new UIEvent(UIEvent.CHANGE, this);
        dispatchEvent(event);
        
		return v;
	}
	
	
	
	public function sortLabels(labelList:Array<String>, labelPositionsList:Array<Float>) 
	{
		_line.sortLabels(labelList, labelPositionsList);
	}
}

class LineScaleLayout extends BoxLayout {
	public function new() {
		super();
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		
		var selection:Triangle =  container.findChild("selection", Triangle);
		var line:Line =  container.findChild("line", Line);
        if (line == null) {
            return;
        }
		var scale:LineScale = cast container;
		
		var ucx:Float = line.width - (line.offsetX * 2);
		var m = scale.max - scale.min;
		var n = ucx / m;
		var v = scale.val;
		selection.x = (v * n) + (selection.width / 2) - (line.offsetX - 10);
		selection.y += line.offsetY;
	}
}