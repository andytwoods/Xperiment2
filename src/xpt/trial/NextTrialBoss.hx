package xpt.trial;
import haxe.Constraints.Function;
import thx.Tuple.Tuple2;
import xpt.tools.XML_tools;
import thx.Ints;
import xpt.trial.NextTrialBoss.NextTrialInfo;
import xpt.trial.TrialInfo;
using xpt.trial.GotoTrial;


enum NextTrialBoss_actions{
	BeforeLastTrial;	
	BeforeFirstTrial;
}

typedef NextTrialInfo = {
	var skeleton:TrialSkeleton;
	var trialOrder:Int;
	@:optional var action:NextTrialBoss_actions;
}


class NextTrialBoss
{
	
	public var __trialSkeletons:Array<TrialSkeleton>;
	public var __skeletonLookup:Map<Int,TrialSkeleton>;
	public var __trialOrder:Array<Int>;
	public var currentTrial:Int;
	
	public var callBack:NextTrialBoss_actions->Void;

	
	public function new(trialOrder_skeletons:Tuple2<	Array<Int>,	Array<TrialSkeleton>	> )
	{
		this.__trialOrder = trialOrder_skeletons._0;
		this.__trialSkeletons = trialOrder_skeletons._1;
		__skeletonLookup = __generateLookup(__trialSkeletons);

		currentTrial = 0;
		//this.progressDict = ProgressFactory.make(script);
		
	}
	
	
	function action(action:NextTrialBoss_actions) 
	{
		if (callBack != null) callBack(action);
	}

	
	static public function __generateLookup(__trialSkeletons:Array<TrialSkeleton>):Map<Int,TrialSkeleton>
	{
		var s = new Map<Int,TrialSkeleton>();
		
		for (skeleton in __trialSkeletons) {
			for (t in skeleton.trials) {
				//trace(1111, t);
				if (s.exists(t)) throw "devel err";
				s.set(t, skeleton);
			}
		}
		return s;
	}
	
	public function getTrial(nextCommand:GotoTrial,prevTrial:Trial):NextTrialInfo{

		switch(nextCommand){
		
			case Next:
				currentTrial++;
				
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
	
	
	public function nextTrial():NextTrialInfo
	{	
		currentTrial++;
		return computeRunningTrial();
	}
	
	public function firstTrial():NextTrialInfo
	{	
		return computeRunningTrial(0);
	}
	
	/*public function findTrialNum(t:Int):Int{
		
		for(i in 0...trialOrder.length){
			if(trialOrder[i]==t)	return i;
		}
		
		return 0;
	}*/
	
	public function computeRunningTrial(forceTrial:Int = -1):NextTrialInfo{


		
		if (__trialOrder.length < currentTrial) throw "You have asked to go to a trial number that is bigger than the total number of trials stored: "+currentTrial+"/"+Std.string(__trialOrder.length-1);
		else if (currentTrial < 0) throw "You have asked to go to a negative trial number: " + Std.string(currentTrial);
				
		
		if (forceTrial != -1) {
				currentTrial = forceTrial;
		}
		

		var lookup:Int = __trialOrder[currentTrial];
		//trace(__trialOrder, currentTrial,111,lookup,__trialOrder);
		//trace(111, skeletonLookup);
		var skeleton:TrialSkeleton = __skeletonLookup.get(lookup);
		
		var info:NextTrialInfo = { skeleton: skeleton,  trialOrder: lookup };
		
		if (currentTrial == __trialOrder.length) info.action = BeforeLastTrial;
		else if (currentTrial == 0) info.action = BeforeFirstTrial;
				

		
		return info;
	}
	

	
}