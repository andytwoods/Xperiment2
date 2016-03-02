package xpt.screenManager;
import de.polygonal.ds.ArrayUtil;
import utest.Assert;
import xpt.screenManager.DeviceManager.Check;

/**
 * ...
 * @author Andy Woods
 */
class Test_DeviceManager
{

	public function new() { }

	public function test_Check() {
	
		
		var check:Check = new Check("banana");
		Assert.isTrue(check.sign == true);
		Assert.isTrue(check.device == 'banana');
		
		check = new Check("!banana");
		Assert.isTrue(check.sign == false);
		Assert.isTrue(check.device == 'banana');
		
	}
	
	public function test_generateChecks() {
	
		var checksStr:String = "banana, !grape,flamingo ";
		
		var checks:Array<Check> = DeviceManager.generateChecks(checksStr);
		
		Assert.isTrue(checks.length == 3);
		
		var check:Check = checks[0];
		Assert.isTrue(check.sign == true);
		Assert.isTrue(check.device == 'banana');
		
		check = checks[1];
		Assert.isTrue(check.sign == false);
		Assert.isTrue(check.device == 'grape');
		
		check = checks[2];
		Assert.isTrue(check.sign == true);
		Assert.isTrue(check.device == 'flamingo');
		
		
	}
	
}