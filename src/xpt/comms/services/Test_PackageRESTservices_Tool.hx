package xpt.comms.services;

import haxe.ds.StringMap;
import xpt.comms.CommsResult;

import utest.Assert;

@:access(xpt.comms.services.PackageRESTservices_Tool)
class Test_PackageRESTservices_Tool
{

	public function new() { }

	
	public function test_genResults() {
		var orig:Map<String,String> = ['a' => 'aa', 'b' => 'bb'];
		
		var mod:Map<String,String> = PackageRESTservices_Tool.genResults(orig);
		
		Assert.equals(mod.get('a'), orig.get('a'));
		Assert.equals(mod.get('b'), orig.get('b'));
		
	}
	
	public function test_fill() {
	
		var map:Map<String,String> = ['a' => 'aa', 'b' => 'bb', 'c' => 'cc', 'd' => 'dd'];
		
		var fresh1 = PackageRESTservices_Tool.genResults(null);
		var fresh2 = PackageRESTservices_Tool.genResults(null);
		var fresh3 = PackageRESTservices_Tool.genResults(null);
		var fresh4 = PackageRESTservices_Tool.genResults(null);
		
		Assert.isFalse(PackageRESTservices_Tool.fill(map, fresh1, 5, 2));
		Assert.isFalse(PackageRESTservices_Tool.fill(map, fresh2, 5, 2));
		Assert.isFalse(PackageRESTservices_Tool.fill(map, fresh3, 5, 2));
		Assert.isTrue(PackageRESTservices_Tool.fill(map, fresh4, 5, 2));
		
		Assert.isTrue(countKeys(fresh1) == 1);
		Assert.isTrue(countKeys(fresh2) == 1);
		Assert.isTrue(countKeys(fresh3) == 1);
		Assert.isTrue(countKeys(fresh4) == 1);
		Assert.isTrue(countKeys(map) == 0);
		
		map = ['a' => 'aa', 'b' => 'bb', 'c' => 'cc', 'd' => 'dd'];
		
		fresh1 = PackageRESTservices_Tool.genResults(null);
		fresh2 = PackageRESTservices_Tool.genResults(null);
		
		Assert.isFalse(PackageRESTservices_Tool.fill(map, fresh1, 10, 2));
		Assert.isTrue(PackageRESTservices_Tool.fill(map, fresh2, 10, 2));

		Assert.equals(countKeys(fresh1), 2);
		Assert.equals(countKeys(fresh2), 2);
		Assert.equals(countKeys(map), 0);
	}
	
	public function test_partition_results() {
		var results:Map<String,String> = ['a' => 'aa', 'b' => 'bb', 'c' => 'cc', 'd' => 'dd'];
		var identifiers:Map<String,String> = ['id' => 'ID', 'ip' => 'IP'];
		
		var list:Array<Map<String,String>> = PackageRESTservices_Tool.partition_results(results, identifiers, 5, 2);
		
		Assert.equals(list.length, 4);
		Assert.equals(countKeys(results), 0);
		
		for (map in list) {
			Assert.equals(countKeys(map), 3);
		}
		
	}
	
	public function test_new_success() {
	
		var call = Assert.createAsync();
		var success:Bool = false;
		
		function callback(commsResult:CommsResult, message:String, data:Map<String,String>) {
			
			Assert.isTrue(success);
			Assert.isTrue(commsResult == CommsResult.Success);
			Assert.isTrue(message == '');
			Assert.isTrue(data == null);
			call();
		}
		
		var p:PackageRESTservices_Tool = new PackageRESTservices_Tool(null, callback, null);
		
		p.total = 2;
		
		p.eventL(CommsResult.Success, '', null);
		success = true;
		p.eventL(CommsResult.Success, '', null);
		
		
	}
	
	
	public function test_new_fail_success() {
	
		var call = Assert.createAsync();
		var success:Bool = false;
		
		function callback(commsResult:CommsResult, message:String, data:Map<String,String>) {
			
			Assert.isTrue(commsResult == CommsResult.Fail);
			Assert.isTrue(success);
			Assert.equals(message, 'ab');
			Assert.isTrue(data != null);
			Assert.equals(data.get('a'), 'aa');
			Assert.equals(countKeys(data),1);
			call();
		}
		
		var p:PackageRESTservices_Tool = new PackageRESTservices_Tool(null, callback, null);
		
		p.total = 2;
		
		var dat1:StringMap<String> = ['a' => 'aa'];
		var dat2:StringMap<String> = ['b' => 'bb'];
		
		p.eventL(CommsResult.Fail, 'ab', dat1);
		success = true;
		p.eventL(CommsResult.Success, 'cd', dat2);
		
		
	}
	
		public function test_new_fail_fail() {
	
		var call = Assert.createAsync();
		var success:Bool = false;
		
		function callback(commsResult:CommsResult, message:String, data:Map<String,String>) {
			
			Assert.isTrue(commsResult == CommsResult.Fail);
			Assert.isTrue(success);
			Assert.equals(message, 'ab,cd');
			Assert.isTrue(data != null);
			Assert.equals(data.get('a'), 'aa');
			Assert.equals(data.get('b'), 'bb');
			Assert.equals(countKeys(data),2);
			call();
		}
		
		var p:PackageRESTservices_Tool = new PackageRESTservices_Tool(null, callback, null);
		
		p.total = 2;
		
		var dat1:StringMap<String> = ['a' => 'aa'];
		var dat2:StringMap<String> = ['b' => 'bb'];
		
		p.eventL(CommsResult.Fail, 'ab', dat1);
		success = true;
		p.eventL(CommsResult.Fail, 'cd', dat2);
		
		
	}
	
	
	
	
	function countKeys(map:Map<String,String>):Int {
		var i:Int = 0;
		for (key in map.keys()) {
			i++;
		}
		return i;
	}
}