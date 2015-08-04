package xpt.script;
import xpt.stimuli.ETCs;
import thx.Arrays;
import utest.Assert;
import xpt.stimuli.ETCs.NumText;
import xpt.tools.XTools;

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
	
	/*public function test__getIterate() {
		
		var xml:Xml = Xml.parse("<a trials='3'><b howMany='2'/></a>");
		
		var b:Xml = xml.findNode('b').next();
		Assert.isTrue(3 == ETCs.__getIterate(b, ";;;etc;;;") );
		Assert.isTrue(2== ETCs.__getIterate(b, "---etc---") );
		
		xml = Xml.parse("<a trials='3'><b etcHowMany='5' howMany='2'/></a>");
		b = xml.findNode('b').next();
		Assert.isTrue(5 == ETCs.__getIterate(b, ";;;etc;;;") );
		Assert.isTrue(5 == ETCs.__getIterate(b, "---etc---") );
	}*/
	
	public function test__getIterate() {
		
		var genMap = function(namsStr:String, valsStr:String):Map<String,String> {
			var nams:Array<String> = namsStr.split(",");
			var vals:Array<String> = valsStr.split(",");
			
			var map:Map<String,String> = new Map<String,String>();
			
			for(i in 0...nams.length){				
				map.set(nams[i], vals[i]);
			}
			return map;
		}
		

		var map = genMap("a,b,c", "aa,bb,cc");
		ETCs.compose(map,  1, 1);
		Assert.isTrue(map.get("a") == "aa" && map.get("b") == "bb" && map.get("c") == "cc");
		
		ETCs.compose(map,  99, 99);
		Assert.isTrue(map.get("a") == "aa" && map.get("b") == "bb" && map.get("c") == "cc");
		
		map = genMap("b", "bb---etc");
		ETCs.compose(map,  1, 3);
		Assert.isTrue(map.get("b") == "bb---etc");

		map = genMap("b", "bb;cc;dd;;;etc;;;");
		ETCs.compose(map,  4, 1);
		Assert.isTrue(map.get("b")=="bb;cc;dd;bb");
		
		map = genMap("b", "bb---cc---etc---");
		ETCs.compose(map,  1, 3);
		Assert.isTrue(map.get("b") == "bb---cc---bb");
		
		map = genMap("b", "bb0---bb1---etc---");
		ETCs.compose(map,  1, 3);
		Assert.isTrue(map.get("b")=="bb0---bb1---bb2");
	}
	
	public function test__extendTextSequence() {
		Assert.isTrue(Arrays.equals("a,b,a,b,a".split(","), ETCs.__extendTextSequence("a,b".split(","),5)));
	}

	private function check(arr2:Array<String>, arr1:Array<String>):Bool {
			if (arr1.length != arr2.length) return false;
			
			var len:Int;
			var a:String, b:String;
			for (i in 0...arr1.length) {
				a = arr1[i];
				len = a.length;
				b = arr2[i].substr(0, len);
				if (a != b) return false;
			}
			
			return true;
		}
		
	
	public function test__extendNumSequence() {
		Assert.isTrue(check(ETCs.__extendNumSequence([1, 2], 5), XTools.xArr_to_StrArr([1, 2, 3, 4, 5])));
		
		//note floating point annoyingness below [1,2.1,3.2,4.300000000000001,5.4], hence function check.
		Assert.isTrue(check(ETCs.__extendNumSequence([1, 2.1], 5), XTools.xArr_to_StrArr([1, 2.1, 3.2, 4.3, 5.4])));
		
	}
	
	public function __test__buildStringEtc() {
		
		var arr1 = "a1,a2".split(",");
		var arr2 = "a1,a2,a3,a4,a5".split(",");
	
		Assert.isTrue(check(ETCs.__extendDecoratedNumSequence(arr1, 5), arr2));
	}
	
	public function test__NumText() {
		var n:NumText = new NumText("a1");
		Assert.isTrue(n.__numPos == 1 && n.num==1);
		Assert.isTrue(n.__surroundingText.length == 1 && n.__surroundingText[0] == "a");
		
		n = new NumText("aaa11bbb11");
		Assert.isTrue(n.__numPos == 1 && n.num==11);
		Assert.isTrue(n.__surroundingText.length == 2 && n.__surroundingText[0] == "aaa" && n.__surroundingText[1] == "bbb11");
		
		Assert.isTrue("aaa22bbb11"==n.decorate("22"));
	}
	
	public function test__extendDecoratedNumSequence() {
	
		var res:Array<String> = ETCs.__extendDecoratedNumSequence("a1,a2".split(","), 5);
	
		Assert.isTrue(check(res, "a1,a2,a3,a4,a5".split(",")));
		
		
		res = ETCs.__extendDecoratedNumSequence("aaa11bbb11,aaa22bbb11".split(","), 5);

		Assert.isTrue(check(res, "aaa11bbb11,aaa22bbb11,aaa33bbb11,aaa44bbb11,aaa55bbb11".split(",")));		
	}

}