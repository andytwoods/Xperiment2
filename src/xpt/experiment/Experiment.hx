package xpt.experiment;
import openfl.utils.Object;
import xpt.script.ProcessScript;
import xpt.tools.XML_tools;
import thx.Tuple.Tuple2;
import xpt.stimuli.BaseStimuli;
import xpt.stimuli.StimuliFactory;
import xpt.trial.NextTrialBoss;
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
	
	public function new(script:Xml, url:String = null, params:Object = null) 
	{
		ExptWideSpecs.__init();
		linkups();
		
		if (script == null) return; //used for testing
		this.__script = script;
		
		//var b:Behaviour = new Behaviour();
		
		ProcessScript.DO(script);
		
		//TrialOrder.DO(script);
		
		__setupTrials(script);
		__startTrial();
	}
	
	function linkups() 
	{
		BaseStimuli.setPermitted(['set later']);
		StimuliFactory.setLabels(ExptWideSpecs.stim_sep, ExptWideSpecs.trial_sep);
	}
	
	
	public function __setupTrials(script:Xml) 
	{
		//trace(111,script);
		//trace(111, XML_tools.findAttr(xml, "block"));
		
		var trialOrder_skeletons  = TrialOrder.COMPOSE(script);
		BaseStimuli.createSkeletonParams(trialOrder_skeletons._1);
		__nextTrialBoss = new NextTrialBoss(trialOrder_skeletons);
	}
	

	
	public function __startTrial() {
		var skeleton_trialOrder = __nextTrialBoss.nextTrial();
		__runningTrial = TrialFactory.GET(skeleton_trialOrder._0, skeleton_trialOrder._1);
	}
	
}