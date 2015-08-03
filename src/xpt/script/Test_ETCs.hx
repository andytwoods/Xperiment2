package xpt.script;
import utest.Assert;

using xpt.tools.XML_tools;
/**
 * ...
 * @author 
 */
class Test_ETCs
{

	public function new() 
	{
		
		
		
	}
	
	public function test__getIterate() {
		
		var xml:Xml = Xml.parse("<a trials='3'><b howMany='2'/></a>");
		
		var b:Xml = xml.findNode('b').next();
		Assert.isTrue(3 == ETCs.__getIterate(b, ";;;etc;;;") );
		Assert.isTrue(2== ETCs.__getIterate(b, "---etc---") );
		
		xml = Xml.parse("<a trials='3'><b etcHowMany='5' howMany='2'/></a>");
		b = xml.findNode('b').next();
		Assert.isTrue(5 == ETCs.__getIterate(b, ";;;etc;;;") );
		Assert.isTrue(5 == ETCs.__getIterate(b, "---etc---") );
	}
	
}