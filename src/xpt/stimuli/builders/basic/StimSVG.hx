package xpt.stimuli.builders.basic;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.Component;
import openfl.display.Sprite;
import xpt.tools.PathTools;
import xpt.experiment.Preloader;

#if svg
	import format.SVG;
#end

class StimSVG extends StimImage
{
	var _svgSprite:Sprite = null;
	private static inline var SVG_Tag = 'svg_';
	
	
	override public function onRemovedFromTrial() {
		super.onRemovedFromTrial();
		if(_svgSprite !=null){
			if (_svgSprite.parent != null) _svgSprite.parent.removeChild(_svgSprite);
			_svgSprite = null;
		}
		
    }
	
	
	public function new() 
	{
		super();
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
		  
			 processSVG(resource, image);
		
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
			var svg:SVG = new SVG(svg_txt);
			image.updateSvg(svg);
		#end
	}
	
	function insertSvgParams(svg_txt:String) 
	{
		var prop:String;
		for (key in stim.props.keys()) {
			if (StringTools.startsWith(key, SVG_Tag)) {
				prop = key.substr(SVG_Tag.length);
				svg_txt = StringTools.replace(svg_txt, prop, stim.get(key));
			}
		}
		return svg_txt;
	}
	
}