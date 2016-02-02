package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.VerticalContinuousLayout;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;

class StimShuffle extends StimulusBuilder {
    private var _trialStarted:Bool = false;
    private var _suffleAdded:Bool = false;
    private var _shuffled:Bool = false;
    
    public function new() {
        super();
        Scripting.experiment.addEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;
	}
    
    private function onTrialStarted(e:ExperimentEvent) {
        Scripting.experiment.removeEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
        _trialStarted = true;
        performShuffle();
    }
		
    
    /*
    We want to be a little careful here as if we put the shuffle before the group in the xml
    then the stims might not exist in the trial / groups. The way round that is to use the event
    listeners to make sure that the trial has started AND the suffle stim is added (it might not be
    added until a timer event of course
    */
    private function performShuffle() {
        if (_trialStarted == false || _suffleAdded == false || _shuffled == true) {
            return;
        }
        
        var groupsArray:Array<String> = [];
        
        var groups:String = get("groups");
        if (groups != null) {
            groupsArray = groupsArray.concat(groups.split(","));
        }
        
        var group:String = get("group");
        if (group != null) {
            groupsArray.push(group);
        }
        
        var uniqueGroups:Array<String> = []; // lets add unique groups and trim them for good measure
        for (g in groupsArray) {
            g = StringTools.trim(g);
            if (uniqueGroups.indexOf(g) == -1) {
                uniqueGroups.push(g);
            }
        }
        
        if (uniqueGroups.length > 0) {
            var stims:Array<Stimulus> = [];
            for (g in uniqueGroups) {
                var groupStims:Array<Stimulus> = Stimulus.getGroup(g);
                if (groupStims != null) {
                    stims = stims.concat(groupStims);
                }
            }
            
            if (stims.length > 0) { // lets do the shuffle
                var fixed:String = get("fixed");
                var fixedArray:Array<String> = null;
                if (fixed != null) {
                    fixedArray = new Array<String>();
                    var temp:Array<String> = fixed.split(",");
                    for (t in temp) {
                        t = StringTools.trim(t);
                        if (fixedArray.indexOf(t) == -1) {
                            fixedArray.push(t);
                        }
                    }
                }
                
                DebugManager.instance.info("Shuffling " + stims.length + " stim(s)");
                StimHelper.shuffleArrangement(stims, fixedArray);
            }
            
        }
        
        _shuffled = true;
    }
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() { // could happen instantly, could happen after a give time
        _suffleAdded = true;
        performShuffle();
    }
}