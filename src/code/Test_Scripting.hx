package code;
import code.CheckIsCode.RunCodeEvents;
import code.Scripting.ScriptBundle;
import utest.Assert;
import xpt.trial.Trial;

/**
 * ...
 * @author 
 */
class Test_Scripting
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
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla><setup/><code><![CDATA[myCode]]></code></bla>"), RunCodeEvents.BeforeFirstTrial) != null );
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla><mustBeSetup/><code>myCode</code></bla>"), RunCodeEvents.BeforeFirstTrial) == null);
		Assert.isTrue(CheckIsCode.DO(Xml.parse("<bla><mustBeSetup/><code>myCode</code></bla>"), RunCodeEvents.BeforeFirstTrial) == null);

	}
	
	public function test_seekScripts() {
	
		var t:Trial = new Trial(null);

		CheckIsCode.seekScripts(t, Xml.parse("<trial></trial>"));
		Assert.isTrue(t.codeStartTrial == null && t.codeEndTrial == null);
		

		CheckIsCode.seekScripts(t, Xml.parse("<trial><code>efdfd</code><drdfd/></trial>"));		
		Assert.isTrue(t.codeStartTrial != null && t.codeEndTrial == null);

		t.codeStartTrial = t.codeEndTrial = null;
		CheckIsCode.seekScripts(t, Xml.parse("<trial><drdfd/><drdfd/><code>efdfd</code></trial>"));		
		Assert.isTrue(t.codeStartTrial == null && t.codeEndTrial != null);
		
		
		t.codeStartTrial = t.codeEndTrial = null;
		CheckIsCode.seekScripts(t, Xml.parse("<trial><code><![CDATA[efdfd]]></code><drdfd/><drdfd/><code><![CDATA[efdfd1]]></code></trial>"));
		Assert.isTrue(t.codeStartTrial == "efdfd" && t.codeEndTrial == "efdfd1");
	}
	
	public function test_Scripting() {
	
		Scripting.init(null);
		Assert.isTrue(Scripting.bundles.length == 1);
		
		var b:ScriptBundle = Scripting.getBundle();
		Assert.isTrue(Scripting.bundles.length == 0);
		b.add('b', 'bb');
		Assert.isTrue(b.scriptEngine.variables.get('b') == 'bb');
		Scripting.returnBundle(b);
		Assert.isTrue(Scripting.bundles.length == 1);
		Assert.isTrue(b.scriptEngine.variables.exists('b') == false);
		
		b = Scripting.getBundle();
		var c:ScriptBundle = Scripting.getBundle();
		
		b.code = 'b';
		c.code = 'cc';
		
		Assert.isTrue(b.code != c.code);
		
		Scripting.returnBundle(b);
		Scripting.returnBundle(c);
		
		Assert.isTrue(Scripting.bundles.length == 2);
		
		
	}
}