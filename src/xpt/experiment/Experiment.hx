package xpt.experiment;

import assets.manager.FileLoader;
import code.CheckIsCode.Checks;
import code.Code;
import comms.services.REST_Service;
import comms.services.UrlParams_service;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.hscript.ScriptInterp;
import openfl.events.EventDispatcher;
import openfl.events.TimerEvent;
import openfl.utils.Object;
import openfl.utils.Timer;
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
	private var nextTrialBoss:NextTrialBoss;
	private var script:Xml;
	private var runningTrial:Trial;
	private var results:Results = new Results();
	private var currentTrailInfo:NextTrialInfo = null;
	private var trialFactory:TrialFactory = new TrialFactory();

	public var scriptEngine:ScriptInterp = new ScriptInterp();
	
	public function new(script:Xml) {
		super();
		linkups();
		
		if (script == null) return; //used for testing
		this.script = script;
		
		Code.DO(script, Checks.BeforeExperiment);
		
		//consider remove direct class below and replace purely with Templates.compose(script);
		var processScript:ProcessScript = new ProcessScript(script);
		processScript = null;

		ExptWideSpecs.set(script);
		ExptWideSpecs.setStimuliFolder(Xpt.localExptDirectory + Xpt.exptName + "/");
		ExptWideSpecs.updateExternalVars(UrlParams_service.params);
		
		#if html5
			if (UrlParams_service.is_devel_server()) {
				ExptWideSpecs.override_for_develServer();
			}

		#end
		//ExptWideSpecs.print();
		
		linkups_Post_ExptWideSpecs();

		scriptEngine = new ScriptInterp();
		scriptEngine.variables.set("Experiment", this);
		DebugManager.instance.experiment = this;
		DebugManager.instance.enabled = true;
		scriptEngine.variables.set("Debug", DebugManager.instance);
		
		//TrialOrder.DO(script);
		DebugManager.instance.info("Experiment ready");
		setupTrials(script);
		firstTrial();
		
		//var t:Timer = new Timer(1000, 5);
		//t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):Void {
					//RootManager.instance.currentRoot.resizeRoot();
			 //} );
		//t.start();
	}

	private function linkups() {
		BaseStimuli.setPermittedStimuli(StimuliFactory.getPermittedStimuli());
		StimuliFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
	}
	
	private function linkups_Post_ExptWideSpecs() {
		REST_Service.setup(ExptWideSpecs.IS("cloudUrl"), ExptWideSpecs.IS("saveWaitDuration"));
		Results.setup(ExptWideSpecs.exptId(), ExptWideSpecs.IS("trickleToCloud"));
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
	
	private function startTrial() {
		var info:NextTrialInfo = currentTrailInfo;

		if (runningTrial != null) {
			for (stim in runningTrial.stimuli) {
				if (stim.id != null) {
					scriptEngine.variables.remove(stim.id);
				}
			}
			

			results.add(runningTrial.getResults(), runningTrial.specialTrial);
			runningTrial.kill();					
			
		}

		runningTrial = trialFactory.GET(info.skeleton, info.trialOrder, this);
		
		if(info.action !=null) {
			switch(info.action) {
				
				case NextTrialBoss_actions.BeforeLastTrial:
					Code.DO(script, Checks.BeforeLastTrial, runningTrial);
					runningTrial.setSpecial(Special_Trial.First_Trial);
					
				case NextTrialBoss_actions.BeforeFirstTrial:
					Code.DO(script, Checks.BeforeFirstTrial, runningTrial);
					runningTrial.setSpecial(Special_Trial.Last_Trial);
				default:
					//
				
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