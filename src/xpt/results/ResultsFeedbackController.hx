package xpt.results;

import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.hscript.ScriptInterp;
import openfl.events.KeyboardEvent;
import xpt.experiment.Experiment;
import flash.events.TimerEvent;
import flash.utils.Timer;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/resultsFeedback-window.xml"))
class ResultsFeedbackController extends XMLController {
	private var ICONS:Map<String, String> = [
		"ERROR" => "img/icons/exclamation-red.png",
		"SUCCESS" => "img/icons/success.png"
	];
	
	var countdown:Countdown;
	

	public function new() {
		
		
		if (countdownTxt != null) countdown = Countdown.DO(countdownTxt, Std.parseInt(ExptWideSpecs.IS("saveWaitDuration")));
	
	}
	
	public function success(message:String) 
	{
		info.text = message;
		icon.resource = ICONS.get('SUCCESS');
		stopCountdown();
		
	}
	
	public function fail(message:String, d:String) 
	{

		popup.width = RootManager.instance.currentRoot.width * .8;
		popup.height = RootManager.instance.currentRoot.height * .8;
		
		
		
		info.text = message;
		info.percentWidth = 100;
		info.selectable = true;
		info.percentHeight = 30;
		icon.resource = ICONS.get('ERROR');
		stopCountdown();
		
		var data:Text = new Text();
		
		data.text = d;
		data.wrapLines = true;
		data.percentWidth = 100;
		data.percentHeight = 70;

		popup.addChild(data);
		vbox.height = 600;
		
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
		
		popup.style.alpha = .9;
		popup.onMouseOver = function(e) {
			popup.style.alpha = 1;
		}
		popup.onMouseOut = function(e) {
			popup.style.alpha = .9;
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