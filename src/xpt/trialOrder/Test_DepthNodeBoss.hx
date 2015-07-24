package xpt.trialOrder;

import utest.Assert;
import xpt.trialOrder.DepthNodeBoss;
import xpt.trialOrder.OrderType;

class Test_DepthNodeBoss
{

	public function new() 
	{
		
	}
	

	public function test8() 
	{
		
		var dnb:DepthNodeBoss = new DepthNodeBoss("9=fixed 10=random 10,*=fixed 10,*,*=random");
		Assert.isTrue(dnb.retrieve("9.1")== DepthNode.UNKNOWN);
		Assert.isTrue(dnb.retrieve("9")== OrderType.FIXED);
		Assert.isTrue(dnb.retrieve("10")== OrderType.RANDOM);
		Assert.isTrue(dnb.retrieve("10 1")== OrderType.FIXED);
		Assert.isTrue(dnb.retrieve("10 5 0")== OrderType.RANDOM);
	
		dnb = new DepthNodeBoss("9=fixed 1,2=fixed 1,2,3=fixed 1,2,4=reversed");
		Assert.isTrue(dnb.retrieve("1 2")== OrderType.FIXED);
		Assert.isTrue(dnb.retrieve("1 2 3")== OrderType.FIXED);
		Assert.isTrue(dnb.retrieve("1 2 4")== OrderType.REVERSED);
		
		dnb.kill();
	}
	
}