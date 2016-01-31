package xpt.trial;

import diagnositics.DiagnosticsManager;
import haxe.ui.toolkit.core.Component;
import openfl.events.TimerEvent;
import openfl.Lib;
import openfl.utils.Timer;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.experiment.Experiment;
import xpt.stimuli.StimuliFactory;
import xpt.stimuli.Stimulus;
import xpt.timing.TimingManager;
import xpt.tools.XTools;
//import xpt.timing.TimingBoss;

enum Trial_Action {
	End;
}

class Trial {
	
	static public var _ITI:Int;
	
	public var ITI:Int;
	public var stimuli:Array<Stimulus> = [];
	public var iteration:Int;
	public var trialNum:Int;
	public var trialName:String;
	public var trialBlock:Int;
	public var specialTrial:Special_Trial;
	public var hideResults:Bool = false;
	//public var timingBoss:TimingBoss;
	public var codeStartTrial:String;
	public var codeEndTrial:String;
	public var stimuliFactory:StimuliFactory;
	
	public static var testing:Bool = false;
	
	public static var stage = Lib.current.stage;
	
	public var callBack:Trial_Action -> Void;
	
	public var experiment:Experiment;
	
    private var _valid:Null<Bool> = null; // lets start the trail off as neither valid or invalid for good measure
    
    public var stimValuesValid(get, null):Bool;
    private function get_stimValuesValid():Bool {
        if (ExptWideSpecs.IS("validationEnabled", false) == "false") {
            return true;
        }

        var valid:Bool = true;
        for (stim in stimuli) {
            if (stim.isValid == false) {
                valid = false;
                break;
            }
        }
        return valid;
    }
    
    public function validateStims() {
        var stimsValid:Bool = stimValuesValid;
        if (_valid != stimsValid) {
            _valid = stimsValid;
            DebugManager.instance.info("Trail valid state changed to: " + _valid);
            
            // dispatch the event
            var event:ExperimentEvent = null;
            if (_valid == true) {
                event = new ExperimentEvent(ExperimentEvent.TRAIL_VALID);
            } else {
                event = new ExperimentEvent(ExperimentEvent.TRAIL_INVALID);
            }
            event.trail = this;
            experiment.dispatchEvent(event);
        }
    }
    
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
	
    public function findStimulus(stimId:String):Stimulus {
        var stim:Stimulus = null;
        for (s in stimuli) {
            if (s.id == stimId) {
                stim = s;
                break;
            }
        }
        return stim;
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
        DiagnosticsManager.add(DiagnosticsManager.TRIAL_START, trialName);
		if (testing == false) {
			XTools.delay(ITI, function() { 
				TimingManager.instance.start();
                /*
				for (stim in stimuli) {
					stim.component.invalidate();
				}
				*/
			});
		}
		
		// TODO: duplication of stimuli here, doesnt happen once they are in TimingBoss - but should be investigated
		// trace("" + stimuli);
	}
	

	
	public function overrideDefaults(potentialOverrides:Map<String, String>) 
	{
		//ternary operator (https://learnxinyminutes.com/docs/haxe/).
		ITI = (potentialOverrides.exists('ITI') == false) ? _ITI : Std.parseInt(potentialOverrides.get('ITI'));
	}
}