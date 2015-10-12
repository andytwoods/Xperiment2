package xpt.script.templateHelpers;
import thx.Arrays;
import utest.Assert;


/**
 * ...
 * @author 
 */
class Test_templateList
{

	public function new() 
	{
		
	}
	
	
	public function test1_make() {
		Assert.isTrue(RequireTemplating.make(Xml.parse("<a/>")) == null);
		Assert.isTrue(RequireTemplating.make(Xml.parse("<a template=''/>")) == null);
		Assert.isTrue(RequireTemplating.make(Xml.parse("<a template='a'/>")) != null);
		Assert.isTrue(RequireTemplating.make(Xml.parse("<a template=''><a template='a'/></a>"))==null);
	}
	
	private function genTemplateList(myList:Array<Array<String>>):Array<RequireTemplating> {
		var composed = [];
		for (arr in myList) {
			var require = new RequireTemplating();
			require.templates = arr;
			require.name = arr[0];
			composed.push(require);
		}
		return composed;
	}
	
	public function test__getTemplateNames() {
	
		var myList = genTemplateList([["a"], ["aa","aa2"], ["aaa","aaa3"], ["aaaa"]]);

		var t:TemplateList = new TemplateList();
		var result = t.__getTemplateNames(myList);
		Assert.isTrue(Arrays.equals(result, ['a', 'aa', 'aa2', 'aaa', 'aaa3', 'aaaa']));

	}
	
	public function test__generateList() {
		var arr = [];
		for (xml in [Xml.parse("<a template='a'/>"), Xml.parse("<a template='a'/>"), Xml.parse("<a template='a'/>")]) {
			arr.push(xml);	
		}
		var t:TemplateList = new TemplateList();
		var result = t.__generateList(arr.iterator());
		Assert.isTrue(result.length == 3);
	}
	
	public function test___removeDuplicates() {
	
		var myList = genTemplateList([["a"], ["aa", "aa2"], ["aaa", "aaa3"], ["aaaa"]]);
		var uniqueList = ["e","a", "aaaa","1","c","c"];
		
		var t:TemplateList = new TemplateList();
		uniqueList = t.__removeDuplicates(uniqueList,myList);

		Assert.isTrue(Arrays.equals(uniqueList,['e',"1","c"]));
	}
	
	public function test____addMissingTemplatesToList() {
	
		var missingTemplateList = ["missing1", "missing2"];
		
		var script:Xml = Xml.parse("<expt> <a/> <b/> <missing1/> <missing2/> </expt>");
		
		var requireTemplatingList:Array<RequireTemplating> = new Array<RequireTemplating>();
		
		var t:TemplateList = new TemplateList();
		t.__addMissingTemplatesToList(requireTemplatingList, missingTemplateList, script);
		
		
		Assert.isTrue(requireTemplatingList.length == 2);
		
		
		try {
			
			t.__addMissingTemplatesToList(requireTemplatingList, missingTemplateList, Xml.parse("<expt><missing2/> <a/> <b/> <missing1/> <missing2/> </expt>"));	
			Assert.isTrue(false);
		}
		catch (str:String) {
			Assert.isTrue(true);
		}
	}
	
}