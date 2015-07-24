package xpt.trialOrder_old;

import xpt.trialOrder_old.components.blockOrder.OrderBlocksBoss;
import xpt.trialOrder_old.components.blockOrder.TrialBlock;

class trialOrderFunctions {
	
	
	//static var blockSize:Int;
	//static var numBlocks:Int;
	//private static var randFirstOrder:String;
	//private static var randSecondOrder:String;		
	
	
	public static function computeOrder(trialProtocolList:XML,composeTrial:Function):Array{
		sortOutShuffles(trialProtocolList)
		
		var orderBlocksBoss:OrderBlocksBoss=new OrderBlocksBoss();
		
		
		var counter:Int=0;
		var trialBlock:TrialBlock;
		var trials:Array<Dynamic>;
		//trace(Math.random(),33)
		for(var i:Int=0;i<trialProtocolList.TRIAL.length();i++){ //for block of trials
			trialBlock=new TrialBlock;
			
			trialBlock.setup(trialProtocolList.TRIAL[i],counter,i,composeTrial)
			//trace(i,trialProtocolList.TRIAL[i])
			if(trialBlock.numTrials>0){	//ignore trials that say zero trials
				orderBlocksBoss.giveBlock(trialBlock);
				counter=trialBlock.getMaxTrial()+1;
			}	
		}
		
		var trialOrder:Array<Dynamic>=orderBlocksBoss.compose();

		orderBlocksBoss.kill();

		return trialOrder;
	}
			
	
	
	private static function sortOutShuffles(trialProtocolList:XML):Void
	{
		var list:XMLList=trialProtocolList.TRIAL.(hasOwnProperty("@shuffle_block"));
		var blockList:Array<Dynamic>=[];
		
		for(var trial:XML in list){
			blockList.push(trial.@block.toString());
		}
		
		var randArr:Array<Dynamic>=randomizeArray(blockList)
		
		for(trial in list){
			trial.@block=Std.string(randArr.shift());
		}
	}
	
	private static function randomizeArray(array:Array):Array {
		var newArray:Array<Dynamic>=new Array();
		while(array.length>0){
			var obj:Array<Dynamic>=array.splice(Math.floor(Math.random()*array.length), 1);
			newArray.push(obj[0]);
		}
		return newArray<Dynamic>;
	}
	
	

	private static function shuffleArray(a:Array):Array {
		var a2:Array<Dynamic>=[];
		while(a.length>0){
			a2.push(a.splice(Math.round(Math.random()*a.length-1),1)[0]);
		}
		return a2;
	}
	
	
	
	private static function genRepetition(num:Int):Array {
		var repArray:Array<Dynamic>=new Array<Dynamic>;
		for(i in 0...num){
			repArray.push(i+1);
		}
		return repArray<Dynamic>;
	}
}