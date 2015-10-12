package xpt.runner;
import code.CheckIsCode;
import code.Code;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.utils.Object;
import xpt.script.BetweenSJs;

import xpt.script.ProcessScript;
import xpt.experiment.Experiment;
import xpt.script.Templates;

/**
 * ...
 * @author ...
 */
class Runner
{	
	
	public var script:Xml;
	public var currentExpt:Experiment;

	
	public function new() 
	{
		
	}
	
	public function run(script:Xml, url:String = null, params:Object = null) 
	{
		initiateOverExperimentStuff();
			
		Code.DO(script, Checks.BeforeEverything);
		
		//ProcessScript.DO(script);
		var betweenSJs:BetweenSJs = new BetweenSJs();
		script = betweenSJs.compose(script);
	
		currentExpt = new Experiment(script, url, params);
		
		
	}
	
	function initiateOverExperimentStuff() 
	{
	
	}
	

	
	
	function startBehaviour() 
	{
		
		
	}
	
}