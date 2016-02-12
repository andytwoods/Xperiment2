package xpt.screenManager;
import flash.display.Stage;
import flash.display.StageScaleMode;
import flash.events.Event;
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
	
	public static var instance:ScreenManager;
	static public var NOMINAL_WIDTH:Int = 1024;
	static public var NOMINAL_HEIGHT:Int = 768;
		
	public function new(){
		
		root = RootManager.instance.currentRoot;
		stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.SHOW_ALL;
		
		stage.addEventListener(Event.RESIZE, onResize);
		onResize(null);

	}
	
	private function onResize(e:Event):Void {
		
		trace(11232);
		/*var stageScaleX:Float = stage.stageWidth / NOMINAL_WIDTH;
		var stageScaleY:Float = stage.stageHeight / NOMINAL_HEIGHT;
		
		var stageScale:Float = Math.min(stageScaleX, stageScaleY);
		
		RootManager.instance.currentRoot.x += 10;
		
		var stageScaleX:Float = stage.stageWidth / NOMINAL_WIDTH;
		var stageScaleY:Float = stage.stageHeight / NOMINAL_HEIGHT;
		
		var stageScale:Float = Math.min(stageScaleX, stageScaleY);
		
	

		root.x = (stage.stageWidth - NOMINAL_WIDTH * stageScale) / 2;
	
		root.y = (stage.stageHeight - NOMINAL_HEIGHT * stageScale) / 2;
*/
	}
	
	
	public static function init():ScreenManager {
	
		
		if (instance == null) {
			instance = new ScreenManager();
		}
		
		return instance;
		
	}
	
	public function background(colStr:String) {

		var col:Int = XTools.getColour(colStr);
		
		RootManager.instance.currentRoot.style.backgroundColor = col;
		
		#if html5
			Browser.document.body.style.background = colStr;
		#end
	}
	
}