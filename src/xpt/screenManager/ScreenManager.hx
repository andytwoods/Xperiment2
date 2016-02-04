package xpt.screenManager;
import flash.display.Stage;
import haxe.ui.toolkit.core.RootManager;
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
	
	public function background(colStr:String) {

		var col:Int = XTools.getColour(colStr);
		
		RootManager.instance.currentRoot.style.backgroundColor = col;
		
		#if html5
			Browser.document.body.style.background = colStr;
		#end
	}
	
}