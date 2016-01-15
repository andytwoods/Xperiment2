package xpt.timing.managers;

#if delay
import com.imagination.delay.Delay;
#end
import xpt.timing.TimingManager.TimingEvent;

class DelayTimingManager extends BaseTimingManager {
	public function new() {
		super();
	}
	
	private override function addTimingEvent(start:Float, duration:Float, callback:TimingEvent->Void) {
		#if delay
		
		Delay.byTime(start, function() {
			callback(TimingEvent.SHOW);
			Delay.byTime(duration, function() {
				callback(TimingEvent.HIDE);
			}, null, Delay.TIME_UNIT_MILLISECONDS);
		}, null, Delay.TIME_UNIT_MILLISECONDS);
		
		#else
		throw "Delay haxelib not included";
		#end
	}
}