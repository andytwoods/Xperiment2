package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.VerticalContinuousLayout;
import thx.Arrays;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.NonVisual_Tools;
import xpt.tools.XRandom;

class StimShuffle extends StimulusBuilder_nonvisual {
    private var _trialStarted:Bool = false;
    private var _shuffleAdded:Bool = false;
    private var _shuffled:Bool = false;
    private var stims:Array<Stimulus>;
	private var my_results:Map<String,String>;
	
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
        if (_trialStarted == false || _shuffleAdded == false || _shuffled == true) {
            return;
        }

        stims = NonVisual_Tools.getStims(trial, this);   
		if (stims.length == 0) return;
			
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
		
		var groupSize:Int = stims.length;
		var memory_id:String = null;
		var groupSizeStr = get('groupSize');
		if (groupSizeStr.length > 0) {
			groupSize = Std.parseInt(groupSizeStr);
			if(groupSize>1) memory_id = XRandom.string(10);
		}
		
		if (stims.length % groupSize != 0) throw '';
		
		for (group_of_stim in Arrays.splitBy(stims, groupSize)) {
			engine(group_of_stim, fixedArray, memory_id);
		}
		
        _shuffled = true;
		log_results();
    }
	

	inline function engine(my_stims:Array<Stimulus>, fixedArray:Array<String>, memory_id:String) {
		DebugManager.instance.info("Shuffling " + my_stims.length + " stim(s)");
		StimHelper.shuffleArrangement(my_stims, fixedArray, memory_id);
	}
	
	override public function results():Map<String,String> {
		return my_results;
	}
	
	function log_results() {

		if (exists('save') == false) return;

		var saveArr:Array<String> = getStringArray('save', null);
		if (saveArr == null || saveArr.length == 0) return null;
		
		my_results = new Map<String,String>();
		var key:String;
		var val:String;
		
		for (saveKey in saveArr) {
			for (_stim in stims) {	
				key = stim.id + "_" + _stim.id + "_" + saveKey;
				val = Std.string(_stim.get('x'));
				my_results.set(key, val);	
				
			}
		}
	}
	

	
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() { // could happen instantly, could happen after a give time
        _shuffleAdded = true;
        performShuffle();
    }
	
	override public function kill() {
		stims = null;
		super.kill();
	}
}