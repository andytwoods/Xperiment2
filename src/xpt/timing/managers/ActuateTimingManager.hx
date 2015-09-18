package xpt.timing.managers;

#if actuate
import motion.Actuate;
#end
import xpt.timing.TimingManager.TimingEvent;

class ActuateTimingManager extends BaseTimingManager {
	public function new() {
		super();
	}
	
	private override function addTimingEvent(start:Float, duration:Float, callback:TimingEvent->Void) {
		#if actuate
		
		Actuate.timer(start / 1000).onComplete(function() {
			callback(TimingEvent.SHOW);
			Actuate.timer(duration / 1000).onComplete(function() {
				callback(TimingEvent.HIDE);
			});
		});
		
		#else
		throw "Actuate haxelib not included";
		#end
	}
}