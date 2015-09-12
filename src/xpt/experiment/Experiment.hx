package xpt.experiment;
import code.CheckIsCode.Checks;
import code.Code;
import haxe.ui.toolkit.core.Toolkit;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.Lib;
import openfl.utils.Object;
import xpt.results.Results;
import xpt.script.ProcessScript;
import xpt.tools.XML_tools;
import thx.Tuple.Tuple2;
import xpt.stimuli.BaseStimuli;
import xpt.stimuli.StimuliFactory;
import xpt.trial.NextTrialBoss;
import xpt.trial.Special_Trial;
import xpt.trial.Trial;
import xpt.trial.TrialFactory;
import xpt.trial.TrialSkeleton;
import xpt.trialOrder.TrialOrder;

/**
 * ...
 * @author 
 */
class Experiment
{

	public var __nextTrialBoss:NextTrialBoss;
	public var __script:Xml;
	public var __runningTrial:Trial;
	public var __results:Results = new Results();
	

	public function new(script:Xml, url:String = null, params:Object = null) {
		linkups();
		
		if (script == null) return; //used for testing
		this.__script = script;
		
		Code.DO(script, Checks.BeforeExperiment);
		
		//consider remove direct class below and replace purely with Templates.compose(script);
		ProcessScript.DO(script);
		ExptWideSpecs.set(script);

		//TrialOrder.DO(script);
		__setupTrials(script);

		__startTrial();
	}

	function linkups() {
		var permittedStimuli:Array<String> = ['set later'];

		BaseStimuli.setPermittedStimuli(permittedStimuli);
		
		StimuliFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
	}
	
	public function __setupTrials(script:Xml) {
		var trialOrder_skeletons  = TrialOrder.COMPOSE(script);
		BaseStimuli.createSkeletonParams(trialOrder_skeletons._1);
		__nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);
	}
	
	public function __startTrial() {
		
		var info:NextTrialInfo = __nextTrialBoss.nextTrial();
		
		__runningTrial = TrialFactory.GET(info.skeleton, info.trialOrder);
		
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
		
		__runningTrial.callBack = function(action:Trial_Action) {
			
			switch(action) {	
				case Trial_Action.End:
					__results.add(	__runningTrial.getResults(), __runningTrial.specialTrial	);
					__runningTrial.kill();					
			}
		}
		
		__runningTrial.start();
	}
}