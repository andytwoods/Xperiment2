package xpt.trial;
import thx.Arrays;
import xpt.stimuli.BaseStimuli;
import xpt.stimuli.BaseStimuli.BaseStimulus;
import xpt.tools.XML_tools;
import xpt.tools.XTools;
import xpt.trialOrder.TrialBlock;


class TrialSkeleton
{
	public var trials:Array<Int>;
	public var bind_id:String;
	public var runTrial:Bool;
	public var blockPosition:Int;
	public var names:Array<String>;
	public var xml:Xml;
	public var baseStimuli:Array<BaseStimulus>;
	public var otherParams:Map<String,String>;
	
	private static var permittedStimuli;
	

	public function new(trialBlock:TrialBlock) 
	{
		if (trialBlock == null) return; //for testing
		
		this.blockPosition = trialBlock.blockPosition;
		this.trials = trialBlock.original_trials;
		this.runTrial = trialBlock.runTrial;
		this.bind_id = trialBlock.bind_id;
		this.names = trialBlock.trialNames;
		this.xml = trialBlock.xml;
		this.otherParams = trialBlock.otherParams;
	}
		
	
	
}