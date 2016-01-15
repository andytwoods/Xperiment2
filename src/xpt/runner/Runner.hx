package xpt.runner;
import code.CheckIsCode;
import code.Scripting;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.utils.Object;
import xpt.comms.services.UrlParams_service;
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
			
		Scripting.DO(script, RunCodeEvents.BeforeEverything);
		
		//ProcessScript.DO(script);
		var betweenSJs:BetweenSJs = new BetweenSJs();
		script = betweenSJs.compose(script, UrlParams_service.get('overSJs'));
	
		currentExpt = new Experiment(script, url, params);
		
		
	}
	
	function initiateOverExperimentStuff() 
	{
	
	}
	

	
	
	function startBehaviour() 
	{
		
		
	}
	
}