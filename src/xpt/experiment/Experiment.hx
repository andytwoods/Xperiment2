package xpt.experiment;

import assets.manager.FileLoader;
import code.CheckIsCode.Checks;
import code.Code;
import haxe.ui.toolkit.hscript.ScriptInterp;
import openfl.events.EventDispatcher;
import openfl.utils.Object;
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
	private var __nextTrialBoss:NextTrialBoss;
	private var __script:Xml;
	private var __runningTrial:Trial;
	private var __results:Results = new Results();
	private var __currentTrailInfo:NextTrialInfo = null;

	public var scriptEngine:ScriptInterp = new ScriptInterp();
	
	public function new(script:Xml, url:String = null, params:Object = null) {
		super();
		linkups();
		
		if (script == null) return; //used for testing
		this.__script = script;
		
		Code.DO(script, Checks.BeforeExperiment);
		
		//consider remove direct class below and replace purely with Templates.compose(script);
		ProcessScript.DO(script);
		ExptWideSpecs.set(script);

		scriptEngine = new ScriptInterp();
		scriptEngine.variables.set("Experiment", this);
		scriptEngine.variables.set("E", this);
		scriptEngine.variables.set("Expr", this);
		
		//TrialOrder.DO(script);
		__setupTrials(script);
		firstTrial();
	}

	private function linkups() {
		BaseStimuli.setPermittedStimuli(StimuliFactory.getPermittedStimuli());
		
		StimuliFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
	}
	
	public function __setupTrials(script:Xml) {
		var trialOrder_skeletons  = TrialOrder.COMPOSE(script);
		BaseStimuli.createSkeletonParams(trialOrder_skeletons._1);
		__nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);

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
		Preloader.instance.removeEventListener(PreloaderEvent.PROGRESS, _onPreloadProgress);
		Preloader.instance.removeEventListener(PreloaderEvent.COMPLETE, _onPreloadComplete);
		var progressEvent:PreloaderEvent = new PreloaderEvent(event.type);
		progressEvent.total = event.total;
		progressEvent.current = event.current;
		dispatchEvent(progressEvent);
	}
	
	public function firstTrial() {
		__currentTrailInfo = __nextTrialBoss.getTrial(GotoTrial.First, null);
		__startTrial();
	}
	
	public function nextTrial() {
		__currentTrailInfo = __nextTrialBoss.getTrial(GotoTrial.Next, null);
		__startTrial();
	}
	
	public function previousTrial() {
		__currentTrailInfo = __nextTrialBoss.getTrial(GotoTrial.Previous, null);
		__startTrial();
	}
	
	public function gotoTrial(trial:Dynamic) {
		if (Std.is(trial, String) == true) {
			__currentTrailInfo = __nextTrialBoss.getTrial(GotoTrial.Name(trial), null);
			__startTrial();
		} else {
			var trialIndex = Std.parseInt(trial);
			__currentTrailInfo = __nextTrialBoss.getTrial(GotoTrial.Number(trialIndex), null);
			__startTrial();
		}
	}
	
	public function __startTrial() {
		var info:NextTrialInfo = __currentTrailInfo;

		if (__runningTrial != null) {
			__results.add(__runningTrial.getResults(), __runningTrial.specialTrial);
			__runningTrial.kill();					
			/*
			__runningTrial.callBack = function(action:Trial_Action) {
				switch(action) {	
					case Trial_Action.End:
						__results.add(__runningTrial.getResults(), __runningTrial.specialTrial);
						__runningTrial.kill();					
				}
			}
			*/
		}
		
		__runningTrial = TrialFactory.GET(info.skeleton, info.trialOrder, this);
		
		if(info.action !=null) {
			switch(info.action) {
				
				case NextTrialBoss_actions.BeforeLastTrial:
					Code.DO(__script, Checks.BeforeLastTrial, __runningTrial);
					__runningTrial.setSpecial(Special_Trial.First_Trial);
					
				case NextTrialBoss_actions.BeforeFirstTrial:
					Code.DO(__script, Checks.BeforeFirstTrial, __runningTrial);
					__runningTrial.setSpecial(Special_Trial.Last_Trial);
				
			}
		}
		
		__runningTrial.start();
	}
}