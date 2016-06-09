package xpt.ui.custom;

import flash.display.Stage;
import haxe.Constraints.FlatEnum;
import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.interfaces.InvalidationFlag;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.core.StateComponent;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.layout.BoxLayout;
import haxe.ui.toolkit.layout.VerticalLayout;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import xpt.screenManager.ScreenManager;

#if html5
	import js.Browser;
#end

class LineScale extends StateComponent {
	private var _selection:Triangle;
	private var _line:Line;
	private var bounds:Rectangle;
	public var bufferZone:Box;
	public var triangleMoveCallBack:Float->Void;
	
	var stage:Stage;
	
	#if html5
		var spr:Sprite;
	#end
	
	public function new() {
		super();
		layout = new LineScaleLayout();
		
		_line = new Line();
		_line.height = 30;
		_line.percentWidth = 100;
		_line.id = "line";
		_line.verticalAlign = "bottom";
		addChild(_line);

		bufferZone = new Box();
		bufferZone.percentWidth = 100;
		bufferZone.percentHeight = 100;
		bufferZone.style.backgroundColor = 0x000000;
		bufferZone.style.backgroundAlpha = 0;
		bufferZone.verticalAlign = "center";
		//bufferZone.addEventListener(MouseEvent.MOUSE_DOWN, _onTriangleMouseDown);
		addChild(bufferZone);
		
		_selection = new Triangle();
		_selection.x = 10;
		_selection.y = 10;
		_selection.width = 50;
		_selection.height = 50;
		_selection.id = "selection";
		_selection.addEventListener(MouseEvent.MOUSE_DOWN, _onTriangleMouseDown);
		#if html5
			Browser.window.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		#end
		addChild(_selection);
		
		

		
	}

	
	
	public override function initialize():Void {
		super.initialize();
	}
	

	public function kill() {
		#if html5
			Browser.window.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			if (spr != null) {
				RootManager.instance.currentRoot.sprite.stage.removeChild(spr);
				spr = null;
			}
			#if html5
		var spr:Sprite;
	#end
		
		
		#end
	}

	private function _onTriangleMouseDown(event:MouseEvent):Void {
		calcBounds();
		_selection.sprite.startDrag(false, bounds);
		if (triangleMoveCallBack != null) {
			_selection.sprite.stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveCallback);
		}
		//_selection.sprite.stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove); //note some weird interaction with this. Causes mouse to continue to move, despite stopDrag()
		
		RootManager.instance.currentRoot.sprite.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
	}
	
	function _onMouseMoveCallback(e:MouseEvent) {
		if (triangleMoveCallBack != null) {
			_onMouseMove(null);
			triangleMoveCallBack(val);
		}
	}
	
	
	private inline function calcBounds() {
		bounds = _line.sprite.getBounds(_line.sprite);
		bounds.x -= _selection.width * .5 - 1;
		bounds.width -= 2;
		bounds.y = _selection.y;
		bounds.height = 0;
	}
	
	private function _onMouseMove(e:MouseEvent):Void {
		val = 100 * (_selection.sprite.x - bounds.x) / bounds.width;
	}
	
	public function change_visible(on:Bool) {
		_selection.visible = on;
		#if html5
			if(on){
				spr = new Sprite();
				spr.graphics.drawRect(0, 0, 1, 1);
				RootManager.instance.currentRoot.sprite.stage.addChild(spr);	
			}
			
		#end
		
		return on;
		
		//move mouse
	}
	
	public function pos_from_localX(pos:Float) {
		if (bounds == null) calcBounds();
		pos -= _selection.width * .5;
		if (pos < bounds.x) pos = bounds.x;
		else if (pos > bounds.width) pos = bounds.width;
		_selection.x = pos;		
		_onMouseMove(null);
	}
	
	private function _onMouseUp(e:MouseEvent):Void {
		if (triangleMoveCallBack != null) {
			RootManager.instance.currentRoot.sprite.stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMoveCallback);	
		}
		//e.target.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		e.target.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		_onMouseMove(null);
		_selection.sprite.stopDrag();
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
	
	public function position_percent(p:Float):Float {
		var range:Float = _max - _min;
		_val = p * range + _min;
		invalidate(InvalidationFlag.LAYOUT);
		return val;
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
	
	private var _labels:Array<String>;
    private var _labelPositions:Array<Float>;
	private var _labelComponents:Array<Text>;
	public function sortLabels(labelList:Array<String>, labelPositionsList:Array<Float>) {
        _labels = labelList;
        _labelPositions = labelPositionsList;
        createLabels();
	}
    
    private function createLabels():Void {
        if (_labelComponents == null) {
            _labelComponents = new Array<Text>();
        }
        var n:Int = _labelComponents.length;
        for (i in 0..._labels.length - n) { // create any that are needed
            var text:Text = new Text();
            addChild(text);
            _labelComponents.push(text);
        }
        
        for (i in 0..._labels.length) {
            _labelComponents[i].text = _labels[i];
        }
    }
}

@:access(xpt.ui.custom.LineScale)
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

		selection.x = (v * n) + (selection.width * .5) - (line.offsetX - 10);
        selection.y = usableHeight - selection.height - 10;
        
        // now lets position the labels
        if (scale._labelComponents != null) {
            var labelPositions:Array<Float> = scale._labelPositions;
            var ucx:Float = line.width - (line.offsetX * 2);
            for (i in 0...scale._labelComponents.length) {
                var label:Text = scale._labelComponents[i];
                label.x = ucx * labelPositions[i];
                label.y = scale.height;
            }
        }
	}
}