package xpt.trialOrder;
import haxe.Json;
import xpt.tools.XRandom;
import xpt.tools.XTools;

/**
 * ...
 * @author 
 */
class BlockDepthOrdering
{
	
	private static var __depthOrders:Array<String>;
	
	private static var __depthNodes:DepthNodeBoss;

	public static function DO(trialBlocks:Array<TrialBlock>):Void
	{
		
		var depths:String = ExptWideSpecs.IS("blockDepthOrder");
		
		__depthNodes = new DepthNodeBoss(depths);
		
		
		
		//generated outside of orderDepths as orderDepths is iterative, calling tiself
		var deepestDepth:Int = getDeepest(trialBlocks);

		
		__orderDepths(trialBlocks, deepestDepth);


		__depthNodes.kill();
		__depthNodes = null;
		__depthOrders = null;
		
	}
	
	private static function getDeepest(trialBlocks:Array<TrialBlock>):Int
	{
		var max:Int=0;
		
		for(i in 0...trialBlocks.length){
			if(trialBlocks[i].blocksVect.length -1 > max) max= trialBlocks[i].blocksVect.length - 1;
		}
		
		return max;
	}		

	
	public static function __orderDepths(trialBlocks:Array<TrialBlock>,deepestDepth:Int):Void
	{
		
	
		var atDepth:Array<TrialBlock>=[];
		var remainder:Array<TrialBlock>=[];

		//gather all the trials at each depth
		for (i in 0...trialBlocks.length) {

			if (trialBlocks[i].alive && trialBlocks[i].blocksVect.length - 1 == deepestDepth) {
				atDepth.push(trialBlocks[i]);	
			}
		}

		if (atDepth.length >= 0) {
			groupThenDoOrder(atDepth,deepestDepth);
			
		}

		deepestDepth--;
		if(deepestDepth>=0){	
			__orderDepths(trialBlocks,deepestDepth);
		}
	}		
	
	private static function groupThenDoOrder(atDepth:Array<TrialBlock>,deepestDepth:Int):Void
	{
	
		var parentsArr:Map<String, Array<TrialBlock>  > = new Map<String, Array<TrialBlock>  >();
		
		var trialBlock:TrialBlock;
		var parents:String;
		
		var isWildCard:Bool;
		
		for (i in 0...atDepth.length) {

			trialBlock=atDepth[i];
			parents=trialBlock.giveParents();
		
			isWildCard = __depthNodes.IsWildCard(parents);
			if(isWildCard){
				parents=trialBlock.giveOnlyParents();
				
				parents+=" *";
			}
			
			if(parentsArr[parents] == null) parentsArr[parents] = [];
			parentsArr[parents].push(atDepth[i]);
		}
		
		var depthLookup:String;
		var parent:String;

		for (key in parentsArr.keys()) {
		
			var sortType:String = __depthNodes.retrieve(key);
			if (sortType == DepthNode.UNKNOWN) sortType = OrderType.DEFAULT_DEPTH_ORDER;
			
			doOrder(parentsArr[key], sortType);
		}
					
		for(i in 0...atDepth.length){
			atDepth[i].trimBlocksVect();
		}
	}
	
	private static function sort(arr:Array<TrialBlock>):Array<TrialBlock> {

		arr.sort( function(a:TrialBlock, b:TrialBlock):Int
		{
			if (a.currentDepthID < b.currentDepthID) return -1;
			if (a.currentDepthID > b.currentDepthID) return 1;
			return 0;
		} );
	
		
		return arr;
	}
	
	
	private static function doOrder(atDepth_trialBlocks:Array<TrialBlock>, sortType:String):Void
	{			
		sort(atDepth_trialBlocks);

		switch(sortType.toUpperCase()){
			case OrderType.FIXED: 
				
			case OrderType.RANDOM:
				XRandom.shuffle(atDepth_trialBlocks);

			case OrderType.REVERSED:
				atDepth_trialBlocks.reverse();

			default: 
				if(sortType.indexOf(OrderType.PREDETERMINED)!=-1){
				var newOrder:Array<String> = sortType.split(OrderType.PREDETERMINED)[1].split(",");
											
				if(newOrder.length!=atDepth_trialBlocks.length)throw "Error! You have specified a predetermined trial Ordering that does not have the same number of trials as the trials you wish to order: "+newOrder.join(",");
				
				
				for(i in 0... atDepth_trialBlocks.length){
					atDepth_trialBlocks[i].preterminedSortOnOrder = Std.parseInt(newOrder[i]);
				}
				
				atDepth_trialBlocks.sort(function(a:TrialBlock, b:TrialBlock):Int
					{
						if (a.preterminedSortOnOrder < b.preterminedSortOnOrder) return -1;
						if (a.preterminedSortOnOrder > b.preterminedSortOnOrder) return 1;
						return 0;
					} );
	
				}
				else throw "debug: "+sortType;
		}
		
		__flatten(atDepth_trialBlocks);
	}		
	

	
	public static function __flatten(atDepth_trialBlocks:Array<TrialBlock>):Void
	{
		
		for(i in 1 ... atDepth_trialBlocks.length){

			atDepth_trialBlocks[0].addTrials(atDepth_trialBlocks[i].trials);
			
			if (atDepth_trialBlocks[i].forcePositionInBlockDepth != null) {
				
				//trace(111, atDepth_trialBlocks[i].forcePositionInBlockDepth);
				atDepth_trialBlocks[0].pass_forcePositionInBlockDepth(atDepth_trialBlocks[i].forceBlockDepthPositions);
			}
			atDepth_trialBlocks[i].alive = false;
		}
		

		atDepth_trialBlocks[0].do_forcePositionInBlockDepth();

	}		
	
	//function seems redundent;
	public static function __compileDepthOrders():Void{
		//var rawDepthOrders:Array = ExptWideSpecs.IS("blockDepthOrder").split(",");
		
		//var depthSettings:Object;
		//for (i in 0...rawDepthOrders) {
		
			//__processDepth(rawDepthOrders[i],depthSettings);
		//}
	}
	
/*	public static function __processDepth(depth:String,depthSettings:Object):Void{
		
	}*/
	
	public static function __computeOrders(trialBlocks:Array<TrialBlock>):Void
	{
		
		__depthOrders = new Array<String>();
		
		var depth:Int;
		
		var bulkDepthsSet:Array<String> = [];
		
		for(i in 0...trialBlocks.length){

			depth=trialBlocks[i].blocksVect.length-1;

			
			if (__depthOrders.length < depth) {
				addDepths(__depthOrders, depth - __depthOrders.length);
			}
			__depthOrders[depth]=trialBlocks[i].blockDepthOrder;
		
			
			if(trialBlocks[i].blockDepthOrders !=null){
				bulkDepthsSet = trialBlocks[i].blockDepthOrders; //PROB HERE??
			}
		}			
		
		if(bulkDepthsSet.length>0){
			
			if (__depthOrders.length < bulkDepthsSet.length) addDepths(__depthOrders, bulkDepthsSet.length - __depthOrders.length);
			
			for(i in 0...bulkDepthsSet.length){
				__depthOrders[i]=bulkDepthsSet[i];
			}
		}

	}
	
	
	private static function addDepths(__depthOrders:Array<String>, more:Int):Void
	{
		for(i in 0...more){
			__depthOrders[__depthOrders.length]='';
		}
	}
}