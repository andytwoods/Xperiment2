package xpt.results;
import utest.Assert;


/**
 * ...
 * @author 
 */
class Test_Results
{

	public function new() 
	{
		
	}
	
	public function test__addResultsInfo() {
	
		var results = Xml.parse("<test a='a'>bla</test>");
		var map:Map<String,String> = ['a' => 'aa', 'b' => 'bb'];
		
		
		Results.__addResultsInfo(results, map);
		
		Assert.isTrue(results.toString().length==40); //cannot guarantee order. <test a="a">bla<b>bb</b><a>aa</a></test>,
		
	}
	
}