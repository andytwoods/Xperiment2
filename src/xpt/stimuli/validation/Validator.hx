package xpt.stimuli.validation;

import haxe.ui.toolkit.hscript.ScriptInterp;
import xpt.stimuli.Stimulus;

class Validator extends ScriptInterp {
    private var _stim:Stimulus;
    
    public function new() {
        super();
        
        variables.set("notEmpty", notEmpty);
        variables.set("equals", equals);
        variables.set("notEquals", notEquals);
        variables.set("startsWith", startsWith);
        variables.set("endsWith", endsWith);
        variables.set("numeric", numeric);
        variables.set("greaterThan", greaterThan);
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
        return (stim.value != null && stim.value != "");
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