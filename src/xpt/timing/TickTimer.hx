package xpt.timing;
import haxe.Timer;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import openfl.display.FPS;
import openfl.events.Event;
import haxe.ui.toolkit.core.Toolkit;

/**
 * ...
 * @author 
 */
class TickTimer
{
	
	public var interval:Float;
	public var repeatCount:Int = 2147483647;
	public var initTime:Float = 0;
	
	//public var currentMS:Float=-1;
	public var __offset:Float=0;
	public var running:Bool=false;
	public var timeFromStart:Float=0;
	public var timeShouldBe:Float=0;
	public var now:Float;
	private var msDiff:Float;
	private var pauseOffset:Float;
	
	public var _root:Root;
	
	public var callBack:Float -> Void;
	
		
	public function new(_interval:Int ) 
	{
		_root = RootManager.instance.currentRoot;
		listen(true);
		interval = _interval;
	}
	
	public inline function _getTime():Float {
		return Timer.stamp() * 1000;
	}
	
	public function timeFromEnd():Float{
		return interval - timeFromStart;
	}
	
	public function start() {
		initTime = _getTime();
		running=true;
		
	}
	
	public function reStart() {
		initTime = _getTime();
		initTime= initTime-pauseOffset;
		running=true;
	}
	
	public function pause() {
		pauseOffset=now-initTime;
		running=false;
	}
	
	public function stop() {
		running=false;
	}
	
	public function reset() {
		__offset=0;
		running=false;
		callBack=null;
	}
	
	
	
	public function listen(ON:Bool) {
		if (_root == null) {
			//
		}
		else{
			if(ON)	_root.addEventListener(Event.ENTER_FRAME,evaluateTime);
			else	_root.removeEventListener(Event.ENTER_FRAME, evaluateTime);
		}
	}
	
	
	public inline function evaluateTime(e:Event) {

		if (running == true) {
			now = _getTime() - initTime;
			if(callBack != null) callBack(now);
		}	
	}

}