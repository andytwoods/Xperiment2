package xpt.trial;

import haxe.ui.toolkit.util.CallStackHelper;
import motion.Actuate;
import openfl.events.TimerEvent;
import openfl.Lib;
import openfl.utils.Timer;
import xpt.experiment.Experiment;
import xpt.results.TrialResults;
import xpt.stimuli.Stimulus;
import xpt.timing.TimingManager;

enum Trial_Action {
	End;
}

class Trial {
	public static var stage = Lib.current.stage;
	public static var testing:Bool = false;
	static public var _ITI:Int;
	
	public var stimuli:Array<Stimulus> = [];
	public var iteration:Int;
	public var trialNum:Int;
	public var trialName:String;
	public var trialBlock:Int;
	public var specialTrial:Special_Trial;
	public var hideResults:Bool = false;
	public var otherParams:Map<String,String>;
	public var codeEndTrial:String;
	public var codeStartTrial:String;	
	public var callBack:Trial_Action -> Void;
	public var ITI:Int;
	
	public var experiment:Experiment;
	
	public function setSpecial(special:Special_Trial) {
		specialTrial = special;
	}
	
	function action(action:Trial_Action) {
		if (callBack != null) callBack(action);
	}

	public function new(experiment:Experiment) {
		this.experiment = experiment;
		if (testing == false) {
			TimingManager.instance.reset();
		}
	}
	
	public function addStimulus(stim:Stimulus) {
		stimuli.push( stim );
		if (testing == false) {
			TimingManager.instance.add(stim);
		}
	}
	
	public function kill() {
		if (testing == false) {
			TimingManager.instance.reset();
		}
		
		for (stimulus in stimuli) {
			stimulus.kill();
		}	
	}
	
	public function start() {
		
		if (testing == false) {
			var t:Timer = new Timer(ITI);
					
			function timerEnd(e:TimerEvent){
				t.removeEventListener(TimerEvent.TIMER, timerEnd);
				t.stop();
				TimingManager.instance.start();
			}
			t.addEventListener(TimerEvent.TIMER, timerEnd);
			t.start();

		}
	}
	
	public function overrideDefaults(potentialOverrides:Map<String, String>) 
	{
		//ternary operator (https://learnxinyminutes.com/docs/haxe/).
		ITI = (potentialOverrides.exists('ITI') == false) ? _ITI : Std.parseInt(potentialOverrides.get('ITI'));
	}
}