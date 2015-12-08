package xpt.runner;
import code.CheckIsCode;
import code.Code;
import comms.services.UrlParams_service;
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
	
	public function run(script:Xml) 
	{
		initiateOverExperimentStuff();
			
		Code.DO(script, Checks.BeforeEverything);
		
		//ProcessScript.DO(script);
		var betweenSJs:BetweenSJs = new BetweenSJs();
		script = betweenSJs.compose(script, UrlParams_service.get('overSJs'));
	
		currentExpt = new Experiment(script);
		
		
	}
	
	function initiateOverExperimentStuff() 
	{
	
	}
	

	
	
	function startBehaviour() 
	{
		
		
	}
	
}