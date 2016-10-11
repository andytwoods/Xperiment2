package xpt.stimuli.builders.basic;

import de.polygonal.ds.Map;
import flash.display.BitmapData;
import flash.geom.Matrix;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.Component;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import thx.Arrays;
import thx.Maps;
import thx.Objects;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.PathTools;
import xpt.preloader.Preloader;
import xpt.tools.XML_tools;
import xpt.tools.XRandom;
import xpt.tools.XTools;

#if svg
	import format.SVG;
#end

class StimSVG extends StimulusBuilder {
	
	private var svg_txt:String;
	
	private static inline var SVG_Tag = 'svg_';
	private static inline var SVG_Tool = 'svgtool_';
	
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
		processSVG(resource, image);

		}
		

	}
	
	@:access(haxe.ui.toolkit.controls.Image)
	function processSVG(resource:String, image:Image) 
	{
		var svg:String = Preloader.instance.preloadedText.get(resource);
		if (svg != null) {
			if (svg_txt != null) return;
			setSvg(svg, image);	
			
			
					#if html5
			var onClick:String = get("onClick");
			
			image._svgSprite.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {
				trace(123);
			});
		
		#end
			
			
		}
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
			else if (StringTools.startsWith(key, SVG_Tool)) {
				svg_txt = SVG_Tools.process(key.substr(SVG_Tool.length), stim.get(key), svg_txt);
			}
		}
		return svg_txt;
	}
	

}

class SVG_Tools {

	public static function process(tool:String, command_str:String, svg_str:String):String {
		switch(tool) {
			case 'shuffle':
				return shuffle(command_str, svg_str);
				
			default: throw 'unknown svg_tool';
		}
	}
	
	public static function shuffle(attrib:String, svg_str:String):String {
		var SVG_xml:Xml = Xml.parse(svg_str);
		
		var xmlArr:Array<Xml> = XTools.iteratorToArray(XML_tools.find(SVG_xml, attrib));
		
		var swapVals:Array<String> = [];
		var swapAttribs:Array<String> = [];
		
		var swapVal:String;
		var swapAttrib:String;
		var xml:Xml;
		for (i in 0... xmlArr.length) {
			xml = xmlArr[i];
			swapAttrib = xml.get(attrib);
			swapAttribs.push(swapAttrib);
			swapVal = xml.get(swapAttrib);
			swapVals.push(swapVal);
		}

		swapVals = XRandom.shuffle(swapVals);
		
		for (i in 0... xmlArr.length) {
			xml = xmlArr[i];
			swapAttrib = swapAttribs[i];
			swapVal = swapVals[i];
			xml.set(swapAttrib, swapVal);
		}

		return SVG_xml.toString();
	}
	
	
}