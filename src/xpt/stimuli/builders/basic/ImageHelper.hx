package xpt.stimuli.builders.basic;
import haxe.ui.toolkit.controls.Image;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import xpt.tools.PathTools;
import xpt.preloader.Preloader;
import flash.geom.Matrix;
import xpt.tools.XTools;


class ImageHelper
{

	public function new() { }

	public static function handleImageLoading(image:Image, asset:String, resource:String, scale:Float, callback:String->Void, success:Void->Void= null) {
		
		if (asset != null) {
			image.resource = "asset";
			return;
		}
		
		if (resource != null) {
			var bmp = Preloader.instance.preloadedImages.get(resource);
			if (bmp != null) {
				setBitmap(bmp, image, scale);	
				if (success != null) success();
			}
			else {
				XTools.delay(50, function() { 
					callback(resource); } );	
			}
		
		}	
	}
	
	public static function setBitmap(bmp:Bitmap, image:Image, scale:Float) {
		var bm_data:BitmapData = bmp.bitmapData.clone();
		bm_data = scale_bm_data(scale , bm_data);	 	
		image.resource = new Bitmap(bm_data);	
	}
	
	public static function scale_bm_data(scale:Float, orig_bm_data:BitmapData):BitmapData {

		var matrix:Matrix = new Matrix();
		matrix.scale(scale, scale);

		var scaled:BitmapData = new BitmapData(Std.int(orig_bm_data.width * scale), Std.int(orig_bm_data.height * scale), true, 0x000000);
		scaled.draw(orig_bm_data, matrix, null, null, null, true);
		
		return scaled;
	}
	
}