package xpt;
import utest.Assert;
import xpt.ExptWideSpecs.SpecialProps;

/**
 * ...
 * @author 
 */
class Test_ExptWideSpecs
{

	public function new() { }

	
	public function test__IS() {
	
		ExptWideSpecs.special_turkInfo.set("bla","bla");
		
		var turkInfo:Map<String,String> = ExptWideSpecs.IS("turkInfo");
		Assert.isTrue(turkInfo.get("bla")=="bla");
	}
	
	public function test_kill() {
	
		ExptWideSpecs.special_turkInfo.set("bla","bla");
		ExptWideSpecs.kill();
		
		Assert.isTrue(ExptWideSpecs.special_turkInfo == null);
		
	}
	
	public function test_SpecialPropsClass() {
	
		var s:SpecialProps = new SpecialProps(["a,aa,aaa", "b"]);
		
		s.special_set("aa", "set");
		Assert.isTrue(s.special_get("a") == "set");
		Assert.isTrue(s.special_get("aa") == "set");
		Assert.isTrue(s.special_get("aaa") == "set");
		Assert.isTrue(s.special_get("b") == "");
		
	}
	
}