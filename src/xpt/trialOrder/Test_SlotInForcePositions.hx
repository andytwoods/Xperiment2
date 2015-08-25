package xpt.trialOrder;

import utest.Assert;

class Test_SlotInForcePositions
{

	public function new() 
	{
		
	}
	
	public function test_10() {
		Assert.isTrue(SlotInForcePositions.getPosition("1",5)==0);
		Assert.isTrue(SlotInForcePositions.getPosition("6", 5) == 5);
		Assert.isTrue(SlotInForcePositions.getPosition("first",5)==0);
		Assert.isTrue(SlotInForcePositions.getPosition("last",5)==5);
		Assert.isTrue(SlotInForcePositions.getPosition("center",5)==3);
		Assert.isTrue(SlotInForcePositions.getPosition("center+1",5)==4);
		Assert.isTrue(SlotInForcePositions.getPosition("1/2", 5) == 3);
		Assert.isTrue(SlotInForcePositions.getPosition("1/4",8)==2);	
	}
	
	public function test11()
		{
			
			function f(arr:Array<Int>,arr2:Array<Int>):Bool{
				if(arr.length!=arr2.length)return false;
				for (i in 0 ... arr.length){
					if(arr[i]!=arr2[i])return false;
				}
				return true;
			}
			
			Assert.isTrue(
				f(SlotInForcePositions.__addTrials(
					[0, 1, 2, 3, 4, 5, 6], 2, [99, 98, 97]),
					[0, 1, 99, 98, 97, 2, 3, 4, 5, 6])
				);

		}
		
	
}

