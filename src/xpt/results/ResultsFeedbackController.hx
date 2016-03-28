package xpt.results;

import flash.events.Event;
import flash.text.TextField;
import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.hscript.ScriptInterp;
import openfl.events.KeyboardEvent;
import thx.Strings;
import xpt.experiment.Experiment;
import flash.events.TimerEvent;
import flash.utils.Timer;
import xpt.tools.SaveFile;
import xpt.tools.XTools;


@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/resultsFeedback-window.xml"))
class ResultsFeedbackController extends XMLController {
	private var ICONS:Map<String, String> = [
		"ERROR" => "img/icons/exclamation-red.png",
		"SUCCESS" => "img/icons/success.png"
	];
	
	var countdown:Countdown;
	var tryAgain_callBack:Void->Void;
	

	public function new(callback:Void->Void) {	
		
		function onAddedToStage(e:Event) {
			info.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			info.width = 650;
			info.text = "Attempting to save your results...";
		}
		info.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		
		tryAgain_callBack = callback;
		if (countdownTxt != null) {
			countdown = Countdown.DO(countdownTxt, Std.parseInt(ExptWideSpecs.IS("saveWaitDuration")));
		}
	
	}
	
	public function success(message:String) 
	{
		info.text = message;
		info.percentWidth = 100;
		icon.resource = ICONS.get('SUCCESS');
		stopCountdown();
		
	}
	
	public function fail(message:String, d:String) 
	{

		stopCountdown();
		
		popup.width = 680;
		popup.autoSize = true;
		
		info.text = message;
		info.autoSize = false;
		info.multiline = true;
		info.wrapLines = true;
		info.width = 650;
		info.height = 200;
		info.style.width = 100;
		
		info.style.fontSize = 18;
		//info.height = 200;
		info.selectable = true;
		icon.resource = ICONS.get('ERROR');
		
		var hbox:HBox = new  HBox();
		hbox.width = popup.width;
		hbox.height = 300;
		
		info.parent.parent.addChild(hbox);
		
		var tryAgain:Button = new Button();
		tryAgain.text = 'try to send data again?';
		tryAgain.horizontalAlign = 'left';
		tryAgain.autoSize = true;
		tryAgain.onClick = function(e) { tryAgain_callBack(); };	
		hbox.addChild(tryAgain);
		
		
		var downloadData:Button = new Button();
		downloadData.text = 'download your results and email them to us';
		downloadData.horizontalAlign = 'right';
		downloadData.alpha = .7;
		downloadData.autoSize = true;
		downloadData.onClick = function(e) { 
			SaveFile.prompt_user_to_save(message+"\n\n\n"+d,'experimentData_backup.txt');
		};
		
		hbox.addChild(downloadData);
		
		center();
	}
	
	function stopCountdown() 
	{
		if (countdown != null) countdown.kill();
		countdownTxt.dispose();
		countdown = null;
	}


	public function center() {
		var cx:Float = RootManager.instance.currentRoot.width;
		var cy:Float = RootManager.instance.currentRoot.height;
		
		popup.x = (cx - popup.width)*.5;
		popup.y = (cy - popup.height)*.5;
		
		popup.style.alpha = .85;
		popup.onMouseOver = function(e) {
			popup.style.alpha = 1;
		}
		popup.onMouseOut = function(e) {
			popup.style.alpha = .85;
		}
	}
	
	
}

class Countdown {
	var text:Text;
	var duration:Int;
	var t:Timer;
	

	public function kill() {
		t.stop();
		if(t.hasEventListener(TimerEvent.TIMER))	t.removeEventListener(TimerEvent.TIMER, timerL);
	}
	
	
	public function new(text:Text, d:Int) {
		this.text = text;
		this.duration = d;

		var repeats:Int = Std.int(duration / 1000);
		t = new Timer(1000, repeats);
		t.addEventListener(TimerEvent.TIMER, timerL);
		t.start();
		
	}
	
	private function timerL(e:TimerEvent):Void 
	{
		duration -= 1000;
		
		text.text = Std.string (duration/1000);
		
		
		if (duration == 0) {
			kill();
		}
	}
	
	
	
	public static function DO(text:Text, duration:Int):Countdown {
	
		return new Countdown(text, duration);
	}
	
	
}