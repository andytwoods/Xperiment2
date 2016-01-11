package xpt.experiment;

import assets.manager.FileLoader;
import code.CheckIsCode.RunCodeEvents;
import code.Scripting;
import comms.services.CrossDomain_service;
import comms.services.REST_Service;
import comms.services.UrlParams_service;
import haxe.ui.toolkit.core.RootManager;
import openfl.events.EventDispatcher;
import openfl.events.TimerEvent;
import openfl.utils.Object;
import openfl.utils.Timer;
import preloader.Preloader;
import preloader.PreloaderManager;
import xpt.debug.DebugManager;
import preloader.Preloader.PreloaderEvent;
import xpt.results.Results;
import xpt.results.TrialResults;
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
	private var nextTrialBoss:NextTrialBoss;
	private var script:Xml;
	private var runningTrial:Trial;
	private var results:Results = new Results();
	private var currentTrailInfo:NextTrialInfo = null;
	private var trialFactory:TrialFactory = new TrialFactory();

	public function new(script:Xml) {
		super();
		linkups();
		
		if (script == null) return; //used for testing
		this.script = script;
		
		
		//consider remove direct class below and replace purely with Templates.compose(script);
		var processScript:ProcessScript = new ProcessScript(script);
		processScript = null;
		
		ExptWideSpecs.init();
		trace("------------------------------");
		ExptWideSpecs.set(script);
		ExptWideSpecs.updateExternalVars(UrlParams_service.params);
		
		#if html5
			if (UrlParams_service.is_devel_server()) {
				ExptWideSpecs.override_for_develServer();
			}
		#end
		#if flash
			ExptWideSpecs.override_for_develServer();
		#end
		//ExptWideSpecs.print();
		
		linkups_Post_ExptWideSpecs();

		Scripting.init(this);
		DebugManager.instance.experiment = this;
		//DebugManager.instance.enabled = true;
		DebugManager.instance.info("Experiment ready");
		setupTrials(script);
		firstTrial();
		

	}

	private function linkups() {
		BaseStimuli.setPermittedStimuli(StimuliFactory.getPermittedStimuli());
		StimuliFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
	}
	
	private function linkups_Post_ExptWideSpecs() {
		REST_Service.setup(ExptWideSpecs.IS("cloudUrl"), ExptWideSpecs.IS("saveWaitDuration"));
		Results.setup(ExptWideSpecs.exptId(),ExptWideSpecs.IS("uuid"), ExptWideSpecs.IS("trickleToCloud"));
		StimulusBuilder.setStimFolder(ExptWideSpecs.IS('stimuliFolder'));
		
	}
	
	
	private function setupTrials(script:Xml) {
		var trialOrder:TrialOrder = new TrialOrder();
		var trialOrder_skeletons  = trialOrder.COMPOSE(script);
		trialOrder = null;
		
		var baseStimuli:BaseStimuli = new BaseStimuli();
		baseStimuli.createSkeletonParams(trialOrder_skeletons._1);
		baseStimuli = null;
		
		nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);

		var preloaderManager:PreloaderManager = new PreloaderManager(trialOrder_skeletons._1, this);
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
	
	private function cleanup_prevTrial() {
			results.add(TrialResults.extract_trial_results(runningTrial), runningTrial.specialTrial);
			runningTrial.kill();					
	}
	
	private function startTrial() {
		if (runningTrial != null) {
			Scripting.DO(script, RunCodeEvents.AfterTrial, runningTrial);
			Scripting.removeStimuli(runningTrial.stimuli);
			cleanup_prevTrial();
		}
		
		var info:NextTrialInfo = currentTrailInfo;

		runningTrial = trialFactory.GET(info.skeleton, info.trialOrder, this);
		
		if(info.action !=null) {
			switch(info.action) {
				
				case NextTrialBoss_actions.BeforeLastTrial:
					runningTrial.setSpecial(Special_Trial.Last_Trial);
					Scripting.DO(script, RunCodeEvents.BeforeLastTrial, runningTrial);
					
				case NextTrialBoss_actions.BeforeFirstTrial:
					runningTrial.setSpecial(Special_Trial.First_Trial);
					Scripting.DO(script, RunCodeEvents.BeforeFirstTrial, runningTrial);
				default:
					//
			}
		}
		
		for (stim in runningTrial.stimuli) {
			Scripting.addStimuli(runningTrial.stimuli);
		}
		DebugManager.instance.info("Starting trial");
		Scripting.DO(script, RunCodeEvents.BeforeTrial, runningTrial);
		runningTrial.start();
	}
}