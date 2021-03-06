package code;
import code.CheckIsCode.RunCodeEvents;
import code.utils.Text;
import haxe.io.StringInput;
import haxe.ui.toolkit.controls.HProgress;
import haxe.ui.toolkit.hscript.ScriptInterp;
import haxe.ui.toolkit.util.StringUtil;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import motion.Actuate;
import motion.easing.Quad;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.Lib;
import openfl.utils.Object;
import thx.Strings;
import wrappers.SystemWrapper;
import xpt.debug.DebugManager;
import xpt.experiment.Experiment;
import xpt.ExptWideSpecs;
import xpt.stimuli.StimHelper;
import xpt.stimuli.StimTools;
import xpt.stimuli.Stimulus;
import xpt.tools.XRandom;
import xpt.tools.XTools;
import xpt.trial.Trial;



class ScriptBundle {
	public var scriptEngine:ScriptInterp = new ScriptInterp();
	public var parser = new hscript.Parser();
	public var program:Expr;
	public var code:String;
	
	public var recycleList:Array<String> = new Array<String>();
	
	public function add(nam:String, what:Dynamic) {
		scriptEngine.variables.set(nam, what);
		recycleList.push(nam);
	}
	
	public function recycle() {
		while(recycleList.length>0) {
			scriptEngine.variables.remove(recycleList.shift());
		}
		code = null;
	}
	
	public function run():Dynamic {
	
		code = StringTools.replace(code, "|", ";");
		code = StringTools.replace(code, "\t", " ");
		program = parser.parseString(code);
		return scriptEngine.execute(program);
	}
	
	public function new() {
	}
}


class Scripting
{
	
	public static var bundles:Array<ScriptBundle> = new Array<ScriptBundle>();
	private static var all_bundles:Array<ScriptBundle> = new Array<ScriptBundle>();
	
	public static var testing:Bool = true; //for testing
    public static var experiment:Experiment;
	static public var stimuli:Array<Stimulus>;
	
	public static function getBundle():ScriptBundle {
		
		if (bundles.length == 0) {
			return generateBundle();
		}
		
		return bundles.shift();
	}
	

	static private function generateBundle():ScriptBundle  
	{
		var bundle:ScriptBundle = new ScriptBundle();
		
		bundle.scriptEngine.variables.set("Experiment", experiment);
		bundle.scriptEngine.variables.set("Debug", DebugManager.instance);
		bundle.scriptEngine.variables.set("Filter", Actuate);
		bundle.scriptEngine.variables.set("Stage", Lib.current.stage);	
		bundle.scriptEngine.variables.set("Stims", StimHelper);
		bundle.scriptEngine.variables.set("System", new SystemWrapper());
		bundle.scriptEngine.variables.set("Text", Text);
		bundle.scriptEngine.variables.set("Tools", StimTools);
		bundle.scriptEngine.variables.set("ExptWideSpecs", ExptWideSpecs);
		bundle.scriptEngine.variables.set("Random", XRandom);
		

		all_bundles.push(bundle);

		return bundle;
	}
    
	static public function returnBundle(bundle:ScriptBundle) {
		bundle.recycle();
		bundles.push(bundle);
	}
	
	
	static public function init(experiment:Experiment) {
		while (bundles.length > 0) {
			bundles.pop();
		}
		while (all_bundles.length > 0) {
			all_bundles.pop();
		}
		
		Scripting.experiment = experiment;
		returnBundle(generateBundle());
	}
	
	static public function DO(script:Xml, c:RunCodeEvents, trial:Trial = null):String {
		

		var bundle:ScriptBundle;
		
		if (RunCodeEvents.BeforeTrial == c) {
			bundle = getBundle();
			bundle.add("Trial", trial);	
			bundle.code = trial.codeStartTrial;
		}
		else if (RunCodeEvents.AfterTrial == c) {
			bundle = getBundle();
			bundle.code = trial.codeEndTrial;
		}
		else {
			bundle = getBundle();
			bundle.code = CheckIsCode.DO(script,c);
		}
			
		if (bundle.code == null) return null;
		
		if (testing == false) {
			bundle.run();
			returnBundle(bundle);
		}
		
		return bundle.code;
	}
	

	
	static public function scriptableStimuli(stimuli:Array<Stimulus>, add:Bool) {

		for (bundle in all_bundles) {
			
			for (stim in stimuli) {
				if (stim.id != null) {
						if (add) 	bundle.scriptEngine.variables.set(stim.id, stim);
						else 		bundle.scriptEngine.variables.remove(stim.id);
				}
			}
		}
		
		var stimGroups:Map<String,Array<Stimulus>> = Stimulus.groups;
		if (stimGroups != null) {
			for (groupName in stimGroups.keys()) {
				var group:Array<Stimulus> = stimGroups.get(groupName);
				if (group != null && group.length > 0 && groupName != null) {
					for (bundle in all_bundles) {
						if (add) 	bundle.scriptEngine.variables.set(groupName, group);
						else 		bundle.scriptEngine.variables.remove(groupName);
						bundle.add(groupName, group);
					}						
				}
			}
		}
		
	}
	
	public static function runScriptEvent(prop:String, event:Event, stim:Stimulus, logScript:Bool = true) {
		if (stim == null) return;
		var code = stim.get(prop, null);

		if (code != null) {
			//trace(prop, event, stim, code, Math.random);
			code = repair(code);
			var bundle:ScriptBundle = getBundle();
			try {
				bundle.add("this", stim.component);
				bundle.add("me", stim.component);
				bundle.add("stim", stim);
				bundle.add("event", event);
				if(event!=null) bundle.add("e", event);

				addExtraVars(bundle);
				
				bundle.code = StringTools.trim(code);

				
				if (logScript == true) {
					DebugManager.instance.event(stim.get("stimType") + ".on" + StringUtil.capitalizeFirstLetter(event.type), "" + bundle.code);
				}
				bundle.run();
				
			} catch (e:Dynamic) {
				trace("ERROR executing script: " + e + " code: " + bundle.code+ '(prop: '+prop+').');
				DebugManager.instance.error("Error running script event", "" + e);
			}
			
			returnBundle(bundle);
		}
		
		
	}
	
	private static var repairs:Map<String,String> = ["&amp;" => "&", "&gt;" => ">"];
	private static inline function repair(str:String) {
		for (key in repairs.keys()) {
			str = str.split(key).join(repairs.get(key));
		}
		return str;
	}
	
	
	private static function addExtraVars(bundle:ScriptBundle) 
	{
		if (experiment.runningTrial != null) {
			bundle.add("Trial", experiment.runningTrial);
		}
		for (stim in stimuli) {
			if(stim.id != Stimulus.UNSPECIFIED) bundle.add(stim.id, stim);
		}
	}
	
	
	
	 public static function expandScriptValues(script:String, vars:Map<String, Dynamic> = null, exceptions:Array<String> = null, stimuli:Array<Stimulus> = null ):String {

		var finalResult:String = script;
		var n1:Int = finalResult.indexOf("${");
       
		var bundle:ScriptBundle = getBundle();
		
        if (vars != null) {
            for (key in vars.keys()) {
				if(key!=null)   bundle.add(key, vars.get(key));
            }
        }
		
		if (stimuli != null) {
            for (stimulus in stimuli) {
				if (stimulus != null) {
					bundle.add(stimulus.id, stimulus);
				}
            }   
        }
        
        while (n1 != -1) {
            var n2:Int = finalResult.indexOf("}", n1);
            bundle.code = finalResult.substring(n1 + 2, n2);
            if (exceptions != null && exceptions.indexOf(bundle.code) != -1) {
                n1 = finalResult.indexOf("${", n2);
                continue;
            }
            var r = bundle.run();
            
            var before:String = finalResult.substring(0, n1);
            var after:String = finalResult.substring(n2 + 1, finalResult.length);
            finalResult = before + r + after;
            n1 = finalResult.indexOf("${");
        }
        
		returnBundle(bundle);

        return finalResult;
    }
	

	
	public static inline function checkIsCode(str:String):Bool {
		return str.indexOf("${") != -1;
	}

}


