package xpt.runner;
import code.Code;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.utils.Object;
import script.ProcessScript;
import xpt.experiment.Experiment;

/**
 * ...
 * @author ...
 */
class Runner extends Sprite
{	
	
	public var script:Xml;
	
	public function new() 
	{
		super();		
	}
	
	public function run(script:Xml, url:String = null, params:Object = null) 
	{

		
		initiateOverExperimentStuff();
		ProcessScript.DO(script);
		
		var expt:Experiment = new Experiment(script, url, params);
		
	}
	
	function initiateOverExperimentStuff() 
	{
		Code.init();
	}
	

	
	
	function startBehaviour() 
	{
		
		
	}
	
}