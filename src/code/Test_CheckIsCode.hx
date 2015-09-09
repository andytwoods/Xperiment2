package code;
import code.CheckIsCode.Checks;
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
	
		
		Assert.isTrue(Code.DO(null, Checks.BeforeEverything) == null);

		var xml:Xml;
		
		xml = Xml.parse("<bla/>");
		Assert.isTrue(Code.DO(xml,Checks.BeforeEverything) == null);
		
		xml = Xml.parse("<code/><bla/>");
		Assert.isTrue(Code.DO(xml, Checks.BeforeEverything) != null);
		
		Assert.isTrue(CheckIsCode.DO(xml, Checks.BeforeFirstTrial) == null);
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla/>"), Checks.BeforeFirstTrial) == null);
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla/><code/>"), Checks.BeforeFirstTrial) == null);
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla><code/></bla>"), Checks.BeforeFirstTrial) == null);
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla><setup/><code/></bla>"), Checks.BeforeFirstTrial) != null );
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla><mustBeSetup/><code/></bla>"), Checks.BeforeFirstTrial) == null);
	}
}