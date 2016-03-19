package xpt.experiment;

import assets.manager.FileLoader;
import code.CheckIsCode;
import code.CheckIsCode.RunCodeEvents;
import code.Scripting;
import flash.events.Event;
import openfl.events.EventDispatcher;
import openfl.utils.Object;
import xpt.comms.services.AbstractService;
import xpt.comms.services.REST_Service;
import xpt.comms.services.UrlParams_service;
import xpt.debug.DebugManager;
import xpt.error.ErrorMessage;
import xpt.events.ExperimentEvent;
import xpt.experiment.Preloader.PreloaderEvent;
import xpt.preloader.Preloader_extract_loadable;
import xpt.results.Results;
import xpt.results.ResultsFeedback;
import xpt.results.TrialResults;
import xpt.screenManager.DeviceManager;
import xpt.screenManager.RotateYourScreen;
import xpt.screenManager.ScreenManager;
import xpt.script.ProcessScript;
import xpt.stimuli.BaseStimuli;
import xpt.stimuli.ETCs;
import xpt.stimuli.StimuliFactory;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.XTools;
import xpt.trial.GotoTrial;
import xpt.trial.NextTrialBoss;
import xpt.trial.Special_Trial;
import xpt.trial.Trial;
import xpt.trial.TrialFactory;
import xpt.trial.TrialSkeleton;
import xpt.trialOrder.TrialBlock;
import xpt.trialOrder.TrialOrder;

@:allow(xpt.trialOrder.Test_TrialOrder)
class Experiment extends EventDispatcher {
	
	private var nextTrialBoss:NextTrialBoss;
	private var script:Xml;
	private var results:Results = new Results();
	private var currentTrialInfo:NextTrialInfo = null;
	private var trialFactory:TrialFactory = new TrialFactory();
	var resultsFeedback:ResultsFeedback;
	
	public var runningTrial:Trial;
	public var stimuli_loaded:Bool = false;
	
	public static var testing:Bool = false;
	
	public function new(script:Xml, url:String = null, params:Object = null) {
		super();
		linkups();
		if (script == null) return; //used for testing
		this.script = script;

		//consider remove direct class below and replace purely with Templates.compose(script);
		var processScript:ProcessScript = new ProcessScript(script);
		processScript = null;

		ExptWideSpecs.init();
		//trace("------------------------------");
		ExptWideSpecs.set(script);
		#if html5
			if (DeviceManager.check(ExptWideSpecs.IS('devices')) == false) {
				ErrorMessage.error('Device not allowed', DeviceManager.error, true);
				return;
			}
		#end
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

		DebugManager.instance.experiment = this;
		//DebugManager.instance.enabled = true;

		DebugManager.instance.info("Experiment ready");
		ScreenManager.instance.background(ExptWideSpecs.IS("backgroundColour")); 
		
		setupTrials(script);

		ScreenManager.instance.orientation(ExptWideSpecs.IS('orientation'));
		RotateYourScreen.instance.monitor(function(){
			ScreenManager.instance.refresh();
			firstTrial();
		});	
	}
	


	private function linkups() {
		Scripting.init(this);
		BaseStimuli.setPermittedStimuli(StimuliFactory.getPermittedStimuli());
		BaseStimuli.readabilitySpaces_props = ExptWideSpecs.readabilitySpaces_props;
		StimuliFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
		TrialFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
		TrialBlock.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
		TrialOrder.setLabels(ExptWideSpecs.trial_sep);
		ETCs.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
		if(testing==false) ScreenManager.instance.callbacks.push(StimulusBuilder.updateTrial_XY);
	}

		
	
	private function linkups_Post_ExptWideSpecs() {
		AbstractService.setup(ExptWideSpecs.IS("cloudUrl"), ExptWideSpecs.IS("saveWaitDuration"));
		Results.setup(ExptWideSpecs.exptId(),ExptWideSpecs.IS("uuid"), ExptWideSpecs.IS("trickleToCloud"));
		Trial._ITI = Std.int(ExptWideSpecs.IS("ITI"));
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
		
		//attempt to incorporate --- and |
		var find_loadable:Preloader_extract_loadable = new Preloader_extract_loadable();
		var preloadList:Array<String> = find_loadable.extract(skeletons);
		find_loadable = null;
		
		if (preloadList.length > 0) {
			DebugManager.instance.progress("Preloading " + preloadList.length + " image(s)");
			Preloader.instance.addEventListener(PreloaderEvent.PROGRESS, _onPreloadProgress);
			Preloader.instance.addEventListener(PreloaderEvent.COMPLETE, _onPreloadComplete);
			Preloader.instance.preloadStimuli(preloadList);
		}
		else {
			stimuli_loaded = true;
		}

	}

	private function _onPreloadProgress(event:PreloaderEvent) {
		var progressEvent:PreloaderEvent = new PreloaderEvent(event.type);
		progressEvent.total = event.total;
		progressEvent.current = event.current;
		dispatchEvent(progressEvent);
	}
	
	private function _onPreloadComplete(event:PreloaderEvent) {
		stimuli_loaded = true;
		DebugManager.instance.progress("Preload complete");
		Preloader.instance.removeEventListener(PreloaderEvent.PROGRESS, _onPreloadProgress);
		Preloader.instance.removeEventListener(PreloaderEvent.COMPLETE, _onPreloadComplete);
		var progressEvent:PreloaderEvent = new PreloaderEvent(event.type);
		progressEvent.total = event.total;
		progressEvent.current = event.current;
		dispatchEvent(progressEvent);
				
	}
	
	public function firstTrial() {
		currentTrialInfo = nextTrialBoss.getTrial(GotoTrial.First, null);
		startTrial();
	}
	
	public function nextTrial() {
		currentTrialInfo = nextTrialBoss.getTrial(GotoTrial.Next, null);
		startTrial();
	}
	
	public function previousTrial() {
		currentTrialInfo = nextTrialBoss.getTrial(GotoTrial.Previous, null);
		startTrial();
	}
	
	public function gotoTrial(trial:Dynamic) {
		if (Std.is(trial, String) == true) {
			currentTrialInfo = nextTrialBoss.getTrial(GotoTrial.Name(trial), null);
			startTrial();
		} else {
			var trialIndex = Std.parseInt(trial);
			currentTrialInfo = nextTrialBoss.getTrial(GotoTrial.Number(trialIndex), null);
			startTrial();
		}
	}
	
	private function cleanup_prevTrial() {
			var trialResults:TrialResults = TrialResults.extract_trial_results(runningTrial);
			results.add(trialResults, runningTrial.specialTrial);
			runningTrial.kill();					
	}
	
	public function changeLanguage(lang:String, all_langs:Array<String>, _default:String) {
		Translate.DO(nextTrialBoss.__trialSkeletons, lang, all_langs, _default);
		nextTrial();
	}
	
	public function startTrial() {
		if (testing == true) return;

/*		#if debug
			if (runningTrial == null && stimuli_loaded == false) {
				XTools.callBack_onEvent(Preloader.instance, PreloaderEvent.COMPLETE, function(e:Event) {
				trace(11111111);	
					startTrial();
					trace(3333);
				});
				return;
			}
		#end*/

		if (runningTrial != null) {
			Scripting.DO(null, RunCodeEvents.AfterTrial, runningTrial);
            dispatch_ExperimentEvent(ExperimentEvent.TRIAL_END, runningTrial);
            
			Scripting.scriptableStimuli(runningTrial.stimuli, false);
			cleanup_prevTrial();
		}
		
		var info:NextTrialInfo = currentTrialInfo;

        Stimulus.resetGroups();

		runningTrial = trialFactory.GET(info.skeleton, info.trialOrder, this);


		if(info.action !=null) {
			switch(info.action) {
				
				case NextTrialBoss_actions.BeforeLastTrial:
					Scripting.DO(script, RunCodeEvents.BeforeLastTrial, runningTrial);
					runningTrial.setSpecial(Special_Trial.Last_Trial);
					if (testing == false) {
						saveDataEndStudy();
					}
					
				case NextTrialBoss_actions.BeforeFirstTrial:
					Scripting.DO(script, RunCodeEvents.BeforeFirstTrial, runningTrial);
					runningTrial.setSpecial(Special_Trial.First_Trial);
					if(testing==false)	results.startOfStudy();
					
				default:
					runningTrial.setSpecial(Special_Trial.Not_Special);
			}
		}
		else {
			runningTrial.setSpecial(Special_Trial.Not_Special);
		}
		
		Scripting.scriptableStimuli(runningTrial.stimuli,true);
		Scripting.DO(null, RunCodeEvents.BeforeTrial, runningTrial);
		DebugManager.instance.info("Starting trial");
		runningTrial.start();
        runningTrial.validateStims();
        
		dispatch_ExperimentEvent(ExperimentEvent.TRIAL_START, runningTrial);
        
	}
	
	private function dispatch_ExperimentEvent(event:String, trial:Trial) {
		var event:ExperimentEvent = new ExperimentEvent(event);
        event.trial = trial;
        dispatchEvent(event);
	}
	
	public function saveDataEndStudy() 
	{
		resultsFeedback = new ResultsFeedback(this);
		resultsFeedback.show(this);
		results.endOfStudy(resultsFeedback.success);
	}
}