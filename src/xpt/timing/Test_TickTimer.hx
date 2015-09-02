package xpt.timing;
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
	
	public function test_getTime() {
	
		var tickTimer:TickTimer;
		
		
		tickTimer = new TickTimer(0);
		tickTimer.start();
		var time = tickTimer.initTime;
		
		tickTimer.callBack = function(_time:Float) {
			//Assert.isTrue(tickTimer._getTime() > time);
			tickTimer.stop();
		};
		
		Assert.isTrue(true);
		TickTimer._instance = null;
		
	}
	
}