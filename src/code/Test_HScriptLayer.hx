package code;
import code.Code.HScriptLayer;
import utest.Assert;

/**
 * ...
 * @author 
 */
class Test_HScriptLayer
{

	public function new() { }

	
	public function test_layer() {
	
		
		var layer:HScriptLayer = new HScriptLayer();
		
		layer.crunch("");
		
		
		Assert.isTrue(true);
	}
	
}