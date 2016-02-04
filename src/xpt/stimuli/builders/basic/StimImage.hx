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
		if (resource != null) {
			//if cannot get data
            resource = PathTools.fixPath(resource);
            if (false == setBitmap(Preloader.instance.preloadedImages.get(resource), image) ) {
				Preloader.instance.callbackWhenLoaded(resource, function(){
					setBitmap(Preloader.instance.preloadedImages.get(resource), image);	
					image.y -= image.height * .25;
				});
			}
		}
	}
	
	private function setBitmap(b:Bitmap, image:Image):Bool {
		var bmp:Bitmap = b;
		if (bmp == null) return false;
		image.resource = new Bitmap(bmp.bitmapData.clone());		
		return true;
	}
}