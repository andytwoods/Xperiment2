package xpt.stimuli.all;
import utest.Assert;
import xpt.stimuli.BaseStimuli.BaseStimulus;
import xpt.tools.XTools;

/**
 * ...
 * @author 
 */
class Test_BaseStimuli
{

	public function new() { }

	public function test__composeBaseStim() {
	
		
		BaseStimuli.setPermittedStimuli("bob,child1".split(","));
		

		var xml:Xml = Xml.parse("<bob><child1><child2child2>cccc</child2child2></child1><child2>cc</child2>bla</bob>");
		
		var baseStim:BaseStimulus = BaseStimuli._composeBaseStim("bob", xml, 1);
		
	
		Assert.isTrue(baseStim.children.length == 1);
		Assert.isTrue(baseStim.children[0].name == "child1");
		Assert.isTrue(baseStim.name == "bob");
		Assert.isTrue(baseStim.props.get("child2") == "cc");
		Assert.isTrue(baseStim.children[0].props.get("child2child2") == "cccc");		
	}
	
}