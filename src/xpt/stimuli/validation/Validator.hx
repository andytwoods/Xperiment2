package xpt.stimuli.validation;

import haxe.ui.toolkit.hscript.ScriptInterp;
import xpt.stimuli.Stimulus;

class Validator extends ScriptInterp {
    private static var _instance:Validator;
    public static var instance(get, null):Validator;
    private static function get_instance():Validator {
        if (_instance == null) {
            _instance = new Validator();
        }
        return _instance;
    }
    
    private var _stim:Stimulus;
    
    private function new() {
        super();
        
        variables.set("notEmpty", notEmpty);
        variables.set("equals", equals);
        variables.set("notEquals", notEquals);
        variables.set("startsWith", startsWith);
        variables.set("endsWith", endsWith);
        variables.set("numeric", numeric);
        variables.set("greaterThan", greaterThan);
        variables.set("prop", prop);
        variables.set("groups", groups);
    }

    public function validateStim(stim:Stimulus, validation:String):Bool {
        _stim = stim;
        var valid:Bool = false;
        if (validation.indexOf("(") != -1 && validation.indexOf(")") != -1) { // lets assume if there are brackets, its a script
            valid = validateStimScript(validation);
        } else { // otherwise lets assume its a list of valid strings
            valid = validateDiscreteList(validation);
        }
        return valid;
    }
    
    private function validateStimScript(script:String):Bool {
        var parser = new hscript.Parser();
        var program = parser.parseString(script);
        
        var r = "" + execute(program);
        return (r == "true");
    }
    
    private function validateDiscreteList(list:String):Bool {
        var valid:Bool = false;
        var stimValue:String = "" + _stim.value;
        var strings:Array<String> = list.split(",");
        for (s in strings) {
            s = StringTools.trim(s);
            if (s == stimValue) {
                valid = true;
                break;
            }
        }
        return valid;
    }
    
	//*********************************************************************************
	// VALIDATION FUNCTIONS
	//*********************************************************************************
    private function notEmpty(stim:Stimulus):Bool {
		if (stim.value == 0) return true;
        return (stim.value != null && stim.value != "" );
    }
    
    private function equals(stim:Stimulus, v:Dynamic):Bool {
        return (stim.value == v);
    }
    
    private function notEquals(stim:Stimulus, v:Dynamic):Bool {
        return (stim.value != v);
    }
    
    private function startsWith(stim:Stimulus, v:Dynamic):Bool {
        return StringTools.startsWith(stim.value, v);
    }
    
    private function endsWith(stim:Stimulus, v:Dynamic):Bool {
        return StringTools.endsWith(stim.value, v);
    }
    
    private function numeric(stim:Stimulus):Bool {
        return (Std.parseInt(stim.value) != null && Std.parseFloat(stim.value) != Math.NaN);
    }
    
    private function greaterThan(stim:Stimulus, v:Float):Bool {
        return numeric(stim) && (stim.value > v);
    }
    
    private function prop(stim:Stimulus, v:String):Dynamic {
        return stim.get(v);
    }
    
    private function groups(stim:Stimulus, v:String):String { 
        var groupIds:Array<String> = [];
        var groupStims:Array<Stimulus> = Stimulus.getGroup(v);
        if (groupStims != null) {
            for (groupStim in groupStims) {
                groupIds.push(groupStim.id);
            }
        }
        return groupIds.join(",");
    }
	//*********************************************************************************
	// OVERRIDES
	//*********************************************************************************
    override function fcall(o:Dynamic, f:String, args:Array<Dynamic>):Dynamic {
        return super.fcall(o, f, args);
    }
    
    override function call(o:Dynamic, f:Dynamic, args:Array<Dynamic>):Dynamic {
        args.insert(0, _stim); // lets assume that if its a function call we'll insert the stim as the first param
        return super.call(o, f, args);
    }
}