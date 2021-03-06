package xpt.experiment;
import xpt.preloader.Preloader;

import assets.manager.FileLoader;
import code.CheckIsCode;
import code.CheckIsCode.RunCodeEvents;
import code.Scripting;
import flash.events.Event;
import haxe.ui.toolkit.core.RootManager;
import openfl.events.EventDispatcher;
import openfl.utils.Object;
import xpt.comms.services.AbstractService;
import xpt.comms.services.REST_Service;
import xpt.comms.services.UrlParams_service;
import xpt.debug.DebugManager;
import xpt.error.ErrorMessage;
import xpt.events.ExperimentEvent;
import xpt.preloader.Preloader.PreloaderEvent;
import xpt.preloader.Preloader_extract_loadable;
import xpt.results.Results;
import xpt.results.ResultsFeedback;
import xpt.results.TrialResults;
import xpt.screenManager.DeviceManager;
import xpt.screenManager.RotateYourScreen;
import xpt.screenManager.ScreenManager;
import xpt.script.Templates;
import xpt.stimuli.BaseStimuli;
import xpt.stimuli.builders.nonvisual.StimEvolve.EvolveCommsManager;
import xpt.stimuli.builders.nonvisual.StimEvolve.StimEvolveParams;
import xpt.stimuli.ETCs;
import xpt.stimuli.StimuliFactory;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.Shortcuts;
import xpt.tools.XTools;
import xpt.trial.GotoTrial;
import xpt.trial.NextTrialBoss;
import xpt.trial.Special_Trial;
import xpt.trial.Trial;
import xpt.trial.TrialFactory;
import xpt.trial.TrialSkeleton;
import xpt.trialOrder.TrialBlock;
import xpt.trialOrder.TrialOrder;
import openfl.Lib;

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


		Shortcuts.instance.experiment_wide(script);
		new Templates(script);
		
		//trace(script);
		ExptWideSpecs.init();
		//trace("------------------------------");
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

		DebugManager.instance.experiment = this;
		//DebugManager.instance.enabled = true;

		DebugManager.instance.info("Experiment ready");
		background(ExptWideSpecs.IS("backgroundColour")); 
		
		setupTrials(script);

		ScreenManager.instance.orientation(ExptWideSpecs.IS('orientation'));
		RotateYourScreen.instance.monitor(function(){
			ScreenManager.instance.refresh();
			firstTrial();
		});	
	}
	
	public function background(colStr:String) {
		var col:Int = XTools.getColour(colStr);	
		RootManager.instance.currentRoot.style.backgroundAlpha = 0;
		Lib.current.stage.color = col;
	}


	private function linkups() {
		Scripting.init(this);
		BaseStimuli.setPermittedStimuli(StimuliFactory.getPermittedStimuli());
		BaseStimuli.readabilitySpaces_props = ExptWideSpecs.readabilitySpaces_props;
		StimuliFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
		TrialFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
		TrialBlock.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
		Shortcuts_Command.permitted = [ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep];
		TrialOrder.setLabels(ExptWideSpecs.trial_sep);
		ETCs.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
		if (testing == false) ScreenManager.instance.callbacks.push(StimulusBuilder.updateTrial_XY);
	}

		
	
	private function linkups_Post_ExptWideSpecs() {
		AbstractService.wait_til_error = Std.parseInt(ExptWideSpecs.IS("saveWaitDuration"));
		Results.setup(ExptWideSpecs.exptId(), ExptWideSpecs.IS("uuid"), ExptWideSpecs.IS("trickleToCloud"), ExptWideSpecs.IS('csrftoken'));
		Results.save = ExptWideSpecs.IS('save') == 'true';
		EvolveCommsManager.setup(ExptWideSpecs.IS("uuid"), ExptWideSpecs.IS('csrftoken'), ExptWideSpecs.IS('evolveUrl'));
		Results.url = ExptWideSpecs.IS('cloudUrl');
		Trial._ITI = Std.int(ExptWideSpecs.IS("ITI"));
		TrialResults.do_not_prepend_data = ExptWideSpecs.IS('do_not_prepend_data') != 'false';
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
		this.dispatchEvent(progressEvent);
	}
	
	private function _onPreloadComplete(event:PreloaderEvent) {
		if (Preloader.instance.success == false) {
			ErrorMessage.error(ErrorMessage.Try_reload, 'We are very sorry, but there is some trouble downloading the stimuli used in this study ('+Preloader.instance.failed_to_load_list()+')');
		}
		
		stimuli_loaded = true;
		DebugManager.instance.progress("Preload complete");
		Preloader.instance.removeEventListener(PreloaderEvent.PROGRESS, _onPreloadProgress);
		Preloader.instance.removeEventListener(PreloaderEvent.COMPLETE, _onPreloadComplete);
		var progressEvent:PreloaderEvent = new PreloaderEvent(event.type);
		progressEvent.total = event.total;
		progressEvent.current = event.current;
		this.dispatchEvent(progressEvent);		
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
	
	private function collectData_prevTrial() {
			var trialResults:TrialResults = TrialResults.extract_trial_results(runningTrial);
			results.add(trialResults, runningTrial.specialTrial);				
	}
	
	public function changeLanguage(lang:String, all_langs:Array<String>, _default:String) {
		Translate.DO(nextTrialBoss.__trialSkeletons, lang, all_langs, _default);
		nextTrial();
	}
	
	public function startTrial() {
		if (testing == true) return;


		if (runningTrial != null) {

			Scripting.DO(null, RunCodeEvents.AfterTrial, runningTrial);
            runningTrial.trialEnded();
			Scripting.scriptableStimuli(runningTrial.stimuli, false);
					
			collectData_prevTrial();
			Scripting.stimuli = null;
			runningTrial.kill();	
			
		}
				
		var info:NextTrialInfo = currentTrialInfo;

        Stimulus.resetGroups();

		runningTrial = trialFactory.GET(info.skeleton, info.trialOrder, this);
		//trace('start triall');

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
		
		Scripting.stimuli = runningTrial.stimuli;
		
		//not working
		//Scripting.scriptableStimuli(runningTrial.stimuli,true);
		Scripting.DO(null, RunCodeEvents.BeforeTrial, runningTrial);
		DebugManager.instance.info("Starting trial");

		runningTrial.start();    
	}
	
	private function dispatch_ExperimentEvent(event:String, trial:Trial) {
		var event:ExperimentEvent = new ExperimentEvent(event);
        event.trial = trial;
        this.dispatchEvent(event);
	}
	
	public function saveDataEndStudy() 
	{
		if (Std.string(ExptWideSpecs.IS("save")).toLowerCase() == 'false') return;
		
		resultsFeedback = new ResultsFeedback(this);
		resultsFeedback.show(this);
		results.endOfStudy(resultsFeedback.success);
		
	}
}