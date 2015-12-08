package xpt.experiment;

import assets.manager.FileLoader;
import code.CheckIsCode.Checks;
import code.Code;
import comms.services.REST_Service;
import comms.services.UrlParams_service;
import haxe.ui.toolkit.hscript.ScriptInterp;
import openfl.events.EventDispatcher;
import openfl.utils.Object;
import preloader.Preloader;
import preloader.PreloaderManager;
import xpt.debug.DebugManager;
import preloader.Preloader.PreloaderEvent;
import xpt.results.Results;
import xpt.script.ProcessScript;
import xpt.stimuli.BaseStimuli;
import xpt.stimuli.StimuliFactory;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
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
	private var __trialFactory:TrialFactory = new TrialFactory();

	public var scriptEngine:ScriptInterp = new ScriptInterp();
	
	public function new(script:Xml) {
		super();
		linkups();
		
		if (script == null) return; //used for testing
		this.__script = script;
		
		Code.DO(script, Checks.BeforeExperiment);
		
		//consider remove direct class below and replace purely with Templates.compose(script);
		var processScript:ProcessScript = new ProcessScript(script);
		processScript = null;

		ExptWideSpecs.set(script);
		ExptWideSpecs.setStimuliFolder(Xpt.localExptDirectory + Xpt.exptName + "/");
trace(11118, ExptWideSpecs.IS('stimuliFolder'));
		ExptWideSpecs.updateExternalVars(UrlParams_service.params);
		//ExptWideSpecs.print();

		
		linkups_Post_ExptWideSpecs();

		scriptEngine = new ScriptInterp();
		scriptEngine.variables.set("Experiment", this);
		scriptEngine.variables.set("E", this);
		scriptEngine.variables.set("Expr", this);
		DebugManager.instance.experiment = this;
		scriptEngine.variables.set("Debug", DebugManager.instance);
		
		//TrialOrder.DO(script);
		DebugManager.instance.info("Experiment ready");
		__setupTrials(script);
		firstTrial();
	}

	private function linkups() {
		BaseStimuli.setPermittedStimuli(StimuliFactory.getPermittedStimuli());
		trace(1111, ExptWideSpecs.IS('stimuliFolder'));
		StimuliFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
	}
	
	private function linkups_Post_ExptWideSpecs() {
		REST_Service.setup(ExptWideSpecs.IS("cloudUrl"), ExptWideSpecs.IS("saveWaitDuration"));
		Results.setup(ExptWideSpecs.exptId(), ExptWideSpecs.IS("trickleToCloud"));
				StimulusBuilder.setStimFolder(ExptWideSpecs.IS('stimuliFolder'));
	}
	
	
	public function __setupTrials(script:Xml) {
		var trialOrder:TrialOrder = new TrialOrder();
		var trialOrder_skeletons  = trialOrder.COMPOSE(script);
		trialOrder = null;
		
		var baseStimuli:BaseStimuli = new BaseStimuli();
		baseStimuli.createSkeletonParams(trialOrder_skeletons._1);
		baseStimuli = null;
		
		__nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);

		var preloaderManager:PreloaderManager = new PreloaderManager(trialOrder_skeletons._1, this);
		
		
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
			for (stim in __runningTrial.stimuli) {
				if (stim.id != null) {
					scriptEngine.variables.remove(stim.id);
				}
			}
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

		__runningTrial = __trialFactory.GET(info.skeleton, info.trialOrder, this);
		
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
		
		for (stim in __runningTrial.stimuli) {
			if (stim.id != null) {
				scriptEngine.variables.set(stim.id, stim);
			}
		}
		DebugManager.instance.info("Starting trial");
		__runningTrial.start();
	}
}