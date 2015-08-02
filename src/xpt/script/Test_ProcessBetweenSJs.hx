package xpt.script;
import utest.Assert;
import xpt.script.ProcessBetweenSJs.BetweenSJParams;

/**
 * ...
 * @author 
 */
class Test_ProcessBetweenSJs
{

	public function new() 
	{
		
	}
	
	
	public function test_BetweenSJParams() {
	
		
		
		var xml:Xml = Xml.parse("<a/>");
		Assert.isTrue(BetweenSJParams.check(xml) == null);
		
		
		xml = Xml.parse("<multi/>");
		Assert.isTrue(BetweenSJParams.check(xml) != null);
		
		xml = Xml.parse("<multi><a><b/></a><a><b/></a></multi>");
		Assert.isTrue(BetweenSJParams.check(xml) != null);
	}
	
}