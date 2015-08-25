package xpt.trialOrder;

import haxe.Json;
import xpt.trialOrder.TrialBlock.ForceBlockPosition;

class SlotInForcePositions
{

	
	public static function DO(trials:Array<Int>,forcePositions:Array<	ForceBlockPosition	>):Array<Int>
	{


		
		for(i in 0...forcePositions.length){
			var forcePosition:ForceBlockPosition = forcePositions[i];	

			//below is wrong in orig code
			//if (forcePosition == null) throw "this error arises as you have specified a forceBlockDepthPositions for a trial that is the only trial in a given block";
//trace(forcePosition, forcePosition.positionStr, 34);


			forcePosition.position = getPosition(forcePosition.positionStr, trials.length);
		}

		forcePositions.sort( 
			function(a:ForceBlockPosition, b:ForceBlockPosition):Int{
			return Reflect.compare(a.position, b.position); }
			);
	
		
		var i = forcePositions.length-1;
		while (i >= 0) {	
			__addTrials(trials, forcePositions[i].position, forcePositions[i].trials);
			i--;
		}

		return trials;
	}
	
	public static function __addTrials(trials:Array<Int>, position:Int,addTrials:Array<Int>):Array<Int>{

		addTrials.reverse();

		for(i in 0...addTrials.length){
			trials.insert(position, addTrials[i]);
		}

		return trials;
	}
	
	public static function getPosition(forcePosition:String,length:Int):Int
	{
		//trace(forcePosition, length, 34);
		
		if (Std.parseInt(forcePosition) != null && forcePosition.indexOf("/") == -1) {
			var val:Int = Std.parseInt(forcePosition);
			if (val == 0) throw "problem forcing a trial position. Values start from 1, NOT 0.";
			return val-1;
		}
		//trace(1111, forcePosition.toUpperCase());
		switch(forcePosition.toUpperCase()){
			case 'FIRST':
				return 0;
			case 'SECOND':
				return 1;
			case 'THIRD':
				return 2;
			case 'LAST':
				return length;
			case 'MIDDLE'|'CENTER'| 'CENTRE' :
				return Math.round(length/2); // as position is int, rounds down
			case 'MIDDLE+1' | 'CENTER+1' | 'CENTRE+1':
				return Math.round(length / 2 + 1); // as position is int, rounds down		
			case "1/2":
				return Math.round(length / 2); // as position is int, rounds down	
			case "1/4":
				return Math.round(length / 4 );
			case "3/4":
				return Math.round(length / 4 * 3 );	
			case "1/3":
				return Math.round(length / 3 );
			case "2/3":
				return Math.round(length / 3 * 2  );
		}
		
		throw 'You have asked to force the position of some trials but I do not understand where to slot them in (e.g. first, last, middle, middle+1 [to help with rounding up where the centre is; nb centre+2 is not valid] 1/2, 1/3, more complex math (use the word length to specify the length of the current block): '+forcePosition;
		
		return -1000;
	}
	
}