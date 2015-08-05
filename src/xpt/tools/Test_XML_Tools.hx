package xpt.tools;
import utest.Assert;
import xpt.tools.XML_tools;

/**
 * ...
 * @author 
 */
class Test_XML_Tools
{

public function new() { }
	


	public function test_find() {
		
		
		//just attrib
		var xml:Xml = Xml.parse("<xml><a></a><b></b><c></c></xml>");
		
		var result:Iterator<Xml> = XML_tools.find(xml, "attrib1");
		Assert.isFalse(result.hasNext());
		
		xml = Xml.parse("<xml><a></a><b attrib1='123'></b><c></c></xml>");
		result = XML_tools.find(xml, "attrib1");
		Assert.isTrue(len(result) == 1);
		
		xml = Xml.parse("<xml><a></a><b attrib1='123'></b><c attrib1='123'></c></xml>");
		result = XML_tools.find(xml, "attrib1");
		Assert.isTrue(len(result) == 2);
		
		xml = Xml.parse("<xml attrib1='123'><a></a><b attrib1='123'></b><c ><d attrib1='123'></d></c></xml>");
		result = XML_tools.find(xml, "attrib1");
		Assert.isTrue(len(result) == 3);
		
		
		
		//attrib and value
		xml = Xml.parse("<xml attrib1='123'><a></a><b attrib1='123'></b><c ><d attrib1='123'></d></c></xml>");
		result = XML_tools.find(xml, "attrib1","123");
		Assert.isTrue(len(result) == 3);
		
		//just value
		xml = Xml.parse("<xml attrib1='123'><a></a><b attrib1='123'></b><c ><d attrib1='123'></d></c></xml>");
		result = XML_tools.find(xml, null,"123");
		
		Assert.isTrue(len(result) == 3);
		
		xml = Xml.parse("<xml attrib1='123'><b attrib1='123'></b><c ><d attrib1='123'><a attrib1='123' /></d></c></xml>");
		var result = XML_tools.find(xml, "attrib1");
		Assert.isTrue(len(result) == 4);
				
	}
	
	public function test_findNodes() {
		
		var xml:Xml = Xml.parse("<xml><TRIAL><TRIAL></TRIAL></TRIAL><TRIAL></TRIAL></xml>");
		var result = XML_tools.findNode(xml, "TRIAL");
		Assert.isTrue(len(result)==3);
		
	}
	
	public function test_modifyAttrib() {
		
		//change value
		var xml:Xml = Xml.parse("<xml a='a'/>");
		var result:Xml = XML_tools.modifyAttrib(xml, "a", "b");
	
		Assert.isTrue(result.firstChild().get("a").toString() == "b");
		
		
		//addValue
		var result:Xml = XML_tools.modifyAttrib(result, "aa", "bb");
		Assert.isTrue(result.firstChild().get("aa").toString() == "bb");
		
		//deleteValue
		var result:Xml = XML_tools.delAttrib(result, "aa");
		Assert.isTrue(result.firstChild().exists("aa") == false);
	}
	
	
	public function test_many_modifyAttrib() {
		var xml = Xml.parse("<xml attrib1='123'><a></a><b attrib1='123'></b><c ><d attrib1='123'></d></c></xml>");
		var result:Iterator<Xml>  = XML_tools.find(xml, "attrib1");
		
		result = XML_tools.many_modifyAttrib(result, "attrib1", "banana");
		
		var count:Int = 0;
		for (xml in result) {
				var val:String = XML_tools.simpleXML(xml).get("attrib1");
				Assert.isTrue(val == "banana");
				count++;
		}
	
		Assert.isTrue(count == 3);
	}
	
	
	
	private function len(iterator:Iterator<Xml>):Int {
		var arr = [];
		
		var i:Int = 0;
		for (x in iterator) {
			i++;
			arr.push(x);
		}
	
		iterator = arr.iterator();
		return i;
	}
	
	
	public function test_extendAttribs():Void {
	
		var xml1:Xml = Xml.parse("<xml a='a' b='2'><a/></xml>");
		var xml2:Xml = Xml.parse("<xml c='3' d='4'/>");
		
		var result:Xml = XML_tools.extendAttribs(xml1, xml2);
		
		Assert.isTrue(result.exists("c") && 
				result.exists("d") && 
				result.get("c").toString() == "3" && 
				result.get("d").toString() =="4");
		
		
	}
	
	public function test_iteratorToMap():Void {
		
		var a = Xml.parse("<xml a='a'/>");
		var b = Xml.parse("<xml a='b'/>");
		var c = Xml.parse("<xml a='c'/>");
		
		var iterator:Iterator<Xml> = [	a, b, c	].iterator();
		
		var map:Map<String, Xml> = XML_tools.iteratorToMap(iterator,'a');
		
		Assert.isTrue(map.exists("a") && map.exists("b") && map.exists("c") &&
			map.get("a") == a && map.get("b") == b && map.get("c") == c
		);
		
	}
	
	
	public function test_extendXML():Void {
		
		
		var id:String = "copyOverId";
		
		var xml1:Xml = Xml.parse("<xml a='a' b='2'><a copyOverId='a' a='1' /><b copyOverId='b' a='1' /> <c                a='1' /> </xml> ");
		var xml2:Xml = Xml.parse("<xml a='a' b='2'><a copyOverId='a' a='wrong' aa='1'/><b copyOverId='b' aa='1'/> <c copyOverId='b' aa='1'/><banana b='bbb'/> </xml> ");
		
		var result:Xml = XML_tools.extendXML(xml1, xml2, id);
		
		var arr:Array<Xml> = [];
		for (child in result.elements()) {
			arr[arr.length] = child;	
		}

		Assert.isTrue(arr.length == 4 &&
			arr[0].toString() == '<a copyOverId="a" a="1" aa="1"/>' &&  //modified and 'a' not modified
			arr[1].toString() == '<b copyOverId="b" a="1" aa="1"/>' &&  //modified
			arr[2].toString() == '<c a="1"/>' &&						//should be unmodified
			arr[3].toString() == '<banana b="bbb"/>' 					//should be unmodified
		
		);
	}
	
	public function test_findVal():Void {
		
		
		var xml1:Xml = Xml.parse("<xml a='a' b='2'><a copyOverId='a' a='1' /><b copyOverId='b' a='1' /> <c                a='1' ><d d='' /></c></xml> ");
		
		var arr:Array<String> = ['a','b'];
		
		var map:Map<String, Array<Xml>> = XML_tools.find_val(xml1, arr);
		
		Assert.isTrue(map.exists("a") && map.exists("b"));
		
		var a:Array<Xml> = map.get("a");
		var b:Array<Xml> = map.get("b");
		
		Assert.isTrue(a.length==4 && b.length==1);
	}
	
	
		public function test_find_inVal():Void {
		
		
		var xml1:Xml = Xml.parse("<xml a='aa[]aetcaa' b='2'><a copyOverId='a' a='1' /><b copyOverId='aaaaetca' a='1'><c bbb='etc'/></b> <c a='1' ><d d='' /></c></xml> ");
		
		var arr:Array<String> = ['etc'];
		
		var map:Map<String, Array<NodesWithFilteredAttribs>>  = XML_tools.find_inVal(xml1, arr);
		
		Assert.isTrue(map.exists("etc"));
		
		
		
		Assert.isTrue(map.get("etc").length == 3);
		
		var nodeA:NodesWithFilteredAttribs = map.get("etc")[0];
		var nodeB:NodesWithFilteredAttribs = map.get("etc")[1];
		var nodeC:NodesWithFilteredAttribs = map.get("etc")[2];
		
		Assert.isTrue(nodeA.attribName == "a" && nodeA.attribVal=="aa[]aetcaa");
		Assert.isTrue(nodeB.attribName=="copyOverId" && nodeB.attribVal=="aaaaetca");
		Assert.isTrue(nodeC.attribName=="bbb" && nodeC.attribVal=="etc");
	}


	public function test_flatten():Void {
		
		var protected:Array<String> = ['c'];
		var xml:Xml;
		var result:Xml;
		
		xml= Xml.parse("<xml a='a' b='2'><a>aa</a><b>aa</b></xml>");
		result = XML_tools.flatten(xml, protected);
		Assert.isTrue(result.toString() == "<xml a=\"aa\" b=\"aa\"/>"); //=<xml a="aa" b="aa"/>
				
		
		xml = Xml.parse("<xml a='a' b='2'>aaa<a>aa</a><b>aa</b></xml>");
		result = XML_tools.flatten(xml, protected);
		Assert.isTrue(result.toString() == "<xml a=\"aa\" b=\"aa\">aaa</xml>"); //=<xml a="aa" b="aa">aaa</xml>
		
	
		xml = Xml.parse("<xml a='a' b='2'>bla<a>aa</a><a1>aa</a1></xml>");
		result = XML_tools.flatten(xml, protected);
		Assert.isTrue(result.toString() == "<xml a=\"aa\" b=\"2\" a1=\"aa\">bla</xml>"); //=<xml a="aa" b="2" a1="aa">bla</xml>
		
	
		xml = Xml.parse("<xml a='a' b='2'>bla<a>aa</a><c>aa</c></xml>");
		result = XML_tools.flatten(xml, protected);
		Assert.isTrue(result.toString() == "<xml a=\"aa\" b=\"2\">bla<c>aa</c></xml>"); //=<xml a="aa" b="2">bla<c>aa</c></xml>
		
		
		xml = Xml.parse("<xml a='a' b='2'>bla<a>aa</a><c>aa<banana>bananaVal</banana></c></xml>");
		result = XML_tools.flatten(xml, protected);
		Assert.isTrue(result.toString() == "<xml a=\"aa\" b=\"2\">bla<c banana=\"bananaVal\">aa</c></xml>"); //=<xml a="aa" b="2">bla<c banana="bananaVal">aa</c></xml>
		
		
		xml = Xml.parse("<xml a='a' b='2'>bla<a>aa</a><c>aa<banana>bananaVal</banana><c>aa<banana>bananaVal</banana></c></c></xml>");
		result = XML_tools.flatten(xml, protected);
		Assert.isTrue(result.toString() == "<xml a=\"aa\" b=\"2\">bla<c banana=\"bananaVal\">aa<c banana=\"bananaVal\">aa</c></c></xml>"); //=<xml a="aa" b="2">bla<c banana="bananaVal">aa<c banana="bananaVal">aa</c></c></xml>
		
		
		xml= Xml.parse("<xml a='a' b='2'><a>aa</a><b></b></xml>");
		result = XML_tools.flatten(xml, protected);
		Assert.isTrue(result.toString() == "<xml a=\"aa\" b=\"\"/>"); //=<xml a="aa" b="aa"/>
		
		
		xml = Xml.parse("<xml a='a' b='2'>aaa<a>aa</a><b err='true'>aa</b></xml>");
		try {
			result = XML_tools.flatten(xml, protected);
			Assert.isTrue(false);
		} 
		catch (msg:String) {
			Assert.isTrue(true);
		}
		
		
		xml = Xml.parse("<xml a='a' b='2'>bla<a>aa</a><c>aa<banana>bananaVal<banana>bananaVal</banana></banana></c></xml>");
		try {
			result = XML_tools.flatten(xml, protected);
			Assert.isTrue(false);
		}
		catch (msg:String) {
			Assert.isTrue(true);
		}
		
		
		
	
	}
	
	public function test_AttribsToMap() {
		
		var myTest = function(x:Map<String,String>, map:Map<String,String>):Bool {
			
			for (key in x.keys()) {
				if (map.exists(key) == false) return false;
				if (x.get(key) != map.get(key)) return false;
				x.remove(key);
				map.remove(key);
			}
			for (key in map.keys()) {
				return false; //should be none left!
			}
			
			
			return true;
		}
		
	
		var xml = Xml.parse("<xml a='a' b='2'><a>aa</a><b></b></xml>");
		var result = XML_tools.AttribsToMap(xml);
		
		Assert.isTrue( myTest(result, ["a"=>"a", "b"=>"2"]) );
		
		
	}
	
	public function test_findAttr():Void {
	
		var xml = Xml.parse("<xml a='a' b='2'><a>aa</a><b></b></xml>");
		var result = XML_tools.findAttr(xml, "a");

		Assert.isTrue(result == "a");
		
		xml = Xml.parse("<xml a='a' b='2'><a a='b'>aa</a><b></b></xml>");
		result = XML_tools.findAttr(xml, "a");

		Assert.isTrue(result == "a");
		
		xml = Xml.parse("<TRIAL block='20' trials='4' order='fixed' trialName='v'><testStim test='a; b; c; d'/></TRIAL>");
		result = XML_tools.findAttr(xml, "block");
		Assert.isTrue(result == "20");

		xml = Xml.parse("<TRIAL block='20' order='fixed' trials='1'  trialName='v'><d></d></TRIAL>");
		result = XML_tools.findAttr(xml, "block");
		Assert.isTrue(result == "20");
		
		xml = Xml.parse("<TRIAL block='20' order='fixed' trials='1' trialName='v'><d/></TRIAL>");
		result = XML_tools.findAttr(xml, "block");
		Assert.isTrue(result == "20");

		
		xml = Xml.parse("<BOSS><TRIAL block='20' order='fixed' trials='1'  trialName='v'><d></d></TRIAL><TRIAL block='20' order='fixed' trials='1'  trialName='v'><d></d></TRIAL></BOSS>");
		var blockXMLs:Iterator<Xml> = XML_tools.findNode(xml, "TRIAL") 	;
		
		for(block in blockXMLs) {
			block = Xml.parse(block.toString());
			result = XML_tools.findAttr(block, "block");
			Assert.isTrue(result == "20");
		}
		
		for (block in xml.elementsNamed("TRIAL")) {
			//block = Xml.parse(block.toString());
			result = XML_tools.findAttr(block, "block");
			Assert.isTrue(result == "20");
		}
	}
	
	public function test_extendXML_inclBossNodeParams() {
	
		var xml1 = Xml.parse("<xml/>");
		var xml2 = Xml.parse("<a/>");
		XML_tools.extendXML_inclBossNodeParams(xml1, xml2,"bla");
		Assert.isTrue(xml1.toString() == "<xml/>");
		
		
		xml1 = Xml.parse("<xml/>");
		xml2 = Xml.parse("<a a='1'/>");
		XML_tools.extendXML_inclBossNodeParams(xml1, xml2,"bla");
		Assert.isTrue(xml1.toString() == "<xml a=\"1\"/>");
		
		xml1 = Xml.parse("<xml b='1'/>");
		xml2 = Xml.parse("<a a='1' b='2'/>");
		XML_tools.extendXML_inclBossNodeParams(xml1, xml2,"bla");
		Assert.isTrue(xml1.toString() == "<xml b=\"1\" a=\"1\"/>");
		
		
		var xml1:Xml = Xml.parse("<xml b='2'><a copyOverId='a' a='1' /><b copyOverId='b' a='1' /> <c                a='1' /> </xml> ");
		var xml2:Xml = Xml.parse("<xml a='a' b='2'><a copyOverId='a' a='wrong' aa='1'/><b copyOverId='b' aa='1'/> <c copyOverId='b' aa='1'/><banana b='bbb'/> </xml> ");
		
		var result:Xml = XML_tools.extendXML_inclBossNodeParams(xml1, xml2, 'copyOverId');
		
		Assert.isTrue(result.toString() == "<xml b=\"2\" a=\"a\"><a copyOverId=\"a\" a=\"1\" aa=\"1\"/><b copyOverId=\"b\" a=\"1\" aa=\"1\"/> <c a=\"1\"/> <banana b=\"bbb\"/></xml>");
		
	}
	
	public function test__augment() {
		var boss:Xml, donator:Xml;
		boss = Xml.parse("<xml><a aa='aaa'/></xml>");
		donator = Xml.parse("<xml><a aa='a' aaaa='aaaaa'/><b test='' test1=''/></xml>");
		
		
		
		//trace(XML_tools.augment(boss, donator));
		
		Assert.isTrue(true);
		
		
	}
	
	public function test__addChildCopy() {
	
		var a:Xml = Xml.parse("<a/>");
		var b:Xml = Xml.parse("<b  c='1' d='1'/>");
		
		var result:Xml = XML_tools.addChildCopy(a, b,"ddd");
		
		trace(result);
		
		Assert.isTrue(true);
		
	}
	
	
	
}