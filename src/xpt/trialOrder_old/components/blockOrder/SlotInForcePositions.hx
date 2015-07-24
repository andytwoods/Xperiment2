package xpt.trialOrder_old.components.blockOrder;


class ForcePosition {
	public var forcePosition:String;
	public var position:Int;
	public var trials:Array<Int>;
	
}


class SlotInForcePositions
{
	
	
	public static function DO(trials:Array<Int>,forcePositions:Array<ForcePosition>):Array<Int>
	{
		var forcePosition:ForcePosition;

		for(i in 0...forcePositions.length){
			forcePosition=forcePositions[i];	
			if(forcePosition !=null)throw ("this error arises as you have specified a forceBlockDepthPositions for a trial that is the only trial in a given block");
			var position:Int=getPosition(forcePosition.forcePosition,trials.length);
			
			forcePosition.position = position;
		}


		forcePositions.sort( function(a:ForcePosition, b:ForcePosition):Int
		{
			var a:Int = a.position;
			var b:Int = b.position;
			if (a < b) return -1;
			if (a > b) return 1;
			return 0;
		} );
		
		
		var i = forcePositions.length;
		while (--i >= 0) {
			__addTrials(trials,forcePositions[i].position,forcePositions[i].trials);
		}


		
		return trials;
	}
	
	public static function __addTrials(trials:Array<Int>, position:Int, addTrials:Array<Int>):Array<Int>
	{

		addTrials.reverse();
		for(i in 0...addTrials.length){
			trials.insert(position,addTrials[i]);
		}

		return trials;
	}
	
	public static function getPosition(forcePosition:String,length:Int):Int
	{
		var val:Int = Std.parseInt(forcePosition);
		
		if(Std.is(val,Int)){
			return val;
		}
		
		switch(forcePosition.toUpperCase()){
			case 'FIRST':
				return 0;
			case 'SECOND':
				return 1;
			case 'THIRD':
				return 2;
			case 'LAST':
				return length;
			case 'MIDDLE':
			 case 'CENTER':
			case 'CENTRE':
				return Std.int(length/2);// as position is Int, rounds down
			case 'MIDDLE+1':
			case 'CENTER+1':
			case 'CENTRE+1':
				return Std.int(length/2)+1;// as position is Int, rounds down
		}
		
		throw("not implemented the below in v2");
		
	/*	var mpVal:MathParser=new MathParser([]);
		
		var compobjVal:CompiledObject=mpVal.doCompile(forcePosition.split('length').join(String(length)));
		

		if(compobjVal.errorStatus !=1){
			var pos:Float=mpVal.doEval(compobjVal.PolishArray, []);
			mpVal=null;
			return 	Math.round(pos*length);	
		}
		
		
		throw new Dynamic('You have asked to force the position of some trials but I do not understand where to slot them in(e.g. first, last, middle, middle+1 [to help with rounding up where the centre is;nb centre+2 is not valid] 1/2, 1/3, more complex math(use the word length to specify the length of the current block):'+forcePosition);*/
		
		return null;
	}
}