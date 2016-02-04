package xpt.screenManager;
import flash.display.Stage;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleManager;
import openfl.Lib;

/**
 * ...
 * @author 
 */
class ScreenManager
{

	public var stage:Stage;
	public static var instance:ScreenManager;
		
	public function new(){}
	
	
	public static function init():ScreenManager {
	
		
		if (instance == null) {
			instance = new ScreenManager();
			instance.stage = Lib.current.stage;
		}
		
		return instance;
		
	}
	
	public function background(col:Int) {
		trace(1111);
		
		RootManager.instance.currentRoot.
		
		StyleManager.instance.addStyle("Root.fullscreen", new Style( {
			backgroundColor: 0x888888,
		} ));
		
	}
	
}