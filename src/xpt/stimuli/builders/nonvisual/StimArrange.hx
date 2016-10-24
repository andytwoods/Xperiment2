package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import haxe.ui.toolkit.core.Component;
import openfl.geom.Rectangle;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.NonVisual_Tools;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;

class StimArrange extends StimulusBuilder_nonvisual {
    private var _trialStarted:Bool = false;
    private var _arrange_added_to_trial:Bool = false;
    private var _arranged:Bool = false;
    
    public function new() {
        super();
        Scripting.experiment.addEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;
		var root:Root = RootManager.instance.currentRoot;
		sortDimensions(c, root);
		sortPosition(c, root);
		sort_alignment(c);
	}
    
    private function onTrialStarted(e:ExperimentEvent) {
        Scripting.experiment.removeEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
        _trialStarted = true;
        performArrange();
    }
		
    
    private function performArrange() {
        if (_trialStarted == false || _arrange_added_to_trial == false || _arranged == true) {
            return;
        }
        
        var stims = NonVisual_Tools.getStims(trial, this);
		
		//if width and height HAVE been defined
		if (get('width') != "" && get('height') != "") {
			var bounding_box:Rectangle = new Rectangle(stim.component.x, stim.component.y, stim.component.width, stim.component.height);
			StimHelper.arrange_in_box(bounding_box, stims);
		}
            
		else if (stims.length > 2) {
			StimHelper.arrange(stims);
		}
            
        
        
        _arranged = true;
    }
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() { // could happen instantly, could happen after a give time
        _arrange_added_to_trial = true;
        performArrange();
    }
}