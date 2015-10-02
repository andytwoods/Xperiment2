package xpt;
import utest.Assert;
import xpt.ExptWideSpecs.GeneralInfo;
import xpt.ExptWideSpecs.MultipleKeysMap;
import xpt.tools.XML_tools;

/**
 * ...
 * @author 
 */
class Test_ExptWideSpecs
{

		
	public function new() { }

	
	public function test__IS() {
		ExptWideSpecs.set(null);
		ExptWideSpecs.__setStaticVars();
		ExptWideSpecs.special_turkInfo.__map.set("bla","bla");
		var turkInfo:Map<String,String> = ExptWideSpecs.IS("turkInfo");
		Assert.isTrue(turkInfo.get("bla")=="bla");
	}
	
	public function test_kill() {
		ExptWideSpecs.__setStaticVars();
		ExptWideSpecs.special_turkInfo.__map.set("bla","bla");
		ExptWideSpecs.kill();
		
		Assert.isTrue(ExptWideSpecs.special_turkInfo == null);
		
	}
	
	public function test_SpecialPropsClass() {
	
		var s:MultipleKeysMap = new MultipleKeysMap(["a,aa,aaa", "b"]);
		
		s.special_set("aa", "set");
		Assert.isTrue(s.special_get("a") == "set");
		Assert.isTrue(s.special_get("aa") == "set");
		Assert.isTrue(s.special_get("aaa") == "set");
		Assert.isTrue(s.special_get("b") == "");
		
	}
	
	public function test_GeneralInfoClass() {
	
		
		var xml:Xml = Xml.parse("<expt><SETUP><timing autoCloseTimer='100'/></SETUP></expt>");

		ExptWideSpecs.set(xml);

		var g:GeneralInfo = ExptWideSpecs.__generalInfo;

		Assert.isTrue(g.get("autoCloseTimer") == 100);
											//nb that additional space below after SETUP really was a pain!
		var xml:Xml = Xml.parse("<x><SETUP> <info autoCloseTimer='100' id='0a66f64fd9c648c3ae92889aa66040a0'/><bla workerId='123' mock='true'/></SETUP></x>");
		//trace("---------------------");
		ExptWideSpecs.set(xml);
		//trace("---------------------");
		var g:GeneralInfo = ExptWideSpecs.__generalInfo;
		
		Assert.isTrue(g.autoCloseTimer == 100);
		//Assert.isTrue(g.mock == true);
		
		//Assert.isTrue(ExptWideSpecs.IS("workerId")=='123');
	}
	
}