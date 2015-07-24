package xpt.trialOrder_old.components.blockOrder;

import com.xperiment.codeRecycleFunctions;
import com.xperiment.ExptWideSpecs.ExptWideSpecs;
import xpt.trialOrder_old.components.depthNode.DepthNode;
import xpt.trialOrder_old.components.depthNode.DepthNodeBoss;

class BlockDepthOrdering
{
	private static var __depthOrders:Array<String>;
	private static var __depthNodes:DepthNodeBoss;
	
	public static function DO(trialBlocks:Array):Void
	{
		
		__depthNodes=new DepthNodeBoss(ExptWideSpecs.IS("blockDepthOrder"));
		
		//__computeOrders(trialBlocks);
		
		//generated outside of orderDepths as orderDepths is iterative, calling tiself
		var deepestDepth:Int=getDeepest(trialBlocks)
		
		__orderDepths(trialBlocks,deepestDepth);
		
		__depthNodes.kill();
		__depthNodes=null;
		
	}
	
	private static function getDeepest(trialBlocks:Array):Int
	{
		var max:Int=0;
		
		for(i in 0...trialBlocks.length){
			if(trialBlocks[i].blocksVect.length -1>max)max=trialBlocks[i].blocksVect.length - 1;
		}
		
		return max;
	}		

	
	public static function __orderDepths(trialBlocks:Array,deepestDepth:Int):Void
	{

	
		var atDepth:Array<Dynamic>=[];
		var remainder:Array<Dynamic>=[];

		//gather all the trials at each depth
		for(i in 0...trialBlocks.length){
			if(trialBlocks[i].alive && trialBlocks[i].blocksVect.length-1==deepestDepth){
				atDepth.push(trialBlocks[i]);	
			}
		}

		if(atDepth.length>=0){
			groupThenDoOrder(atDepth,deepestDepth);
			
		}

		deepestDepth--;
		if(deepestDepth>=0){	
			__orderDepths(trialBlocks,deepestDepth);
		}
	}		
	
	private static function groupThenDoOrder(atDepth:Array,deepestDepth:Int):Void
	{
		var parentsArr:Dynamic={};
		
		var trialBlock:TrialBlock;
		var parents:String;
		
		var isWildCard:Bool;
		
		for(i in 0...atDepth.length){
			trialBlock=atDepth[i];
			parents=trialBlock.giveParents();
		
			isWildCard=__depthNodes.IsWildCard(parents);
			if(isWildCard){
				parents=trialBlock.giveOnlyParents();
				parents+=" *";
				
			}
			
			parentsArr[parents] ||=[];
			parentsArr[parents].push(atDepth[i]);
		}
		
		var depthLookup:String;
		for(parent in parentsArr){

			var sortType:String=__depthNodes.retrieve(parent);
			if(sortType==DepthNode.UNKNOWN)sortType=TrialBlock.DEFAULT_DEPTH_ORDER;
			
			doOrder(parentsArr[parent],sortType);
		}
							
		for(i=0;i<atDepth.length;i++){
			atDepth[i].trimBlocksVect();
		}
	}
	
	
	private static function doOrder(atDepth_trialBlocks:Array, sortType:String):Void
	{			

		atDepth_trialBlocks.sortOn('currentDepthID', Array.NUMERIC);

		switch(sortType.toUpperCase()){
			case TrialBlock.FIXED:
				break;
			
			case TrialBlock.RANDOM:
				codeRecycleFunctions.arrayShuffle(atDepth_trialBlocks);
				break;
			
			case TrialBlock.REVERSE:
				atDepth_trialBlocks=atDepth_trialBlocks.reverse();
				break;			
			
			default:
				
				if(sortType.indexOf(TrialBlock.PREDETERMINED)!=-1){
					var newOrder:Array<Dynamic>=sortType.split(TrialBlock.PREDETERMINED)[1].split(",");
					
					if(newOrder.length!=atDepth_trialBlocks.length)throw new Dynamic("Error! You have specified a predetermined trial Ordering that does not have the same number of trials as the trials you wish to order:"+newOrder.join(","));
					for(i in 0...atDepth_trialBlocks.length){
						(atDepth_trialBlocks[i] as TrialBlock).preterminedSortOnOrder=Std.int(newOrder[i]);
					}
					atDepth_trialBlocks.sortOn("preterminedSortOnOrder",Array.NUMERIC);
				}
				else throw new Dynamic();
		}
/*				trace("-----");
		for(i in 0...atDepth_trialBlocks.length){
			trace(atDepth_trialBlocks[i].trials)
			
		}*/
		
		__flatten(atDepth_trialBlocks);
	}		
	
	public static function __flatten(atDepth_trialBlocks:Array):Void
	{

		for(i in 1...atDepth_trialBlocks.length){

			atDepth_trialBlocks[0].addTrials(atDepth_trialBlocks[i].getTrials());
			
			if(atDepth_trialBlocks[i].forcePositionInBlockDepth!=''){
				atDepth_trialBlocks[0].pass_forcePositionInBlockDepth(atDepth_trialBlocks[i].forceBlockDepthPositions);
			}
			
			
			atDepth_trialBlocks[i].alive=false;
		}
		

		atDepth_trialBlocks[0].do_forcePositionInBlockDepth();

	}		
	
	public static function __compileDepthOrders():Void{
		var rawDepthOrders:Array<Dynamic>=ExptWideSpecs.IS("blockDepthOrder").split(",");
		
		var depthSettings:Dynamic;
		for(i in 0...rawDepthOrders.length){
			__processDepth(rawDepthOrders[i],depthSettings);
		}
	}
	
	public static function __processDepth(depth:String,depthSettings:Dynamic):Void{
		
	}
	
	public static function __computeOrders(trialBlocks:Array):Void
	{
		
		__depthOrders=new Array<String>;
		
		var depth:Int;
		
		var bulkDepthsSet:Array<Dynamic>;
		
		for(i in 0...trialBlocks.length){
			bulkDepthsSet=[];
			depth=trialBlocks[i].blocksVect.length-1;

			
			if(__depthOrders.length<depth)			addDepths(__depthOrders,depth - __depthOrders.length)
			__depthOrders[depth]=trialBlocks[i].blockDepthOrder;
		
			
			if(trialBlocks[i].blockDepthOrderings){
				bulkDepthsSet.push(trialBlocks[i].blockDepthOrderings);
			}
		}			
		
		if(bulkDepthsSet.length>0){
			
			if(__depthOrders.length<bulkDepthsSet.length)addDepths(__depthOrders,bulkDepthsSet.length - __depthOrders.length)
			
			for(i=0;i<bulkDepthsSet.length;i++){
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