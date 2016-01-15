package xpt.results;
import thx.Arrays;
import utest.Assert;
import xpt.tools.XTools;
import xpt.trial.Trial;


class Test_TrialResults
{

	public function new() 
	{	
	}
	
	
	public function test_getName() {
	
		var t:Trial = new Trial(null);
		t.trialName = "trialName";
		t.trialBlock = 22;
		t.iteration = 33;


		var t:TrialResults = 	t.getResults();
		Assert.isTrue(t == null);
		
		
		var tr:TrialResults =  new TrialResults();
		tr.trialName = "trialName";
		tr.trialBlock = 22;
		tr.iteration = 33;

		Assert.isTrue("trialName|b22i33" == tr.getName());
	}
	
	/*public function test__mapToXmlList() {
	
		var results = [ 'a' => "aa", 'b' => "bb", 'c' => "cc" ];
		
		var arr:Array<Xml> = TrialResults._mapToXmlList(results);
		
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

	}*/
	
		public function test_safeProp() {
	
		
		var map:Map<String,String> = new Map<String,String>();
		
		map.set("b", "b");
		
		Assert.isTrue(TrialResults.__safeProp("a", map) == "a");
		Assert.isTrue(TrialResults.__safeProp("b", map) == "b1");
		map.set("b1", "b1");
		Assert.isTrue(TrialResults.__safeProp("b", map) == "b2");
	}
	
	public function test_combineMaps() {
	
		
		
		var map1 = [ 'a'=>"aa", 'b'=>"bb",'c'=>"cc" ];
		var map2 = [ 'a' => "aa", 'b' => "bb", 'd' => "dd" ];
		var map3 = [ 'a' => "aa", 'b' => "bb", 'e' => "ee" ];
		
		TrialResults.__combinedMaps(map1, map2);
		TrialResults.__combinedMaps(map1, map3);
	
		
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

		TrialResults.__combinedMaps(map4, map5);
		
		var keys:Array<String> = XTools.iteratorToArray( map4.keys() );
		
		var compareArr:Array<String> = Arrays.distinct(keys);
		
		Assert.isTrue(compareArr.length == keys.length);
	}
	
	
}