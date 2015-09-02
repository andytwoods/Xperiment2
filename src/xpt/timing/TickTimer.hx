package xpt.timing;
import haxe.Timer;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
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
	
	private var root:Root;
	
	public var callBack:Float -> Void;
	
	public static var _instance:TickTimer;
	
	public static function init(_interval:Int):TickTimer {
		if (_instance == null) {
			_instance = new TickTimer(_interval);
		}
		return _instance;
	}
		
	public function new(_interval:Int ) 
	{
		if (_instance != null) throw "devel error";
		interval=_interval;

		initTime = _getTime();
		trace(initTime);
	}
	
	public inline function _getTime():Float {
		return Timer.stamp() * 1000;
	}

		
	
	public function evaluateTime(e:Event) {
		
		if (running == true) {
			now = _getTime() - initTime;

			if(callBack != null) callBack(now);
		}
		
	}
	
	public function timeFromEnd():Float{
		return interval - timeFromStart;
	}
	
	
	
	public function start() {
		initTime = _getTime();
		running=true;
		listen(true);
	}
	
	public function reStart() {
		initTime = _getTime();
		initTime= initTime-pauseOffset;
		running=true;
		listen(true);
	}
	
	public function pause() {
		pauseOffset=now-initTime;
		running=false;
		listen(false);
	}
	
	public function stop() {
		running=false;
		listen(false);
	}
	
	public function reset() {
		__offset=0;
		running=false;
		listen(false);
		callBack=null;
	}
	
	
	
	function listen(ON:Bool) {
		if(root == null) root = RootManager.instance.currentRoot;
		
		if(ON)	root.addEventListener(Event.ENTER_FRAME,evaluateTime);
		else	root.removeEventListener(Event.ENTER_FRAME,evaluateTime);
	}
	
	public function _goto(t:Int)
	{
		throw 'not implemented yet';
		
	}
	
}