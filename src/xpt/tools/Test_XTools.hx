package xpt.tools;
import utest.Assert;
/**
 * ...
 * @author 
 */
class Test_XTools
{

	public function new() 
	{
		
	}
	
	public function test_shuffleArray():Void {
		
		
		var arr:Array<Int> = [1,2,3];
		var result:Array<Int> = [0, 0, 0];
		
		
		for(i in 0...100){
			XTools.arrayShuffle(arr);
			result[		arr[0]-1	] ++;
		}
		
		Assert.isTrue(result[0] > 5 && result[1] > 5 && result[2] > 5);
		
		
		var r1:Array<Int> = XTools.arrayShuffle([1, 2, 3,4,5,6,7,8,9,10], "a");
		var r2:Array<Int> = XTools.arrayShuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], "a");
				
		for (i in 0...9) {
			Assert.isTrue(r1[i] == r2[i]);
		}
		
	}
	
	
}
/*
class Test {
	public var a:Int;
	
	public function new(val:Int) {
		a = val;
	}
}*/