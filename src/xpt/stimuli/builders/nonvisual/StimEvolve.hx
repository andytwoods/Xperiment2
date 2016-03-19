package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.VerticalContinuousLayout;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.NonVisual_Tools;

class StimEvolve extends StimulusBuilder {
    private var _trialStarted:Bool = false;
    private var _suffleAdded:Bool = false;
    private var _shuffled:Bool = false;
	var stims:Array<Stimulus>;
    
    public function new() {
        super();
        Scripting.experiment.addEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
		Scripting.experiment.addEventListener(ExperimentEvent.TRIAL_END, onTrialEnded);
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;
	}
    
    private function onTrialStarted(e:ExperimentEvent) {
        Scripting.experiment.removeEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
        _trialStarted = true;
		
		this.stims = NonVisual_Tools.getStims(trial, this);
		

    }

	private function onTrialEnded(e:ExperimentEvent) {
        Scripting.experiment.removeEventListener(ExperimentEvent.TRIAL_START, onTrialEnded);

		trace(11);
    }
    
   
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() { // could happen instantly, could happen after a give time
        _suffleAdded = true;
    }
}

class StimEvolveManager {

	
	
	
}