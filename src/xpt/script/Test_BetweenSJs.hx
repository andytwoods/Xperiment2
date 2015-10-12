package xpt.script;
import thx.Arrays;
import thx.Iterators;
import thx.Maps;
import utest.Assert;
import xpt.script.BetweenSJs.Action;
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
		var b:BetweenSJs = new BetweenSJs();
		
		var xml:Xml = Xml.parse("<a/>");
		Assert.isTrue(b.continueCheck(xml) == false);
		
		
		xml = Xml.parse("<multi/>");
		Assert.isTrue(b.continueCheck(xml) == true);
		
		xml = Xml.parse("<multi><a><b/></a><a><b/></a></multi>");
		Assert.isTrue(b.continueCheck(xml) == true);
	}
	
	
	public function test_BetweenSJcond() {
	
		var xml:Xml = Xml.parse("<a parent='b,c'/>");
		var b:BetweenSJcond = new BetweenSJcond(xml,'a');
		
		Assert.isTrue(b.name == "a" && Arrays.equals(b.copyFrom, ["b", "c"]));
		
		
	}
	
	public function test__getBetweenSJConds() {
	
		var script:Xml = Xml.parse("<parent><boss/><a/><b/></parent>");
		var b:BetweenSJs = new BetweenSJs();
		
		var ignore:String = "boss";
		var map = b.getBetweenSJConds(script, ignore);
		
		Assert.isTrue(XTools.iteratorToArray(map.keys()).length == 2 && map.exists(ignore) == false);
		Assert.isTrue(map.get("a").xml != null && map.get("b").xml != null);

		var script:Xml = getScript();
		map = b.getBetweenSJConds(script, ignore);
		
		
		Assert.isTrue(XTools.iteratorToArray(map.keys()).length == 4);
		
	}
	

	
	
	public function test__applyParentConditions() {
		var script:Xml = getScript();
		var parent:Xml = script.firstChild();
		var condition:BetweenSJcond;
		var b:BetweenSJs = new BetweenSJs();
		var betweenSJMap:Map<String, BetweenSJcond> = b.getBetweenSJConds(script, parent.firstChild().nodeName);
		
		for (condNam in betweenSJMap.keys() ) {
			condition =  betweenSJMap.get(condNam);
			b.__applyParentConditions(condNam, condition, betweenSJMap);
		}
		
		Assert.isTrue(betweenSJMap.get("cond1").xml.toString()=="<cond1 parent=\"cond2\" bla=\"2\"><blabla d=\"4\">23<a/></blabla></cond1>");
	}
	
		
	public function test____Action() {
	
		var xml:Xml = Xml.parse("<a aa='aaa'><b>c</b></a>");
		
		var action:Action = new Action(xml.firstElement());
		
		Assert.isTrue(action.name == 'a');
		
		var arr:Array<Xml> = XTools.iteratorToArray(action.children);
		Assert.isTrue(arr.length == 1);
		Assert.isTrue(arr[0].nodeName == "b");
		
		var expt:Xml = Xml.parse("<trials t='tt'><stim stima='aab'/></trials>");
		var action:Action = new Action(expt.firstChild());
		Assert.isTrue(action.name == "trials");
		
		
	}
	
	public function test____applyToParent() {
	
		var parent:Xml = Xml.parse("<boss boss1='true'><setup setup1='1'/><TRIAL trials='3' multiId='trials'/><stim peg='123' multiId='stim'/></boss>");
		//var expt:Xml = Xml.parse("<expt><trials t='tt'><a/></trials><stim stima='aab'/></expt>");
		var expt:Xml = Xml.parse("<expt><trials t='tt'><a/></trials><stim s='s'/></expt>");
		var b:BetweenSJs = new BetweenSJs();
		var result:Xml = b.__applyToParent(parent, expt);
		
		Assert.isTrue(result.toString()=="<boss boss1=\"true\"><setup setup1=\"1\"/><TRIAL trials=\"3\" multiId=\"trials\" t=\"tt\"><a/></TRIAL><stim peg=\"123\" multiId=\"stim\" s=\"s\"/></boss>");
		

		parent = Xml.parse("<boss boss1='true'><setup setup1='1'/><TRIAL trials='3' multiId='trials'/><stim peg='123' multiId='stim'/></boss>");
		//var expt:Xml = Xml.parse("<expt><trials t='tt'><a/></trials><stim stima='aab'/></expt>");
		var expt:Xml = Xml.parse("<expt><stim s='s'/><trials t='tt'><a/></trials></expt>");
		var result:Xml = b.__applyToParent(parent, expt);
		Assert.isTrue(result.toString()=="<boss boss1=\"true\"><setup setup1=\"1\"/><TRIAL trials=\"3\" multiId=\"trials\" t=\"tt\"><a/></TRIAL><stim peg=\"123\" multiId=\"stim\" s=\"s\"/></boss>");
	}
	
	private inline function getScript():Xml {
		return Xml.parse("<multi><boss boss1='true'><setup setup1='1'/><TRIAL trials='3'><stim peg='123'/></TRIAL></boss><a/><b/><cond1 parent='cond2'></cond1><cond2 bla='2'><blabla d='4'>23<a/></blabla></cond2></multi>");
	}
	
	
	public function test_compose() {
		var b:BetweenSJs = new BetweenSJs();
		
		var script:Xml = Xml.parse("<multi><boss boss1='true'><setup setup1='1'/><TRIAL trials='3' multiId='trials'/><stim peg='123' multiId='stim'/></boss><expt1><stim s='s'/><trials t='tt'><a/></trials></expt1><expt2><stim s='s'/><trials t='tt'><a/></trials></expt2></multi>");
			
		script = b.compose(script,'expt1');

		Assert.isTrue(script.toString() == "<boss boss1=\"true\"><setup setup1=\"1\"/><TRIAL trials=\"3\" multiId=\"trials\" t=\"tt\"><a/></TRIAL><stim peg=\"123\" multiId=\"stim\" s=\"s\"/></boss>");
		
	}
	
}