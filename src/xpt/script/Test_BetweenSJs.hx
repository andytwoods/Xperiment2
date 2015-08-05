package xpt.script;
import thx.Arrays;
import thx.Iterators;
import thx.Maps;
import utest.Assert;
import xpt.script.BetweenSJs.BetweenSJcond;
import xpt.tools.XTools;

/**
 * ...
 * @author 
 */
class Test_BetweenSJs
{

	public function new() 
	{
		
	}
	
	
	public function test_BetweenSJParams() {
	
		
		
		var xml:Xml = Xml.parse("<a/>");
		Assert.isTrue(BetweenSJs.continueCheck(xml) == false);
		
		
		xml = Xml.parse("<multi/>");
		Assert.isTrue(BetweenSJs.continueCheck(xml) == true);
		
		xml = Xml.parse("<multi><a><b/></a><a><b/></a></multi>");
		Assert.isTrue(BetweenSJs.continueCheck(xml) == true);
	}
	
	
	public static function test_BetweenSJcond() {
	
		var xml:Xml = Xml.parse("<a parent='b,c'/>");
		var b:BetweenSJcond = new BetweenSJcond(xml);
		
		Assert.isTrue(b.name == "a" && Arrays.equals(b.copyFrom, ["b", "c"]));
		
		
	}
	
	public static function test__getBetweenSJConds() {
	
		var script:Xml = Xml.parse("<boss><a/><b/>");
		
		var ignore:String = "boss";
		var map = BetweenSJs.getBetweenSJConds(script, ignore);
		
		Assert.isTrue(XTools.iteratorToArray(map.keys()).length == 2 && map.exists(ignore)==false);
	}
	
}