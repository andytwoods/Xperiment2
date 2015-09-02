package xpt.trial;
import thx.Arrays;
import thx.Maps;
import utest.Assert;
import xpt.tools.XTools;

/**
 * ...
 * @author 
 */
class Test_ExtractResults
{

	public function new() { }


	
	public function test_safeProp() {
	
		
		var map:Map<String,String> = new Map<String,String>();
		
		map.set("b", "b");
		
		Assert.isTrue(ExtractResults._safeProp("a", map) == "a");
		Assert.isTrue(ExtractResults._safeProp("b", map) == "b1");
		map.set("b1", "b1");
		Assert.isTrue(ExtractResults._safeProp("b", map) == "b2");
	}
	
	public function test_combineMaps() {
	
		
		
		var map1 = [ 'a'=>"aa", 'b'=>"bb",'c'=>"cc" ];
		var map2 = [ 'a' => "aa", 'b' => "bb", 'd' => "dd" ];
		var map3 = [ 'a' => "aa", 'b' => "bb", 'e' => "ee" ];
		
		ExtractResults._combinedMaps(map1, map2);
		ExtractResults._combinedMaps(map1, map3);
	
		
		var keys = "d,b1,a2,b,b2,c,e,a1,a".split(",");
		var vals = "dd,bb,aa,bb,bb,cc,ee,aa,aa".split(",");
		
		for (i in 0...keys.length) {
			Assert.isTrue(map1.get(keys[i]) == vals[i]);
		}
		

		var arr = Std.string(Math.random() * 10000).split("");
		var map4:Map<String,String> = new Map<String,String>();
		var map5:Map<String,String> = new Map<String,String>();
		
		for (val in arr) {
			val = "t" + val; 
			map4.set(val, val);
			map5.set(val, val);
		}

		ExtractResults._combinedMaps(map4, map5);
		
		var keys:Array<String> = XTools.iteratorToArray( map4.keys() );
		
		var compareArr:Array<String> = Arrays.distinct(keys);
		
		Assert.isTrue(compareArr.length == keys.length);
	}
	
	public function test_getName() {
	
		var t:Trial = new Trial();
		t.trialName = "trialName";
		t.trialBlock = 22;
		t.iteration = 33;
		
		Assert.isTrue("trialName|b22i33" == ExtractResults._getName(t));
	}
	
	public function test__mapToXmlList() {
	
		var results = [ 'a' => "aa", 'b' => "bb", 'c' => "cc" ];
		
		var arr:Array<Xml> = ExtractResults._mapToXmlList(results);
		
		var arrStr:Array<String> = [];
		for (xml in arr) {
			arrStr.push(xml.toString());
		}
		
		Assert.isTrue(arrStr.indexOf("<a>aa</a>")!=-1);
		Assert.isTrue(arrStr.indexOf("<b>bb</b>")!=-1);
		Assert.isTrue(arrStr.indexOf("<c>cc</c>")!=-1);
		Assert.isTrue(arr.length == 3);
		
		
		var head:Xml = Xml.parse("<head bla='bla'/>");
		
		ExtractResults._addChildren(head, arr);
		
		var str:String = head.toString();
		Assert.isTrue(str.length == 50); //sadly node name order not guaranteed

	}
	
}


