package xpt.trial;
import script.XML_tools;
import thx.Ints;
import thx.Tuple.Tuple2;
import xpt.trial.TrialInfo;
using xpt.trial.GotoTrial;

/**
 * ...
 * @author 
 */
class NextTrialBoss
{
	

	
	var __trialSkeletons:Array<TrialSkeleton>;
	var skeletonLookup:Map<Int,TrialSkeleton>;
	public var __trialOrder:Array<Int>;
	public var currentTrial:Int;

	
	public function new(trialOrder_skeletons:Tuple2<	Array<Int>,	Array<TrialSkeleton>	> )
	{
		this.__trialOrder = trialOrder_skeletons._0;
		this.__trialSkeletons = trialOrder_skeletons._1;
		skeletonLookup = __generateLookup(__trialSkeletons);
		
		currentTrial = 0;
		//this.progressDict = ProgressFactory.make(script);
		
	}
	

	
	static public function __generateLookup(__trialSkeletons:Array<TrialSkeleton>):Map<Int,TrialSkeleton>
	{
		var s = new Map<Int,TrialSkeleton>();
		
		for (skeleton in __trialSkeletons) {
			trace(skeleton.trials, 22);
			for (t in skeleton.trials) {
				if (s.exists(t)) throw "devel err";
				s.set(t, skeleton);
			}
		}
		return s;
	}
	
	public function getTrial(nextCommand:GotoTrial,prevTrial:Trial):Tuple2<TrialSkeleton,Int>{

		//var nextTrialNum:Int = -1;
/*		if(progressDict && prevTrial.trialOrderScheme && progressDict.hasOwnProperty(prevTrial.trialOrderScheme) && [GotoTrialEvent.NEXT_TRIAL,GotoTrialEvent.PREV_TRIAL].indexOf(nextCommand)!=-1){
			var a:int = (progressDict[prevTrial.trialOrderScheme] as Progress).getNextTrial(prevTrial,currentTrial);
			currentTrial = a;
			return computeRunningTrial();	
		}*/
		
		switch(nextCommand){
		
			case Next:
				currentTrial++;
				return computeRunningTrial();	
			
			
			case Previous:
				currentTrial--;
				if(currentTrial<0)currentTrial=0;
			
			case First:
				currentTrial=0;
			
			case Last:
				currentTrial=__trialOrder.length-1;
			
			case Again:
				"";
			
			case Number(num):
				currentTrial=num;
				
			case Name(nam):
				var i:Int = getTrialFromName(nam);
				if (i == -1) throw "You asked to goto trial '"+nam +"' which doesn't exist";
				currentTrial=i;
			}

		return computeRunningTrial();	
	}
	
	
	public function getTrialFromName(nam:String):Int {
		for (skeleton in __trialSkeletons) {
			var i:Int = skeleton.names.indexOf(nam);
			
			if (i != -1) return skeleton.trials[i];
		}
		return -1;
	}
	
	
	public function nextTrial():Tuple2<TrialSkeleton,Int>
	{	
		currentTrial++;
		return computeRunningTrial();
	}
	
	public function firstTrial():Tuple2<TrialSkeleton,Int>
	{	
		return computeRunningTrial(0);
	}
	
	/*public function findTrialNum(t:Int):Int{
		
		for(i in 0...trialOrder.length){
			if(trialOrder[i]==t)	return i;
		}
		
		return 0;
	}*/
	
	public function computeRunningTrial(forceTrial:Int = -1):Tuple2<TrialSkeleton,Int>{

		if (__trialOrder.length < currentTrial) throw "You have asked to go to a trial number that is bigger than the total number of trials stored: "+currentTrial+"/"+Std.string(__trialOrder.length-1);
		else if (currentTrial < 0) throw "You have asked to go to a negative trial number: " + Std.string(currentTrial);
		

		if (forceTrial != -1) {
				currentTrial = forceTrial;
		}
		
		var lookup:Int = __trialOrder[currentTrial];
		
		var skeleton:TrialSkeleton = skeletonLookup.get(lookup);
		
		return new Tuple2(skeleton, currentTrial);
	}
	
}