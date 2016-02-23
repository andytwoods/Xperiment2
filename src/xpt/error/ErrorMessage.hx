package xpt.error;
import openfl.display.Shape;
import openfl.display.Stage;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author ...
 */
class ErrorMessage
{
	public static var Report_to_experimenter:String = "Please report this message to the experimenter";
	
	
	private static var stage:Stage;
	private static var errors:Array<String>;
	private static var text:TextField;
	private static var header:String = "WE APOLOGIZE. THE EXPERIMENT CANNOT CONTINUE. THERE HAS BEEN AN ERROR.";
	
	public static function setup(s:Stage):Void {
		stage = s;
	}
	
	public static function error(type:String, message:String, kill:Bool = false):Void {
		if (errors == null) {
			errors = [header,""];
		}
		errors.push(type + ": "+ message);
		var bg:Shape = new Shape();
		bg.graphics.beginFill(0, .9);
		bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		stage.addChild(bg);
		
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
			stage.addChild(text);
		}
		text.text = errors.join("\n");
		
		if (kill) throw text.text;
	}
	

	
	
}