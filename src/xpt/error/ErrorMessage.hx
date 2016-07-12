package xpt.error;
import openfl.display.Shape;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author ...
 */
class ErrorMessage
{
	public static var Report_to_experimenter:String = "Please report this message to the experimenter";
	public static var Try_reload:String = "Please try to reload this study. If this fails several times, please report this message to the experimenter";
	
	private static var errors:Array<String>;
	private static var text:TextField;
	private static var header:String = "WE APOLOGIZE. THE EXPERIMENT CANNOT CONTINUE. THERE HAS BEEN AN ERROR.";
	
	
	public static function error(type:String, message:String, kill:Bool = false):Void {
		if (errors == null) {
			errors = [header,""];
		}
		errors.push(type + ": "+ message);
		var bg:Shape = new Shape();
		bg.graphics.beginFill(0, .9);
		bg.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		Lib.current.stage.addChild(bg);
		
		if (text == null) {
			text = new TextField();
			text.textColor = 0xffffff;
			text.width = bg.width;
			text.height = bg.height;
			text.multiline = true;
			text.selectable = true;
			text.wordWrap = true;
			var tf:TextFormat = new TextFormat(null, 20);
			text.defaultTextFormat = tf;
			Lib.current.stage.addChild(text);
		}
		text.text = errors.join("\n");
		
		if (kill) throw text.text;
	}
	

	
	
}