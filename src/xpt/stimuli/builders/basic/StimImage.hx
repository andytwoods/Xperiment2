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
		var resource = get('resource');
		if(resource.indexOf('http')==-1) resource = PathTools.fixPath(resource);
		ImageHelper.handleImageLoading(image, get('asset'), resource, getFloat('scale', 1), function(resource:String) {
			Preloader.instance.callbackWhenLoaded(resource, function() {	
						update();	
				}
			);	
		});	
	}
	


}