package xpt.experiment;

import assets.manager.FileLoader;
import code.CheckIsCode;
import code.CheckIsCode.RunCodeEvents;
import code.Scripting;
import haxe.ui.toolkit.hscript.ScriptInterp;
import openfl.events.EventDispatcher;
import openfl.utils.Object;
import xpt.debug.DebugManager;
import xpt.experiment.Preloader.PreloaderEvent;
import xpt.results.Results;
import xpt.script.ProcessScript;
import xpt.stimuli.BaseStimuli;
import xpt.stimuli.StimuliFactory;
import xpt.stimuli.Stimulus;
import xpt.trial.GotoTrial;
import xpt.trial.NextTrialBoss;
import xpt.trial.Special_Trial;
import xpt.trial.Trial;
import xpt.trial.TrialFactory;
import xpt.trial.TrialSkeleton;
import xpt.trialOrder.TrialOrder;

@:allow(xpt.trialOrder.Test_TrialOrder)
class Experiment extends EventDispatcher {
	private var nextTrialBoss:NextTrialBoss;
	private var script:Xml;
	private var runningTrial:Trial;
	private var results:Results = new Results();
	private var currentTrailInfo:NextTrialInfo = null;
	private var trialFactory:TrialFactory = new TrialFactory();
	
	public var scriptEngine:ScriptInterp = new ScriptInterp();
	
	public function new(script:Xml, url:String = null, params:Object = null) {
		super();
		linkups();
		
		if (script == null) return; //used for testing
		this.script = script;
		
		Scripting.DO(script, RunCodeEvents.BeforeExperiment);
		
		//consider remove direct class below and replace purely with Templates.compose(script);
		var processScript:ProcessScript = new ProcessScript(script);
		processScript = null;

		scriptEngine = new ScriptInterp();
		scriptEngine.variables.set("Experiment", this);
		scriptEngine.variables.set("E", this);
		scriptEngine.variables.set("Expr", this);
		DebugManager.instance.experiment = this;
		scriptEngine.variables.set("Debug", DebugManager.instance);
		
		//TrialOrder.DO(script);
		DebugManager.instance.info("Experiment ready");
		setupTrials(script);
		firstTrial();
	}

	private function linkups() {
		BaseStimuli.setPermittedStimuli(StimuliFactory.getPermittedStimuli());
		
		StimuliFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
	}
	
	public function setupTrials(script:Xml) {
		var trialOrder:TrialOrder = new TrialOrder();
		var trialOrder_skeletons  = trialOrder.COMPOSE(script);
		trialOrder = null;
		
		var baseStimuli:BaseStimuli = new BaseStimuli();
		baseStimuli.createSkeletonParams(trialOrder_skeletons._1);
		baseStimuli = null;
		
		nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);

		var skeletons:Array<TrialSkeleton> = trialOrder_skeletons._1;
		var preloadList:Array<String> = new Array<String>();
		for (skeleton in skeletons) {
			for (baseStim in skeleton.baseStimuli) {
				var stimPreload:Array<String> = StimuliFactory.getStimPreloadList(baseStim.name, baseStim.props);
				if (stimPreload != null) {
					preloadList = preloadList.concat(stimPreload);
				}
			}
		}
		
		if (preloadList.length > 0) {
			DebugManager.instance.progress("Preloading " + preloadList.length + " image(s)");
			Preloader.instance.addEventListener(PreloaderEvent.PROGRESS, _onPreloadProgress);
			Preloader.instance.addEventListener(PreloaderEvent.COMPLETE, _onPreloadComplete);
			Preloader.instance.preloadImages(preloadList);
		}
	}
	
	private function _onPreloadProgress(event:PreloaderEvent) {
		var progressEvent:PreloaderEvent = new PreloaderEvent(event.type);
		progressEvent.total = event.total;
		progressEvent.current = event.current;
		dispatchEvent(progressEvent);
	}
	
	private function _onPreloadComplete(event:PreloaderEvent) {
		DebugManager.instance.progress("Preload complete");
		Preloader.instance.removeEventListener(PreloaderEvent.PROGRESS, _onPreloadProgress);
		Preloader.instance.removeEventListener(PreloaderEvent.COMPLETE, _onPreloadComplete);
		var progressEvent:PreloaderEvent = new PreloaderEvent(event.type);
		progressEvent.total = event.total;
		progressEvent.current = event.current;
		dispatchEvent(progressEvent);
	}
	
	public function firstTrial() {
		currentTrailInfo = nextTrialBoss.getTrial(GotoTrial.First, null);
		startTrial();
	}
	
	public function nextTrial() {
		currentTrailInfo = nextTrialBoss.getTrial(GotoTrial.Next, null);
		startTrial();
	}
	
	public function previousTrial() {
		currentTrailInfo = nextTrialBoss.getTrial(GotoTrial.Previous, null);
		startTrial();
	}
	
	public function gotoTrial(trial:Dynamic) {
		if (Std.is(trial, String) == true) {
			currentTrailInfo = nextTrialBoss.getTrial(GotoTrial.Name(trial), null);
			startTrial();
		} else {
			var trialIndex = Std.parseInt(trial);
			currentTrailInfo = nextTrialBoss.getTrial(GotoTrial.Number(trialIndex), null);
			startTrial();
		}
	}
	
	public function startTrial() {
		var info:NextTrialInfo = currentTrailInfo;

		if (runningTrial != null) {
			for (stim in runningTrial.stimuli) {
				if (stim.id != null) {
					scriptEngine.variables.remove(stim.id);
				}
			}
			results.add(runningTrial.getResults(), runningTrial.specialTrial);
			runningTrial.kill();					
			/*
			runningTrial.callBack = function(action:Trial_Action) {
				switch(action) {	
					case Trial_Action.End:
						results.add(runningTrial.getResults(), runningTrial.specialTrial);
						runningTrial.kill();					
				}
			}
			*/
		}
		
		runningTrial = trialFactory.GET(info.skeleton, info.trialOrder, this);
		
		if(info.action !=null) {
			switch(info.action) {
				
				case NextTrialBoss_actions.BeforeLastTrial:
					Scripting.DO(script, RunCodeEvents.BeforeLastTrial, runningTrial);
					runningTrial.setSpecial(Special_Trial.First_Trial);
					
				case NextTrialBoss_actions.BeforeFirstTrial:
					Scripting.DO(script, RunCodeEvents.BeforeFirstTrial, runningTrial);
					runningTrial.setSpecial(Special_Trial.Last_Trial);
				
			}
		}
		
		for (stim in runningTrial.stimuli) {
			if (stim.id != null) {
				scriptEngine.variables.set(stim.id, stim);
			}
		}
		DebugManager.instance.info("Starting trial");
		runningTrial.start();
	}
}