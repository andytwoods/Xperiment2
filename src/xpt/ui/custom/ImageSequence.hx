package xpt.ui.custom;

import haxe.ui.toolkit.controls.Image;
import openfl.display.Bitmap;
import openfl.events.MouseEvent;
import xpt.debug.DebugManager;
import xpt.preloader.Preloader;
import xpt.tools.PathTools;

class ImageSequence extends Image {
	public var resourcePattern:String;
	
	public function new() {
		super();
	}
	
	public override function initialize():Void {
		super.initialize();
		updateImage();
		
		addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent) {
			if (e.delta < 0) {
				val--;
			} else if (e.delta > 1) {
				val++;
			}
		});		
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
	
	private var _max:Float = 0;
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
		
		if (_val != v) {
			_val = v;
			updateImage();
		}
		
		return v;
	}
	
	private function updateImage():Void {
		var res:String = StringTools.replace(resourcePattern, "${value}", "" + _val);
        res = PathTools.fixPath(res);
		var bmp:Bitmap = Preloader.instance.preloadedImages.get(res);
		resource = new Bitmap(bmp.bitmapData.clone());
	}
}