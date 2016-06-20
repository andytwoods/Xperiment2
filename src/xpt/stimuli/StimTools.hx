package xpt.stimuli;
import de.polygonal.Printf;
import flash.events.MouseEvent;
import flash.geom.Point;
import haxe.ui.toolkit.core.RootManager;
import js.Browser;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;



class StimTools
{

	public static function ColourAtCursor():String {
		
		var stage:Stage = RootManager.instance.currentRoot.sprite.stage;
	
		if (stage == null) return 'off screen';
		
		var w:Int, h:Int;
		
		#if html5
			w = Browser.window.innerWidth;
			h = Browser.window.innerHeight;
		#else
			w = stage.width;
			h = stage.height;
		#end

		var bmd:BitmapData = new BitmapData(w, h);
		bmd.draw(stage);
		
		var rgb:Int = bmd.getPixel(Std.int(stage.mouseX), Std.int(stage.mouseY));
		
		return StringTools.hex(rgb);		
	}
}