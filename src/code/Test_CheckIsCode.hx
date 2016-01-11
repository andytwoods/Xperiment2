package code;
import code.CheckIsCode.RunCodeEvents;
import utest.Assert;

/**
 * ...
 * @author 
 */
class Test_CheckIsCode
{

	public function new() 
	{
	}
	
	
	public function test_beforeEverything() {
	
		
		Assert.isTrue(Scripting.DO(null, RunCodeEvents.BeforeEverything) == null);

		var xml:Xml;
		
		xml = Xml.parse("<bla/>");
		Assert.isTrue(Scripting.DO(xml,RunCodeEvents.BeforeEverything) == null);
		
		xml = Xml.parse("<code>myCode</code><bla/>");

		Assert.isTrue(Scripting.DO(xml, RunCodeEvents.BeforeEverything) != null);
		Assert.isTrue(CheckIsCode.DO(xml, RunCodeEvents.BeforeFirstTrial) == null);
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla/>"), RunCodeEvents.BeforeFirstTrial) == null);
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla/><code>myCode</code>"), RunCodeEvents.BeforeFirstTrial) == null);
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla><code>myCode</code></bla>"), RunCodeEvents.BeforeFirstTrial) == null);
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla><setup/><code>myCode</code></bla>"), RunCodeEvents.BeforeFirstTrial) != null );
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla><mustBeSetup/><code>myCode</code></bla>"), RunCodeEvents.BeforeFirstTrial) == null);

	}
}