package xpt.trial;

import openfl.Lib;
import xpt.experiment.Experiment;
import xpt.results.TrialResults;
import xpt.stimuli.Stimulus;
import xpt.timing.TimingManager;
//import xpt.timing.TimingBoss;

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
	//public var timingBoss:TimingBoss;
	
	public static var testing:Bool = false;
	
	public static var stage = Lib.current.stage;
	
	public var callBack:Trial_Action -> Void;
	
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
			//timingBoss = new TimingBoss();
			TimingManager.instance.reset();
		}
	}
	
	public function addStimulus(stim:Stimulus) {
		stimuli[stimuli.length] = stim;
		if (testing == false) {
			//timingBoss.add(stim);
			TimingManager.instance.add(stim);
		}
	}
	
	public function kill() {
		if (testing == false) {
			TimingManager.instance.reset();
			/*
			timingBoss.kill();
			timingBoss = null;
			*/
		}
		
		for (stimulus in stimuli) {
			stimulus.kill();
		}	
	}
	
	public function start() {
		if (testing == false) {
			//timingBoss.start(true);
			TimingManager.instance.start();
		}
		
		// TODO: duplication of stimuli here, doesnt happen once they are in TimingBoss - but should be investigated
		// trace("" + stimuli);
	}
	
	public function getResults():TrialResults {
		return ExtractResults.DO(this);
	}
}