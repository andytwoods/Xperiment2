package xpt.trialOrder;

import utest.Assert;
import xpt.trialOrder.OrderType;
/**
 * ...
 * @author 
 */
class Test_DepthNode
{

	public function new() { }
	
	
	

	public function test_8_5():Void {
	
		var dn:DepthNode;
		
		dn = new DepthNode();
		
		
		//var ord:String = OrderType.FIXED;
		
		try{
			dn = new DepthNode();
			dn.init([],'');
			Assert.isTrue(false);
		}catch(e:String){}
		try{
			dn = new DepthNode();
			dn.init(["1"],'');
			Assert.isFalse(false);
		}catch (e:String) { }
	

		var ord:String = OrderType.FIXED;
		
		dn = new DepthNode();
		dn.init(["10"],ord);
		Assert.isTrue(dn.__kinderCount()==1);
		Assert.isTrue(dn.__combinedKinderCount() == 1);
		Assert.isTrue(as3_assist(dn,[10]) == ord);
		
		dn = new DepthNode();
		dn.init(['10','9','8'],ord);
		Assert.isTrue(dn.__kinderCount()==1);
		Assert.isTrue(dn.__combinedKinderCount()==3);
		Assert.isTrue(as3_assist(dn,[10,9,8])==ord);
		Assert.isTrue(as3_assist(dn,[10,9,8,7])==DepthNode.UNKNOWN);
		Assert.isTrue(as3_assist(dn,[10,9])==DepthNode.UNKNOWN);
		Assert.isTrue(as3_assist(dn,[10]) == DepthNode.UNKNOWN);
		
		dn = new DepthNode();
		dn.init(['10','9',"*"],ord);
		Assert.isTrue(dn.__combinedKinderCount()==3);
		Assert.isTrue(as3_assist(dn,[10,9,8])==ord);
		Assert.isTrue(as3_assist(dn,[10,9,1])==ord);
		Assert.isTrue(dn.__isWildCard(['10','9','1'])==true);
		Assert.isTrue(dn.__isWildCard(['10','9'])==false);
		Assert.isTrue(dn.__isWildCard(['10','9','1','1'])==false);
		
		dn = new DepthNode();
		dn.init(['10',"*",'8'],ord);
		Assert.isTrue(as3_assist(dn,[10,9,8])==ord);
		Assert.isTrue(as3_assist(dn, [10, 7, 8]) == ord);
		Assert.isTrue(as3_assist(dn, [10, 7, 2]) == DepthNode.UNKNOWN);
		Assert.isFalse(as3_assist(dn,[11,9,8])==ord);
		
		dn = new DepthNode();
		dn.init(["*",'8','4'],ord);
		Assert.isTrue(as3_assist(dn,[10,8,4])==ord);
		Assert.isTrue(as3_assist(dn,[1,8,4])==ord);
		Assert.isFalse(as3_assist(dn,[1,9,4])==ord);
		Assert.isFalse(as3_assist(dn,[1,8,3])==ord);
		
		dn = new DepthNode();
		dn.init(["*",'8',"*"],ord);
		Assert.isTrue(as3_assist(dn,[10,8,4])==ord);
		Assert.isTrue(as3_assist(dn,[1,8,4])==ord);
		Assert.isFalse(as3_assist(dn,[1,9,4])==ord);
		Assert.isFalse(as3_assist(dn,[1,7,3])==ord);
		
		dn = new DepthNode();
		dn.init(['9'],OrderType.FIXED);
		dn.init(['10'],OrderType.RANDOM);
		dn.init(['10',"*"],OrderType.FIXED);
		dn.init(['10',"*","*"],OrderType.RANDOM);

		Assert.isTrue(as3_assist(dn,[9])==OrderType.FIXED);
		Assert.isTrue(as3_assist(dn,[10])==OrderType.RANDOM);
		Assert.isTrue(as3_assist(dn,[10,3])==OrderType.FIXED);
		Assert.isTrue(as3_assist(dn,[10,4,4])==OrderType.RANDOM);
		Assert.isTrue(dn.__isWildCard(['10','4','4'])==true);
		Assert.isTrue(dn.__isWildCard(['10','4','4','4'])==false);
		Assert.isTrue(dn.__isWildCard(['10'])==false);
		
		dn = new DepthNode();
		dn.init(['9','2'],OrderType.FIXED);
		dn.init(['10','2','1'],OrderType.RANDOM);
		Assert.isTrue(as3_assist(dn,[9,2])==OrderType.FIXED);
		Assert.isTrue(as3_assist(dn,[10,2,1])==OrderType.RANDOM);
		
		dn = new DepthNode();
		dn.init(['9'],OrderType.FIXED);
		dn.init(['1','2'],OrderType.FIXED);
		dn.init(['1','2','3'],OrderType.FIXED);
		dn.init(['1','2','4'],OrderType.REVERSED);
		Assert.isTrue(as3_assist(dn,[9])==OrderType.FIXED);
		Assert.isTrue(as3_assist(dn,[1,2])==OrderType.FIXED);
		Assert.isTrue(as3_assist(dn,[1,2,3])==OrderType.FIXED);
		Assert.isTrue(as3_assist(dn,[1,2,4])==OrderType.REVERSED);
		dn.kill();
	}
	
	private function as3_assist(dn:DepthNode, arr:Array<Int>):String {
		
		var arrStr:Array<String> = [];
		for (num in arr) {
			arrStr[arrStr.length] = Std.string(num);
		}
		
		return dn.__retrieve(arrStr);
		
	}
	
}