package xpt.screenManager;
import flash.display.Stage;
import flash.display.StageScaleMode;
import flash.events.Event;
import haxe.ui.toolkit.core.DisplayObject;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleManager;
import openfl.Lib;
import xpt.tools.XTools;

#if html5
	import js.Browser;
#end	

enum Orientation {
	Horizontal;
	Vertical;
	
}

/**
 * ...
 * @author 
 */
class ScreenManager
{

	public var root:Root;
	public var stage:Stage;
	
	public static var _instance:ScreenManager;
	static public var NOMINAL_WIDTH:Int = 1024; // moreso defining an aspect ratio
	static public var NOMINAL_HEIGHT:Int = 768;
	
	static private var width_multiplier:Float = 1;
	static private var height_multiplier:Float = 1;
	
	private var stageScaleX:Float;
	private var stageScaleY:Float;
	private var stageScale:Float ;
	
	
	public static var instance(get, null):ScreenManager;
	private static function get_instance():ScreenManager {
		if (_instance == null) {
			_instance = new ScreenManager();
		}
		return _instance;
	}
	

	public function checkOrientation():Bool {
		trace(screenOrientation(), desired_orientation);
		return screenOrientation() == desired_orientation;
	}
	
	public var callbacks:Array<Float->Float->Void>;
	public var desired_orientation:Orientation = Orientation.Horizontal;
	
	public function orientation(orientationStr:String):Orientation {
		var orientationEnum:Orientation = null;

		switch(orientationStr.toLowerCase()) {
			case 'horizontal':
				orientationEnum = Horizontal;
				trace(111);
			case 'vertical':
				orientationEnum = Vertical;
		}
		if (orientationEnum != instance.desired_orientation) {
			desired_orientation = orientationEnum;
			onResize(null);
		}
		desired_orientation = orientationEnum;
		return desired_orientation;
	}
	
	public function screenOrientation():Orientation {
		
		#if html5
			if (Browser.window.orientation == null) return Horizontal;
			else if (Browser.window.orientation == 90 || Browser.window.orientation == -90) return Horizontal;
			return Vertical;
		#end
		
		
		return Horizontal;
	}
		
		
	public function new(){
	
		callbacks = new Array<Float->Float->Void>();
		root = RootManager.instance.currentRoot;
		root.autoSize = false;
		stage = Lib.current.stage;
	
		#if html5
			width_multiplier = height_multiplier = Browser.window.devicePixelRatio;
			Browser.window.addEventListener("orientationchange", function(e:String){ 
				
				onResize(null);
			} );

		#else 
			stage.addEventListener(Event.RESIZE, onResize);
			
		#end
		
		onResize(null);
	}
	

	
	
	private function onResize(e:Event):Void {
		
		refresh();
	}
	
	
	public function background(colStr:String) {

		var col:Int = XTools.getColour(colStr);	
		RootManager.instance.currentRoot.style.backgroundAlpha = 0;
		Lib.current.stage.color = col;
	}
	
	public function refresh() 
	{
		//dont do anything if an undesired screen orientation has occured. Screen hidden anyway upon this event.
		//if (checkOrientation() == false) return;
		
		var swap:Bool = false;
		
		#if html5
		
			var w:Int = Browser.window.innerHeight; 	
			var h:Int = Browser.window.innerWidth ;


		#else
			var w:Int = stage.stageWidth;
			var h:Int = stage.stageHeight;
		#end

		
		stageScaleX = w / NOMINAL_WIDTH;// * width_multiplier;
		stageScaleY = h / NOMINAL_HEIGHT;// * height_multiplier;		
		
		stageScale = Math.min(stageScaleX, stageScaleY);

		root.width = NOMINAL_WIDTH * stageScale *width_multiplier;
		root.height = NOMINAL_HEIGHT * stageScale * height_multiplier;

		//root.x = (w - NOMINAL_WIDTH * stageScale *width_multiplier) * .5;		
		//root.y = (h - NOMINAL_HEIGHT * stageScale * height_multiplier) * .5;
	

		
		for (callBack in callbacks) {
			callBack(root.x, root.y);
		}
	}
	
}