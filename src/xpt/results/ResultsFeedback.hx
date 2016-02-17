package xpt.results;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import haxe.ui.toolkit.controls.popups.Popup;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.PopupManager;
import haxe.ui.toolkit.core.PopupManager.PopupButton;
import haxe.ui.toolkit.core.RootManager;
import xpt.results.ResultsFeedback.Countdown;
import xpt.tools.XTools;




class ResultsFeedback
{

	private static var _instance:ResultsFeedback;
    public static var instance(get, null):ResultsFeedback;
    private static function get_instance():ResultsFeedback {
        if (_instance == null) {
            _instance = new ResultsFeedback();
        }
        return _instance;
    }
	
	
	public function success(success:Bool) 
	{
		//saveSuccessMessage
		//saveFailMessage
		trace(success);
		if (animation != null) animation.kill();

	}
	
	private var feedbackWindow:Popup;
	private var text:Text;
	private var animation:Countdown;
	public function new() 
	{

		
		RootManager.instance.currentRoot.addEventListener(Event.ADDED, _onAddedToStage);

		var config = {
			buttons: PopupButton.CLOSE,
			modal: true,
		};
		feedbackWindow = PopupManager.instance.showSimple("Attempting...", "Saving your results",
			{ buttons: [PopupButton.OK, PopupButton.CANCEL] },
			function(btn:Dynamic) {
				if (Std.is(btn, Int)) {
					switch(btn) {
						case PopupButton.OK: trace("OK");
						case PopupButton.CANCEL: trace("CANCEL");
					}
				}
			} 
		);
		
		
		for (child in feedbackWindow.content.children) {
				if (Std.is(child, Text)) {
					text = cast(child, Text);
					break;
				}
		}
		
		
		if (text != null) animation = Countdown.DO(text, Std.parseInt(ExptWideSpecs.IS("saveWaitDuration")));

		
		var cx:Float = RootManager.instance.currentRoot.width;
		var cy:Float = RootManager.instance.currentRoot.height;
		
		feedbackWindow.x = (cx - feedbackWindow.width)*.5;
		feedbackWindow.y = (cy - feedbackWindow.height)*.5;
		
		feedbackWindow.style.alpha = .9;
		feedbackWindow.onMouseOver = function(e) {
			feedbackWindow.style.alpha = 1;
		}
		feedbackWindow.onMouseOut = function(e) {
			feedbackWindow.style.alpha = .9;
		}
	}
	

	
	private function _onAddedToStage(event:Event) {
		RootManager.instance.currentRoot.addChild(feedbackWindow);
	}
	
	public function show() {
		//nothing needed here as we have a getter for instance that generates an instance and adds it to screen if it is not there already.
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