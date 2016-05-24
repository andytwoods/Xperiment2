package xpt.stimuli;
import de.polygonal.Printf;
import flash.events.MouseEvent;
import flash.geom.Point;
import haxe.ui.toolkit.core.RootManager;
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.events.Event;


class StimTools
{

	public static function ColourAtCursor():String {
		
		var stage:Stage = RootManager.instance.currentRoot.sprite.stage;
	
		if (stage == null) return 'off screen';
		var bmd:BitmapData = new BitmapData(Std.int(stage.width), Std.int(stage.height));
		bmd.draw(stage);
		var rgb:Int = bmd.getPixel(Std.int(stage.mouseX), Std.int(stage.mouseY));
		
		return StringTools.hex(rgb);		
	}
}