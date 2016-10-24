package xpt.stimuli.builders.nonvisual;
import openfl.events.Event;
import openfl.events.MouseEvent;
import xpt.stimuli.builders.basic.StimButton;
import xpt.tools.XRandom;
import xpt.tools.XTools;
import code.Scripting;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.layout.VerticalContinuousLayout;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.stimuli.tools.NonVisual_Tools;
import xpt.trial.Trial;

class StimSchedule extends StimulusBuilder_nonvisual {
    private var _trialStarted:Bool = false;
    private var _scheduleAdded:Bool = false;
    private var _scheduled:Bool = false;
	private var schedule:Schedule;
    
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

        performSchedule();
    }
			
	override public function next(stim:Stimulus) {
		schedule.next(stim.id);
	}
    
    private function performSchedule() {

		if (_trialStarted == false || _scheduleAdded == false || _scheduled == true) {
            return;
        }
		_scheduled = true;
    
		var paramsStr = get('schedule');
		if (paramsStr == null || paramsStr.length==0) return;
		paramsStr = paramsStr.split(" ").join("");
		schedule = new Schedule(paramsStr, trial.stimuli);
		if (getBool('random') == true) schedule.randomise();
		schedule.next();
        
    }
	
	

	
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() { // could happen instantly, could happen after a give time
        _scheduleAdded = true;
        performSchedule();
    }
}

class Schedule {
	var levels:Array<Level>;
	var currentLevel:Level;
	var trial:Trial;
	
	public function new(paramsStr:String, stimuli:Array<Stimulus>) {
		var stimuliMap:Map<String, Stimulus> = XTools.stimuli_to_map(stimuli);
		var level:Level;
		for (levelStr in paramsStr.split(";")) {
			level = new Level(levelStr, stimuliMap);
			if (levels == null) {
				levels = new Array<Level>();
			}
			levels.push(level);
		}
	}
	
	public function randomise() {
		levels = XRandom.shuffle(levels);
	}
	
	
	public function next(id:String = null) {
		if(id!=null){
			if (currentLevel.exists(id) == false) {
				throw 'unknown stimulus pinged Schedule: '+id;
			}
		}
		if(currentLevel!=null)	currentLevel.kill();
		
		currentLevel = levels.shift();
		if(currentLevel != null) currentLevel.init();
		
	}

	
	public function kill() {
		if (levels == null) return; //already been disposed;
		for (level in levels) {
			level.kill();
		}
		levels = null;
		currentLevel = null;
	}
	
	
}

class Level {
	var stims:Array<Stimulus>;
	
	public function exists(id:String):Bool {
		for (stim in stims) {
			if (stim.id == id) return true;
		}
		return false;
	}
	
	public function new(levelStr:String, stimuliMap:Map<String, Stimulus>) {
		var stim:Stimulus;
		var listener = null;
		for (stimStr in levelStr.split(",")) {
			if (stims == null) {
				stims = new Array<Stimulus>();
			}
			
			stim = stimuliMap[stimStr];
			trace(stimStr, 343);
			if (stim == null) throw 'unknown stimulus asked for:' + stim;
			stims.push(stim);
		}
	}
	
	public function init() {
		for (stim in stims) {
			stim.builder.trial.addStimulus(stim);
		}
	}
	

	
	public function kill() {
		for (stim in stims) {
			stim.builder.trial.removeStimulus(stim);
		}
		stims = null;
	}
}
