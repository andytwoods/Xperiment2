package xpt.tools;


import thx.Arrays;
import utest.Assert;
import xpt.tools.Shortcuts.PropVal;
import xpt.tools.Shortcuts.Shortcuts_Command;


class Test_Shortcuts
{

	public function new() 
	{
	}
	
	public function test_1() {
	
		var xml:Xml = Xml.parse("<a><b h1='a|b' h2='d' shuffle='def'><c shuffle='abc'/></b></a>");

		
		
	}

	
	public function test_Shortcuts_Command() {
	
		Shortcuts_Command.permitted = ["|","---"];
		var command:Shortcuts_Command = new Shortcuts_Command("a b c |");
		Assert.isTrue(Arrays.equals(command.properties(), ["a", "b", "c"]));
		
		var command:Shortcuts_Command = new Shortcuts_Command("a b | ---");
		Assert.isTrue(Arrays.equals(command.properties(), ["a","b"]));
		Assert.isTrue(Arrays.equals(command.splitBy_arr, ["|","---"]));
		
		var xml:Xml = Xml.parse("<x a='1' b='2'/>");
		command.gather_values(XML_tools.simpleXML(xml));
		
		var pv:PropVal = command.propVals[0];
		Assert.equals(pv.prop, 'a');
		Assert.equals(pv.val, '1');
		
		pv = command.propVals[1];
		Assert.equals(pv.prop, 'b');
		Assert.equals(pv.val, '2');
		
		Assert.equals(command.detect_split(["a", "b"], xml), null);
		Assert.equals(command.detect_split(["a|", "b"], xml), "|");
		Assert.equals(command.detect_split(["a", "b---"], xml), "---");
		try {
			command.detect_split(["a|", "b---"], xml);
			Assert.isTrue(false);
		}
		catch (e:String) {
			Assert.isTrue(true);
		}
		
	}
}

