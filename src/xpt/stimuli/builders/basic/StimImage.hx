package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.Component;
import openfl.display.Bitmap;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.ScriptTools;
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
		}

		if (get("resource") != null) {
            var bmp:Bitmap = Preloader.instance.preloadedImages.get(get("resource"));
			trace(111, bmp);
            if (bmp != null) {
                image.resource = new Bitmap(bmp.bitmapData.clone());
            }
		}
	}
}