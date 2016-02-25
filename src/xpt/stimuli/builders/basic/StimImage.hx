package xpt.stimuli.builders.basic;

import flash.display.BitmapData;
import flash.geom.Matrix;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.Component;
import openfl.display.Bitmap;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.PathTools;
import xpt.experiment.Preloader;

class StimImage extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new Image();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var image:Image = cast c;

		if (get("asset") != null) {
			image.resource = get("asset");
			return;
		}

		var resource:String = get("resource");
		if (resource != null) {
           resource = PathTools.fixPath(resource);
           setBitmap(Preloader.instance.preloadedImages.get(resource), image);	
		}
	}
	
	private function setBitmap(b:Bitmap, image:Image):Bool {
		var bmp:Bitmap = b;
		if (bmp == null) return false;
		var bm_data:BitmapData = bmp.bitmapData.clone();
		var scale:Float;
		if ((scale = getFloat('scale')) != -1) {
			bm_data = scale_bm_data(scale , bm_data);		
		}

		
		image.resource = new Bitmap(bm_data);		
		return true;
	}
	
	private function scale_bm_data(scale:Float, orig_bm_data:BitmapData):BitmapData {

		var matrix:Matrix = new Matrix();
		matrix.scale(scale, scale);

		var scaled:BitmapData = new BitmapData(Std.int(orig_bm_data.width * scale), Std.int(orig_bm_data.height * scale), true, 0x000000);
		scaled.draw(orig_bm_data, matrix, null, null, null, true);
		
		return scaled;
	}
}