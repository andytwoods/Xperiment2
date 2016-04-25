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
		Shortcuts_Command.permitted = ["|","---"];
		var xml:Xml = Xml.parse("<a><b d='1|2|3' e='1' f='5|6' SHUFFLE='d e f'><c/></b></a>");

		XRandom.setSeed("1");
		
		Shortcuts.instance.experiment_wide(xml);
		Assert.equals(xml.firstElement().firstElement().get('d'), "2|3|1");
		Assert.equals(xml.firstElement().firstElement().get('e'), "1|1|1");
		Assert.equals(xml.firstElement().firstElement().get('f'), "6|5|5");

		var xml:Xml = Xml.parse("<a><b d='1|2|3' e='1' SHUFFLE='d e banana.f'><c id='banana' f='5|6'/></b></a>");	
		Shortcuts.instance.experiment_wide(xml);
		Assert.equals(xml.firstElement().firstElement().get('d'), "1|3|2");
		Assert.equals(xml.firstElement().firstElement().get('e'), "1|1|1");
		
		var test_xml = XTools.iteratorToArray(XML_tools.findNode(xml, 'c'));
		Assert.equals(test_xml[0].get('f'), '5|5|6');
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
	
		
		pv.val = "a|b---d|e---f";
		pv.doSplit(["---", "|"]);
		Assert.equals(pv.primary_len, 3);
		Assert.equals(pv.secondary_len, 2);
		
		pv.expandVal(4, 3, ["---", "|"]);
		Assert.equals(Std.string(pv.val_split),'[a|b|a,d|e|d,f|f|f,a|b|a]');
		
		
		Assert.equals(pv._secondary_order('a---b---c', [2, 1, 0], '---'), 'c---b---a');
		
		pv.val_split = ["a","b","c"];
		pv.primary_order([2, 1, 0]);
		Assert.isTrue(Arrays.equals(pv.val_split, ["c", "b", "a"]));

		
	}
	

	
}

