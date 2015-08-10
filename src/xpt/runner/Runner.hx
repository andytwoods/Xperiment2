package xpt.runner;
import code.Code;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.utils.Object;
import xpt.script.BetweenSJs;

import xpt.script.ProcessScript;
import xpt.experiment.Experiment;
import xpt.script.Templates;

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
		
		
		//ProcessScript.DO(script);
		script = BetweenSJs.compose(script);
	
		
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