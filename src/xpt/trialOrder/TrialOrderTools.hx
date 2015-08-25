package xpt.trialOrder;
import haxe.Json;
import xpt.trialOrder.TrialBlock;

/**
 * ...
 * @author 
 */
class TrialOrderTools
{


	
	static public function composeOrder(trialBlocks:Array<TrialBlock>):Array<Int> 
	{

		
		__combineIdentical(trialBlocks);
		
		__removeEmpty(trialBlocks);
		
		__doSort(trialBlocks);

		BlockDepthOrdering.DO(trialBlocks);		
	
		return composition(trialBlocks);
	}
	
	static private function composition(trialBlocks:Array<TrialBlock>) 
	{
		var trials:Array<Int> = [];
			var trialBlock:TrialBlock;
			for (i in 0...trialBlocks.length) {
				if(trialBlocks[i].alive)	trials=trials.concat(trialBlocks[i].trials);
			}
			return trials;
	}
	
	
	public static function __combineIdentical(trialBlocks:Array<TrialBlock>)
	{
		var innerT:TrialBlock;
		var outerT:TrialBlock;
		
		var len:Int = trialBlocks.length;
		
		var outer_i:Int;
		var inner_i:Int;

		for(outer_i in 0 ... len){
			outerT=trialBlocks[outer_i];
			for (inner_i in outer_i + 1 ... len){
		
				innerT=trialBlocks[inner_i];
				if(innerT.alive == true){
	
					if(outerT.blocksIdent==innerT.blocksIdent && innerT.forceBlockDepthPositions == null){
					
						if(innerT.forceBlockPositions == null){
							outerT.addTrials(innerT.trials);
						}
						else{
							outerT.addForcedBlock(innerT.forceBlockPositions);
						}
						outerT.order=innerT.order;
						outerT.blockDepthOrder=innerT.blockDepthOrder;
						innerT.alive=false;
					}
					
				}
				
			}
		
		}
	}
	
	public static function __doSort(trialBlocks:Array<TrialBlock>):Void
		{
			trialBlocks.sort(__sortF);
			
			var trialBlock:TrialBlock;
			for (i in 0...trialBlocks.length) {
				trialBlock = trialBlocks[i];
				if (trialBlock.alive) {
					trialBlock.doOrdering();
					trialBlock.forcePositions();
				}
			}

		}
		
	public static function __sortF(t2:TrialBlock, t1:TrialBlock):Int
	{
		var i:Int;
		var v1:Int;
		var v2:Int;
		
		for(i in 0...t1.blocksVect.length){
			v1=t1.blocksVect[i];
			if(t2.blocksVect.length-1>=i)v2=t2.blocksVect[i];
			else v2=0;
			
			if(v1<v2) return 1;
			else if(v1>v2) return -1;
			else if(t1.blocksVect.length == t2.blocksVect.length && t2.blocksVect.length -1 == i){
				
				if(v1==v2) return 0;
				else return -1;
			}
			else if(t1.blocksVect.length < t2.blocksVect.length){
			}
		}
		return 1;
	}
	
	public static function __removeEmpty(trialBlocks:Array<TrialBlock>):Array<TrialBlock>
	{
		
		
		var t:TrialBlock;
		
		for (i in 0...trialBlocks.length) {
			t = trialBlocks[i];	
			if (t == null || t.alive == false) {
				trialBlocks.splice(i, 1);
			}
			
		}

		return trialBlocks;
	}

}