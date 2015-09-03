package xpt.timing;
import openfl.display.FPS;
import utest.Assert;

/**
 * ...
 * @author 
 */
class Test_TickTimer
{

	public function new() 
	{
		
	}
	
	public function _test_getTime() {
	
		var done = Assert.createAsync(200);		
		var ticks:Array<Float> = [];
		
		
		var tickTimer = new TickTimer(1);


		var init_time = tickTimer.initTime;
		
		var count:Int = 2;
		var prev:Float =-1; 
		
		tickTimer.callBack = function(_time:Float) {
			if (prev != -1 ) ticks[ticks.length] = _time -prev;
			prev = _time;
			
			Assert.isTrue(init_time < _time);
			
			if (count <= 1) {
				tickTimer.stop();
				//trace(ticks);
				done();
			}
			count--;	
		};	
		
		tickTimer.start();

		
	}
	
	
	
}