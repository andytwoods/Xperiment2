package xpt.loadingScreen;

import openfl.Lib;
import openfl.display.Stage;
import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFieldAutoSize;

#if html5
	@:font("assets/fonts/Oxygen.ttf") class DefaultFont extends Font {}
//@:bitmap("assets/img/logo.png") class Splash extends BitmapData {}
#end

class LoadingScreen extends NMEPreloader
{
   
    private var textInfo:TextField;
	//private var splash:Bitmap;
	
	public function new () {

        super ();
		this.x = (Lib.current.stage.stageWidth - this.width) * .5;
        this.y = (Lib.current.stage.stageHeight - this.height) * .5;
		

		text();
		
		//image();
    }
	
/*	function image() 
	{
        splash = new Bitmap(new Splash(0,0));
        splash.smoothing = true;
        addChild(splash); //add the logo
		splash.width = splash.height = 200;
		splash.x = (Lib.current.stage.stageWidth - splash.width ) * .5;
		splash.y = (Lib.current.stage.stageHeight - splash.height ) * .5;
	}*/
	
	function text() 
	{
		#if html5
			Font.registerFont (DefaultFont);
			
			var tf = new TextFormat ("OxygenFont", 20, 0x888888);

			textInfo = new TextField();
			textInfo.defaultTextFormat = tf;
			textInfo.embedFonts = true;
			textInfo.selectable = false;
			textInfo.text = "Loading your experiment";
			textInfo.autoSize = TextFieldAutoSize.LEFT;
			textInfo.x = 400;

			addChild(textInfo);
		#end
	}
    
	/*public override function onUpdate(bytesLoaded:Int, bytesTotal:Int):Void {
        super.onUpdate(bytesLoaded, bytesTotal);
    }*/
	
	
	override public function onLoaded () {
		#if html5
			removeChild(textInfo);
		#end
		//removeChild(splash);
		super.onLoaded();		
	}
}