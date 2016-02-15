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

/**
 * ...
 * @author 
 */
class ScreenManager
{

	public var root:Root;
	public var stage:Stage;
	
	public static var _instance:ScreenManager;
	static public var NOMINAL_WIDTH:Int = 1024;
	static public var NOMINAL_HEIGHT:Int = 768;
	
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
	
	public var callbacks:Array<Float->Float->Void>;
		
		
	public function new(){
	
		callbacks = new Array<Float->Float->Void>();
		
		root = RootManager.instance.currentRoot;
		stage = Lib.current.stage;
	
		stage.addEventListener(Event.RESIZE, onResize);
		onResize(null);
	}
	

	private function onResize(e:Event):Void {
		
		stageScaleX = stage.stageWidth / NOMINAL_WIDTH;
		stageScaleY = stage.stageHeight / NOMINAL_HEIGHT;
		stageScale = Math.min(stageScaleX, stageScaleY);
		
		if (stageScale > 1) stageScale = 1;
		

		root.width = NOMINAL_WIDTH * stageScale;
		root.height = NOMINAL_HEIGHT * stageScale;

		
		root.sprite.scaleX = root.sprite.scaleY = stageScale;
	
		root.x = (stage.stageWidth - NOMINAL_WIDTH * stageScale) * .5;		
		root.y = (stage.stageHeight - NOMINAL_HEIGHT * stageScale) * .5;
		
		for (callBack in callbacks) {
			callBack(root.x, root.y);
		}
	}
	
	
	public function background(colStr:String) {

		var col:Int = XTools.getColour(colStr);
		
		RootManager.instance.currentRoot.style.backgroundColor = col;
		
		#if html5
			Browser.document.body.style.background = colStr;
		#end
	}
	
}