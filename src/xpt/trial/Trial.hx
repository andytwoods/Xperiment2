package xpt.trial;
import openfl.display.Sprite;
import xpt.stimuli.Stimulus;
//import xpt.behaviour.Behaviour;


enum Trial_Action {
	End;
	
	
	
}

class Trial extends Sprite
{

	public var stimuli:Array<Stimulus> = [];
	public var iteration:Int;
	public var trialNum:Int;
	public var trialName:String;
	
	public var callBack:Trial_Action -> Void;
	
	function action(action:Trial_Action) 
	{
		if (callBack != null) callBack(action);
	}

	
	public function new() 
	{
		super();
		
		//Behaviour.addTrial(this);
	}
	
	public function addStimulus(stim:Stimulus) 
	{
		stimuli[stimuli.length] = stim;
	}
	
	public function kill() 
	{
		for (stimulus in stimuli) {
			stimulus.kill();
		}
	}
	
	public function start() 
	{
		
	}
	

	
}