package xpt;
import utest.Assert;

/**
 * ...
 * @author 
 */
class Test_ExptWideSpecs
{

	public function new() { }

	public function test__getListStatic() {
	
		var list = ExptWideSpecs.__getListStatic();
		
		Assert.isTrue(list.length>0);
	}
	
	
	public function test__IS() {
	
		ExptWideSpecs.special_turkInfo = ["bla" => "bla"];
		
		var turkInfo:Map<String,String> = ExptWideSpecs.IS("turkInfo");
		Assert.isTrue(turkInfo.get("bla")=="bla");
	}
	
	public function test_kill() {
	
		ExptWideSpecs.special_turkInfo = ["bla" => "bla"];
		ExptWideSpecs.kill();
		
		
		Assert.isTrue(ExptWideSpecs.special_turkInfo == null);
		
	}
	
}