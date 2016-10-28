package xpt.ui.custom;

import de.polygonal.ds.Map;
import openfl.display.Stage;
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
import openfl.geom.Point;
import openfl.geom.Rectangle;
import thx.Floats;
import xpt.screenManager.ScreenManager;
import xpt.tools.XTools;

#if html5
	import js.Browser;
#end

enum ScaleType {
	DrawnLine;
	Cross;
}

class DrawnLineScale extends StateComponent {
	private var _line:Line;
	private var bounds:Rectangle;
	public var bufferZone:DrawBox;
	public var updatedCallback:Float->Void;
	private var reset:Bool = false;
	private var prevPosition:Point;
	private var position:Point; 
	private var type:ScaleType = DrawnLine;
	private var mouseUpListener = false;
	private var mouseDown:Bool = false;
	
	private var unselectedBorderColor:Int = 0xe6e6e6;
	private var selectedBorderColor:Int = 0x000000;
	
	var stage:Stage;
	
	#if html5
		var spr:Sprite;
	#end
	
	public function new() {
		super();
		
		layout = new DrawnLineScaleLayout();
		
		_line = new Line();
		_line.height = 30;
		_line.percentWidth = 100;
		_line.id = "line";
		_line.verticalAlign = "center";
		addChild(_line);
		
		bufferZone = new DrawBox(2, 0x000345);
		bufferZone.percentWidth = 100;
		bufferZone.percentHeight = 100;
		bufferZone.verticalAlign = "center";
		bufferZone.x = 100;
		addChild(bufferZone);
		bufferZone._sprite.addEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		bufferZone._sprite.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		bufferZone._sprite.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
	}
	
	
	public function setType(typeStr:String) {

		switch(typeStr.toLowerCase()) {
			case 'line':
				type = DrawnLine;
			case 'cross':
				type = Cross;
			default:
				throw 'unknown type' + typeStr;
		}
	}
	
	
	private function _onMouseOut(e:MouseEvent):Void {
		_onMouseUp(e);
	}
	
	public function scoreableWidth():Float {
		return bufferZone.width - 2 * _line.offsetX;
	}
	
	public function getPercent_pixel_pos_in_box(position:Float):Float {
		return (position - _line.offsetX) / scoreableWidth() * 100;
	}

	private function _onMouseUp(e:MouseEvent):Void {
		if (mouseDown == false) return;
		mouseDown = false;
		if(mouseUpListener) bufferZone.sprite.stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		mouseUpListener = false;
		reset = true;
		var intersection:Point = null;
		switch(type) {
			case DrawnLine:
				intersection = bufferZone.check_intersects(.5, _line.offsetX);
			case Cross:
				
				intersection = bufferZone.check_lines_intersect();
		}
		
		if (intersection != null) {
			var percent:Float = getPercent_pixel_pos_in_box(intersection.x);
			if (percent < 0 || percent > 100) {
				borderCol(unselectedBorderColor);
				bufferZone.keep(1);
				bufferZone.reset();
				bufferZone.paint();
			}
			else{
				borderCol(selectedBorderColor);
				if (updatedCallback != null) updatedCallback(percent);
			}
		}
		else {
			borderCol(unselectedBorderColor);
			if (type == Cross) {
			//	
			}	
			else {	
				consider_reset(null);
				
			}		
		}	
	}
	
	private function borderCol(col:Int) {
		this.style.borderColor = col;
		this.style.borderSize = 3;
		this.refreshStyle();
	}
	
	private inline function consider_reset(point:Point, extra:Bool=false) {
		switch(type) {
			case DrawnLine:
				bufferZone.reset(point);
			case Cross:
				if (extra) {
					bufferZone.keep(2);
					bufferZone.nextLine(point);	
				}
				'';
		}
	}

	private function _onMouseDown(e:MouseEvent):Void {
		mouseDown = true;
		bufferZone.sprite.stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		mouseUpListener = true;
		consider_reset(new Point(e.localX, e.localY), true);
		
	}
	
	private function _onMouseMove(e:MouseEvent):Void {
		if (mouseDown == false) return;
		if (reset == true) {
			reset = false;
			consider_reset(null);
		}
		bufferZone.addPoint(new Point(e.localX, e.localY));	
	}
		
	public override function initialize():Void {
		super.initialize();
	}	

	public function kill() {
		bufferZone.kill();
		bufferZone._sprite.removeEventListener(MouseEvent.MOUSE_OUT, _onMouseOut);
		bufferZone._sprite.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
		bufferZone._sprite.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
		
		#if html5
			if (spr != null) {
				RootManager.instance.currentRoot.sprite.stage.removeChild(spr);
				spr = null;
			}
			#if html5
		var spr:Sprite;
	#end
		
		
		#end
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
        
		_val = Floats.roundTo(v,2);
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


@:access(xpt.ui.custom.DrawnLineScale)
class DrawnLineScaleLayout extends BoxLayout {
	public function new() {
		super();
	}
	
	public override function repositionChildren():Void {
		super.repositionChildren();
		
		
		var line:Line =  container.findChild("line", Line);
        if (line == null) {
            return;
        }
        
		var scale:DrawnLineScale = cast container;
		
		
        // now lets position the labels
        if (scale._labelComponents != null) {
            var labelPositions:Array<Float> = scale._labelPositions;
            var ucx:Float = line.width - (line.offsetX * 2);
            for (i in 0...scale._labelComponents.length) {
                var label:Text = scale._labelComponents[i];
				label.style.textAlign = 'center';
                label.x = ucx * labelPositions[i] - label.width *.25;
                label.y = scale.height;
            }
        }
	}
}