package xpt.stimuli.builders.basic;

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
		trace(resource,33);
		if (resource != null) {
           resource = PathTools.fixPath(resource);
           setBitmap(Preloader.instance.preloadedImages.get(resource), image);	
		}
	}
	
	private function setBitmap(b:Bitmap, image:Image):Bool {
		var bmp:Bitmap = b;
		if (bmp == null) return false;
		image.resource = new Bitmap(bmp.bitmapData.clone());		
		return true;
	}
}