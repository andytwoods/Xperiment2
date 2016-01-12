package code;
import code.CheckIsCode.RunCodeEvents;
import haxe.io.StringInput;
import haxe.ui.toolkit.hscript.ScriptInterp;
import haxe.ui.toolkit.util.StringUtil;
import hscript.Interp;
import hscript.Parser;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.utils.Object;
import preloader.Preloader.PreloaderEvent;
import xpt.debug.DebugManager;
import xpt.experiment.Experiment;
import xpt.stimuli.Stimulus;
import xpt.trial.Trial;


class Scripting
{

	public static var scriptEngine:ScriptInterp = new ScriptInterp();
	public static var testing:Bool = true; //for testing
	
	static public function init(experiment:Experiment) {
		scriptEngine = new ScriptInterp();
		scriptEngine.variables.set("Experiment", experiment);
		scriptEngine.variables.set("Debug", DebugManager.instance);
		
	}
	
	static public function DO(script:Xml, c:RunCodeEvents, trial:Trial = null):String {
		
		var code:String;
		
		if (RunCodeEvents.BeforeTrial == c) {
			code = trial.codeStartTrial;
		}
		else if (RunCodeEvents.AfterTrial == c) {
			code = trial.codeEndTrial;
		}
		else {
			code = CheckIsCode.DO(script,c);
		}
			
		if (code == null) return null;
		
		if(testing == false) runScript(code);
		
		return code;
	}
	
	static public function __codingCode(code:String, script:Xml, trial:Trial) 
	{
		
	}
	
	static public function __codingXML(code:String, script:Xml) 
	{
		
	}
	
	static public function removeStimuli(stimuli:Array<Stimulus>) 
	{
		for (stim in stimuli) {
			if (stim.id != null) {
					scriptEngine.variables.remove(stim.id);
			}
		}
	}
	
	static public function addStimuli(stimuli:Array<Stimulus>) 
	{
		for(stim in stimuli){
			if (stim.id != null) {
				scriptEngine.variables.set(stim.id, stim);
			}
		}
	}
	
	static public function runScript(s:String) 
	{
		s = StringTools.replace(s, "|", ";");
		s = StringTools.replace(s, "\t", " ");
		s = StringTools.replace(s, "\r\n", ";\n");
		var parser = new hscript.Parser();
		var expr = parser.parseString(s);
		scriptEngine.execute(expr);
	}
	
	
	
	
	public static function runScriptEvent(prop:String, event:Event, stim:Stimulus, logScript:Bool = true) {

		if (stim.get(prop) != null) {
			
			try {
				scriptEngine.variables.set("this", stim.component);
				scriptEngine.variables.set("me", stim.component);
				scriptEngine.variables.set("e", event);
				var parser = new hscript.Parser();
				var s:String = StringTools.trim(stim.get(prop));
				s = StringTools.replace(s, "|", ";");
				s = StringTools.replace(s, "\t", " ");
				s = StringTools.replace(s, "\r\n", ";\n");
				if (logScript == true) {
					DebugManager.instance.event(stim.get("stimType") + ".on" + StringUtil.capitalizeFirstLetter(event.type), "" + s);
				}
				var expr = parser.parseString(s);

				Scripting.scriptEngine.execute(expr);
			} catch (e:Dynamic) {
				trace("ERROR executing script: " + e);
				DebugManager.instance.error("Error running script event", "" + e);
			}
		}
	}
	
	var rand:Float = Math.random();
	
	//override this
	public function results():Map<String,String> {
		return null;
	}
	

}


