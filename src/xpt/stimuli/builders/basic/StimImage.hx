package xpt.stimuli.builders.basic;

import de.polygonal.ds.Map;
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
import xpt.experiment.Preloader;
import xpt.tools.XTools;

#if svg
import format.SVG;
#end

class StimImage extends StimulusBuilder {
	
	var _svgSprite:Sprite = null;
	
	private static inline var SVG_Tag = 'svg_';
	
	public function new() {
		super();
	}
	
	override public function onRemovedFromTrial() {
		super.onRemovedFromTrial();
		if(_svgSprite !=null){
			if (_svgSprite.parent != null) _svgSprite.parent.removeChild(_svgSprite);
			_svgSprite = null;
		}
		
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
		   if (XTools.filetype(resource, true) == "SVG") {
			  processSVG(resource, image);
			  return;
		   }
		   var bmp = Preloader.instance.preloadedImages.get(resource);
           if(bmp!=null) setBitmap(bmp, image);	
		   else{
				Preloader.instance.callbackWhenLoaded(resource, function() {
					update();
				});
			}
		}
	}
	
	function processSVG(resource:String, image:Image) 
	{
		var svg:String = Preloader.instance.preloadedText.get(resource);
		if (svg != null) setSvg(svg, image);	
	    else{
			Preloader.instance.callbackWhenLoaded(resource, function() {
				update();
			});
		}
	}
	
	@:access(haxe.ui.toolkit.controls.Image)
	private function setSvg(svg_txt:String, image:Image) {
		svg_txt = insertSvgParams(svg_txt);
		#if svg
			if (_svgSprite == null) {
				var svg:SVG = new SVG(svg_txt);
				image.updateSvg(svg);
			}
			
		#end
	}
	
	function insertSvgParams(svg_txt:String) 
	{
		var prop:String;
		for (key in _stim.props.keys()) {
			if (StringTools.startsWith(key, SVG_Tag)) {
				prop = key.substr(SVG_Tag.length);
				svg_txt = StringTools.replace(svg_txt, prop, _stim.props.get(key));
			}
		}
		return svg_txt;
	}
	
	
	private function setBitmap(bmp:Bitmap, image:Image) {
		var bm_data:BitmapData = bmp.bitmapData.clone();
		var scale:Float;
		if ((scale = getFloat('scale')) != -1) {
			bm_data = scale_bm_data(scale , bm_data);		
		}

		
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