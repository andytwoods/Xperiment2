package xpt.screenManager;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.base.HorizontalAlign;
import haxe.ui.toolkit.core.base.VerticalAlign;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import motion.Actuate;
import openfl.Lib;
import xpt.tools.XTools;


#if html5
	import js.Browser;
#end	

 
class RotateYourScreen
{

	public static var instance(get, null):RotateYourScreen;

	public var dispose:Void->Void;
	
	private static function get_instance():RotateYourScreen {
		if (instance!= null && instance.dispose != null) {
			instance.dispose();
			instance = null;
		}
		
		instance = new RotateYourScreen();
	
		return instance;
	}
	
	
	public function new() {
	}
	
	
	
	
	public function message()
	{
		var background:VBox = new VBox();
		background.percentWidth = 100;
		background.percentHeight = 100;
		background.style.backgroundColor = 0xffffff;
		background.verticalAlign = VerticalAlign.CENTER;
		background.horizontalAlign = HorizontalAlign.CENTER;
		background.autoSize = false;
		
		var root:Root = RootManager.instance.currentRoot;
		root.addChild(background);
		
		var textInfo:Text = new Text();
		textInfo.style.fontSize = 40;
		textInfo.multiline = true;
		textInfo.wrapLines = true;
		textInfo.text = "Your screen needs to be in a " + ScreenManager.instance.desired_orientation.getName()+" orientation for this study. Please rotate your device to continue.";
		textInfo.selectable = false;
		textInfo.percentWidth  = 100;
		textInfo.percentHeight = 50;

		textInfo.horizontalAlign = HorizontalAlign.CENTER;
		textInfo.y = 200;

	
		background.addChild(textInfo);
		
		var image:Image = new Image();
		image.resource = "img/icons/redo.png";
		image.horizontalAlign = HorizontalAlign.CENTER;
		image.verticalAlign = VerticalAlign.CENTER;
		
		background.addChild(image);
		

		dispose = function(){
			root.removeChild(background);
			background = null;
			image = null;
			textInfo = null;
			
		}
	}
	
	public function monitor(callback:Void->Void) {
		

		if (ScreenManager.instance.checkOrientation() == true) callback();
		else message();
		
		
		#if html5
			function orientationChangeL()
			{
				if (ScreenManager.instance.checkOrientation() == false) {
					if(dispose == null) message();
				}
			    else if (dispose != null) {
					dispose();
					dispose = null;
					if (callback != null) {
						callback();
						callback = null;
					}
				}
			}
			
			Browser.window.addEventListener("orientationchange", orientationChangeL );
		
		#else
		
			
			Lib.current.stage.addEventListener(Event.RESIZE, function(e:Event) {	
			if (ScreenManager.instance.checkOrientation() == false) {
				if(dispose == null) message();
			}
			else if(dispose != null) dispose();
			
		});
			
		#end

	}
	

	
}