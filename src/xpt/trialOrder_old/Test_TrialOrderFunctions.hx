package xpt.trialOrder_old;
import utest.Assert;
import xpt.trialOrder_old.components.blockOrder.DelMe;
import xpt.trialOrder_old.components.depthNode.DepthNode;



class Test_TrialOrderFunctions
{
	public function new() 
	{
		
	}
	
	public function test_DepthNode() {

		
		var d:DelMe;
	
		Assert.isTrue(true);
	

		var dn:DepthNode;
		
/*		var ord:String = TrialBlock.FIXED;
		
		try{
			dn = new DepthNode();
			dn.init([],'');
			Assert.isTrue(false);
		}catch(e:Error){}
		try{
			dn = new DepthNode();
			dn.init([1],'');
			Assert.isTrue(false);
		}catch(e:Error){}
		
		
		dn = new DepthNode();
		dn.init([10],ord);
		Assert.isTrue(dn.__kinderCount()==1);
		Assert.isTrue(dn.__combinedKinderCount()==1);
		Assert.isTrue(dn.__retrieve([10])==ord);
		
		dn = new DepthNode();
		dn.init([10,9,8],ord);
		Assert.isTrue(dn.__kinderCount()==1);
		Assert.isTrue(dn.__combinedKinderCount()==3);
		Assert.isTrue(dn.__retrieve([10,9,8])==ord);
		Assert.isTrue(dn.__retrieve([10,9,8,7])==DepthNode.UNKNOWN);
		Assert.isTrue(dn.__retrieve([10,9])==DepthNode.UNKNOWN);
		Assert.isTrue(dn.__retrieve([10])==DepthNode.UNKNOWN);
		
		dn = new DepthNode();
		dn.init([10,9,"*"],ord);
		Assert.isTrue(dn.__combinedKinderCount()==3);
		Assert.isTrue(dn.__retrieve([10,9,8])==ord);
		Assert.isTrue(dn.__retrieve([10,9,1])==ord);
		Assert.isTrue(dn.__isWildCard([10,9,1])==true);
		Assert.isTrue(dn.__isWildCard([10,9])==false);
		Assert.isTrue(dn.__isWildCard([10,9,1,1])==false);
		
		dn = new DepthNode();
		dn.init([10,"*",8],ord);
		Assert.isTrue(dn.__retrieve([10,9,8])==ord);
		Assert.isTrue(dn.__retrieve([10,7,8])==ord);
		assertFalse(dn.__retrieve([10,7,2])==ord);
		assertFalse(dn.__retrieve([11,9,8])==ord);
		
		dn = new DepthNode();
		dn.init(["*",8,4],ord);
		Assert.isTrue(dn.__retrieve([10,8,4])==ord);
		Assert.isTrue(dn.__retrieve([1,8,4])==ord);
		assertFalse(dn.__retrieve([1,9,4])==ord);
		assertFalse(dn.__retrieve([1,8,3])==ord);
		
		dn = new DepthNode();
		dn.init(["*",8,"*"],ord);
		Assert.isTrue(dn.__retrieve([10,8,4])==ord);
		Assert.isTrue(dn.__retrieve([1,8,4])==ord);
		assertFalse(dn.__retrieve([1,9,4])==ord);
		assertFalse(dn.__retrieve([1,7,3])==ord);
		
		dn = new DepthNode();
		dn.init([9],TrialBlock.FIXED);
		dn.init([10],TrialBlock.RANDOM);
		dn.init([10,"*"],TrialBlock.FIXED);
		dn.init([10,"*","*"],TrialBlock.RANDOM);*/
/*
		Assert.isTrue(dn.__retrieve([9])==TrialBlock.FIXED);
		Assert.isTrue(dn.__retrieve([10])==TrialBlock.RANDOM);
		Assert.isTrue(dn.__retrieve([10,3])==TrialBlock.FIXED);
		Assert.isTrue(dn.__retrieve([10,4,4])==TrialBlock.RANDOM);
		Assert.isTrue(dn.__isWildCard([10,4,4])==true);
		Assert.isTrue(dn.__isWildCard([10,4,4,4])==false);
		Assert.isTrue(dn.__isWildCard([10])==false);
		
		dn = new DepthNode();
		dn.init([9,2],TrialBlock.FIXED);
		dn.init([10,2,1],TrialBlock.RANDOM);
		Assert.isTrue(dn.__retrieve([9,2])==TrialBlock.FIXED);
		Assert.isTrue(dn.__retrieve([10,2,1])==TrialBlock.RANDOM);
		
		dn = new DepthNode();
		dn.init([9],TrialBlock.FIXED);
		dn.init([1,2],TrialBlock.FIXED);
		dn.init([1,2,3],TrialBlock.FIXED);
		dn.init([1,2,4],TrialBlock.REVERSE);
		Assert.isTrue(dn.__retrieve([9])==TrialBlock.FIXED);
		Assert.isTrue(dn.__retrieve([1,2])==TrialBlock.FIXED);
		Assert.isTrue(dn.__retrieve([1,2,3])==TrialBlock.FIXED);
		Assert.isTrue(dn.__retrieve([1,2,4])==TrialBlock.REVERSE);
		dn.kill();
		*/
	}
		
}