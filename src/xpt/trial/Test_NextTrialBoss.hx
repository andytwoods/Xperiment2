package xpt.trial;
import thx.Arrays;
import thx.Iterators;
import thx.Maps;
import utest.Assert;
import xpt.tools.XTools;

/**
 * ...
 * @author 
 */
class Test_NextTrialBoss
{

	public function new() { }

	
	public function test__generateLookup() {
	
		var genSkeletons = function(arr:Array<Array<Int>>):Array<TrialSkeleton> {
			var skeletons:Array<TrialSkeleton> = [];	
			for(list in arr){
				var skeleton:TrialSkeleton = new TrialSkeleton(null);
				skeleton.trials = list;
				skeletons.push(skeleton);
			}
			
			return skeletons;
			
		}
		
		var arr =   genSkeletons( [   [0, 1, 2], [3, 4, 5], [6, 7, 8]   ]	);
		
		
		var lookup = NextTrialBoss.__generateLookup(arr);
		
		var count = 0;
		for (key in lookup.keys()) {
			count++;	
		}
		Assert.isTrue(count == 9);
		
		Assert.isTrue(Arrays.equals(lookup[0].trials, [0, 1, 2]));
		Assert.isTrue(Arrays.equals(lookup[1].trials, [0, 1, 2]));
		Assert.isTrue(Arrays.equals(lookup[2].trials, [0, 1, 2]));
		
		Assert.isTrue(Arrays.equals(lookup[3].trials, [3, 4, 5]));
		Assert.isTrue(Arrays.equals(lookup[4].trials, [3, 4, 5]));
		Assert.isTrue(Arrays.equals(lookup[5].trials, [3, 4, 5]));
		
		Assert.isTrue(Arrays.equals(lookup[6].trials, [6, 7, 8]));
		Assert.isTrue(Arrays.equals(lookup[7].trials, [6, 7, 8]));
		Assert.isTrue(Arrays.equals(lookup[8].trials, [6, 7, 8]));
		

		//2 trials cannot exist at same trial location
		arr =   genSkeletons( [   [0, 1, 2], [3, 4, 5], [6, 7, 7]   ]	);
		try {
			NextTrialBoss.__generateLookup(arr);
			Assert.isTrue(false);
		}
		catch (str:String) {
			Assert.isTrue(true);
		}
		
	}
	
}