package xpt.screenManager;
import openfl.display.Stage;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author 
 */
class ScreenManager_web
{

	static public var NOMINAL_WIDTH:Int = 1024;
	static public var NOMINAL_HEIGHT:Int = 768;
	
	private static var stage:Stage;
	
	static public function init(_stage:Stage) 
	{		
		stage = _stage;
		
		#if !html5
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
		#else
			
		#end
	}
	
	private static function onResize(e:Event):Void {

		var stageScaleX:Float = stage.stageWidth / NOMINAL_WIDTH;
		var stageScaleY:Float = stage.stageHeight / NOMINAL_HEIGHT;
		
		var stageScale:Float = Math.min(stageScaleX, stageScaleY);
		
		Lib.current.x = 0;
		Lib.current.y = 0;
		Lib.current.scaleX = stageScale;
		Lib.current.scaleY = stageScale;
		
		if (stageScaleX > stageScaleY) {

			Lib.current.x = (stage.stageWidth - NOMINAL_WIDTH * stageScale) / 2;
		} else {
			Lib.current.y = (stage.stageHeight - NOMINAL_HEIGHT * stageScale) / 2;
		}
		trace(Lib.current.x, Lib.current.y,stage.stageWidth,stage.stageHeight);
    }
	
	
}