package screenManager;
import haxe.ui.toolkit.core.RootManager;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author 
 */
class ScreenManager_web
{

	static public var NOMINAL_WIDTH:Int = 2048;
	static public var NOMINAL_HEIGHT:Int = 1536;
	
	private static var stage:Stage;
	
	static public function init(_stage:Stage) 
	{
		stage = _stage;
		trace(13434333);
		RootManager.instance.currentRoot.autoSize = true;
		stage.addEventListener(Event.RESIZE, onResize);
        onResize(null);
	}
	
	private static function onResize(e:Event):Void {

		var stageScaleX:Float = stage.stageWidth / NOMINAL_WIDTH;
		var stageScaleY:Float = stage.stageHeight / NOMINAL_HEIGHT;
		
		trace(111,stageScaleX. stageScaleY);
		var stageScale:Float = Math.min(stageScaleX, stageScaleY);
		
		Lib.current.width = stageScale * NOMINAL_WIDTH;
		Lib.current.height = stageScale * NOMINAL_HEIGHT;
		

		if (stageScaleX > stageScaleY) {
			Lib.current.x = (stage.stageWidth - NOMINAL_WIDTH * stageScale) / 2;
			Lib.current.y = 0;
		} else {
			Lib.current.x = 0;
			Lib.current.y = (stage.stageHeight - NOMINAL_HEIGHT * stageScale) / 2;
		}

    }
	
	
}