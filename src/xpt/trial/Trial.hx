package xpt.trial;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.events.UIEvent;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.Lib;
import xpt.stimuli.Stimulus;
import xpt.timing.TimingBoss;
//import xpt.behaviour.Behaviour;


enum Trial_Action {
	End;
	
	
	
}



class Trial 
{

	public var stimuli:Array<Stimulus> = [];
	public var iteration:Int;
	public var trialNum:Int;
	public var trialName:String;
	public var trialBlock:Int;
	public var specialTrial:Special_Trial;
	public var hideResults:Bool = false;
	public var timingBoss:TimingBoss;
	
	public static var testing:Bool = false;
	
	public static var stage = Lib.current.stage;
	
	public var callBack:Trial_Action -> Void;
	
	
	public function setSpecial(special:Special_Trial) {
		specialTrial = special;
	}
	
	function action(action:Trial_Action) 
	{
		if (callBack != null) callBack(action);
	}

	
	public function new() 
	{
		if (testing == false) {
			timingBoss = new TimingBoss();
		}
		//stage.addChild(timingBoss);
		
	
		
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
		var root = Toolkit.openFullscreen();
		var button:Button = new Button();
            button.text = "Click Me!";
            button.x = 100;
            button.y = 100;
            button.addEventListener(UIEvent.CLICK, function(e:UIEvent) {
                e.component.text = "You clicked me!";
				
            });
            root.addChild(button);
			
		//var fps_mem = new FPS_mem();
		
		
		//stage.addChild(fps_mem);

		
	}
	
	public function getResults():Xml {
	
		return ExtractResults.DO(this);
	}
	

	

	
}