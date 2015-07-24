package xpt.trialOrder;
import utest.Assert;



class Test_TrialBlock
{

	public function new() 
	{
		
	}
	
	
	public function test_getCount():Void {
	
		Assert.isTrue(1== TrialBlock.getCount(Xml.parse("<xml trials='1'/>")) );
		
		try {
			TrialBlock.getCount(Xml.parse("<xml trials='1.1'/>"));
			Assert.isTrue(false);
		}
		catch(msg:String) {
			Assert.isTrue(true);
		}
		
	}
	
	public function test_getNames():Void {
	
		var arr:Array<String>;
		
		arr = TrialBlock.getNames(Xml.parse("<xml trialName='a'/>"), 1,"trialName");
		Assert.isTrue(arr.length == 1 && arr[0] == "a");
		
		
		arr = TrialBlock.getNames(Xml.parse("<xml trialName='a;a'/>"), 2,"trialName");
		Assert.isTrue(arr.length == 2 && arr[0] == "a1" && arr[1] == "a2");
		
		arr = TrialBlock.getNames(Xml.parse("<xml trialName='a;b'/>"), 4,"trialName");
		Assert.isTrue(arr.length == 4 && arr[0] == "a1" && arr[1] == "b1" && arr[2] == "a2" && arr[3] == "b2");
		
	}
	
	public function test_getBlockDepthOrder():Void {
		var blockDepthOrder:Array<String> = TrialBlock.getBlockDepthOrder(Xml.parse("<xml blockDepthOrder='random,fixed'/>"));
		Assert.isTrue(blockDepthOrder[0] == OrderType.RANDOM && blockDepthOrder[1] == OrderType.FIXED); 
		
	}
	
/*	public function test_getForced():Void {
	
		TrialBlock.getForced(Xml.parse("<xml trialName='a'/>"));
		
		
	}*/
}