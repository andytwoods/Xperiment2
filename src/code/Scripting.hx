package code;
import code.CheckIsCode.RunCodeEvents;
import haxe.io.StringInput;
import haxe.ui.toolkit.hscript.ScriptInterp;
import haxe.ui.toolkit.util.StringUtil;
import hscript.Interp;
import hscript.Parser;
import motion.Actuate;
import motion.easing.Quad;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.Lib;
import openfl.utils.Object;
import wrappers.SystemWrapper;
import xpt.debug.DebugManager;
import xpt.experiment.Experiment;
import xpt.stimuli.StimHelper;
import xpt.stimuli.Stimulus;
import xpt.trial.Trial;


class Scripting
{

	public static var scriptEngine:ScriptInterp = new ScriptInterp();
	public static var testing:Bool = true; //for testing
	
    public static var experiment:Experiment;
    
	static public function init(experiment:Experiment) {
		scriptEngine = new ScriptInterp();
		scriptEngine.variables.set("Experiment", experiment);
		scriptEngine.variables.set("Debug", DebugManager.instance);
		scriptEngine.variables.set("Motion", Actuate);
		scriptEngine.variables.set("Quad", Quad);
		scriptEngine.variables.set("Stage", Lib.current.stage);		
        
        Scripting.experiment = experiment;
	}
	
	static public function DO(script:Xml, c:RunCodeEvents, trial:Trial = null):String {
		
		var code:String;
		
		if (RunCodeEvents.BeforeTrial == c) {
			scriptEngine.variables.set("Trial", trial);	
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
	
	static public inline function removeStimuli(stimuli:Array<Stimulus>) 
	{
		for (stim in stimuli) {
			if (stim.id != null) {
					scriptEngine.variables.remove(stim.id);
			}
		}
	}
	
	static public inline function addStimuli(stimuli:Array<Stimulus>) 
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
		var parser = new hscript.Parser();
		var expr = parser.parseString(s);
		scriptEngine.execute(expr);
	}
	
	
	
	
	public static function runScriptEvent(prop:String, event:Event, stim:Stimulus, logScript:Bool = true) {
		
		if (stim.get(prop) != null) {
			try {
				scriptEngine.variables.set("this", stim.component);
				scriptEngine.variables.set("me", stim.component);
				scriptEngine.variables.set("stim", stim);
				scriptEngine.variables.set("e", event);

				
				addExtraVars(scriptEngine.variables, experiment.runningTrial.stimuli);
                
				var parser = new hscript.Parser();
				var s:String = StringTools.trim(stim.get(prop));
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
	
	
	private static function addExtraVars(variables:Map<String, Dynamic>, stimuli:Array<Stimulus> = null) 
	{
		scriptEngine.variables.set("Trial", experiment.runningTrial);
		scriptEngine.variables.set("Stims", StimHelper);
		scriptEngine.variables.set("System", new SystemWrapper());
		scriptEngine.variables.set("Experiment", experiment);
		var stimGroups:Map<String,Array<Stimulus>> = Stimulus.groups;
		if (stimGroups != null) {
			for (groupName in stimGroups.keys()) {
				var group:Array<Stimulus> = stimGroups.get(groupName);
				if (group != null && group.length > 0 && groupName != null) {
					scriptEngine.variables.set(groupName, group);
				}
			}
		}
		
		if(stimuli != null ){
			for (stim in stimuli) {
				scriptEngine.variables.set(stim.id, stim);
			}
		}
	}
	

	
	//TO DO: merge below with above F
	 public static function expandScriptValues(script:String, vars:Map<String, Dynamic> = null, exceptions:Array<String> = null, stimuli:Array<Stimulus> = null):String {
   
		var finalResult:String = script;
		var n1:Int = finalResult.indexOf("${");
        var scriptEngine:ScriptInterp = new ScriptInterp();
        if (vars != null) {
			
            for (key in vars.keys()) {
				if(key!=null)   scriptEngine.variables.set(key, vars.get(key));
            }
            
        }
		if(stimuli!=null){
			for (stim in stimuli) {
				scriptEngine.variables.set(stim.id, stim);	
			}
		}
		
		//addExtraVars(scriptEngine.variables, stimuli);
		
		

		var parser = new hscript.Parser();
        
        while (n1 != -1) {
            var n2:Int = finalResult.indexOf("}", n1);
            var e:String = finalResult.substring(n1 + 2, n2);
            if (exceptions != null && exceptions.indexOf(e) != -1) {
                n1 = finalResult.indexOf("${", n2);
                continue;
            }
            var expr = parser.parseString(e);
            var r = scriptEngine.execute(expr);
            var before:String = finalResult.substring(0, n1);
            var after:String = finalResult.substring(n2 + 1, finalResult.length);
            finalResult = before + r + after;
            n1 = finalResult.indexOf("${");
        }
        
        return finalResult;
    }
	

	
	public static inline function checkIsCode(str:String):Bool {
		return str.indexOf("${") != -1;
	}

}


