package xpt.trial;
import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.events.UIEvent;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.Lib;
import xpt.results.TrialResults;
import xpt.stimuli.Stimulus;
import xpt.timing.TimingBoss;
//import xpt.behaviour.Behaviour;


enum Trial_Action {
	End;
}

class Trial {
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
	
	function action(action:Trial_Action) {
		if (callBack != null) callBack(action);
	}

	public function new() {
		if (testing == false) {
			timingBoss = new TimingBoss();
		}
	}
	
	public function addStimulus(stim:Stimulus) {
		stimuli[stimuli.length] = stim;
		if (testing == false) {
			timingBoss.add(stim);
		}
	}
	
	public function kill() {
		if (testing == false) {
			timingBoss.kill();
			timingBoss = null;
		}
		
		for (stimulus in stimuli) {
			stimulus.kill();
		}	
	}
	
	public function start() {
		if (testing == false) {
			timingBoss.start(true);
		}
		
		var root = RootManager.instance.currentRoot;//Toolkit.openFullscreen();
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
	
	public function getResults():TrialResults {
		return ExtractResults.DO(this);
	}
}