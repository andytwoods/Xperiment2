package xpt.trial;
import openfl.display.Sprite;
import xpt.stimuli.Stimulus;
//import xpt.behaviour.Behaviour;

/**
 * ...
 * @author ...
 */
class Trial extends Sprite
{

	public var stimuli:Array<Stimulus> = [];
	public var iteration:Int;
	public var trialNum:Int;
	
	
	public function new() 
	{
		super();
		
		//Behaviour.addTrial(this);

		
	}
	
	public function addStimulus(stim:Stimulus) 
	{
		stimuli[stimuli.length] = stim;
	}
	
}