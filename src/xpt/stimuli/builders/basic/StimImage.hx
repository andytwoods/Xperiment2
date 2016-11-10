package xpt.stimuli.builders.basic;

import flash.display.BitmapData;
import flash.geom.Matrix;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.Component;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import thx.Maps;
import thx.Objects;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.PathTools;
import xpt.preloader.Preloader;
import xpt.tools.XTools;


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
           if(resource.indexOf('http')==-1) resource = PathTools.fixPath(resource);
		   
		   var bmp = Preloader.instance.preloadedImages.get(resource);
           if (bmp != null) setBitmap(bmp, image);	
		
			else 
				Preloader.instance.callbackWhenLoaded(resource, function() {
					update();	
			});
		}
	}
	
	override public function results():Map<String,String> {
		if (getBool('save', false) == true) {
			return [stim.id => get("resource")];
		}
		return null;
	}
	
	
	private function setBitmap(bmp:Bitmap, image:Image) {
		var scale:Float = getFloat('scale', 1);
		var bm_data:BitmapData = bmp.bitmapData.clone();
		bm_data = scale_bm_data(scale , bm_data);	 	
	
		image.resource = new Bitmap(bm_data);	

	}
	
	private function scale_bm_data(scale:Float, orig_bm_data:BitmapData):BitmapData {

		var matrix:Matrix = new Matrix();
		matrix.scale(scale, scale);

		var scaled:BitmapData = new BitmapData(Std.int(orig_bm_data.width * scale), Std.int(orig_bm_data.height * scale), true, 0x000000);
		scaled.draw(orig_bm_data, matrix, null, null, null, true);
		
		return scaled;
	}
}