package xpt.stimuli;

import haxe.ui.toolkit.core.Component;
import xpt.tools.XTools;

@:allow(xpt.trialOrder.Test_TrialOrder)
class Stimulus {
	public var start:Float = -1;
	public var stop:Float = -1;
	public var duration:Float = -1;
	public var hideResults:Bool = false;
	public var id:String;
	public var depth:Int;
	public var ran:Bool = false;
	public var type:String;
	
	private var __properties:Map<String,Dynamic>;
	private var __underlings:Array<Stimulus> = [];

	public function new() {
		__properties = new Map<String, Dynamic>();
	}
	

    private var _groupName:String;
	public var groupName(get, set):String;   
    private function get_groupName():String {
        return _groupName;
    }
    private function set_groupName(value:String):String {
        if (value == _groupName) {
            return value;
        }
        _groupName = value;
        addToGroup(_groupName, this);
        return value;
    }
    
    public var group(get, null):Array<Stimulus>;
    private function get_group():Array<Stimulus> {
        return getGroup(_groupName);
    }
    
	public function addUnderling(stim:Stimulus) {
		__underlings.push(stim);
	}
	
	public function tidy_beforeRun() {
		if (duration != -1) {
			stop = start += duration;
		}
	}
	
	public function get(what:String):Dynamic {
		switch(what) {
			case 'start': return start;
			case 'stop': return stop;		
			case 'duration': return duration;
            case 'group': return _groupName;
		}

		return __properties.get(what);
	}
	
	public function getInt(what:String, defaultValue:Int = -1):Int {
		var i = defaultValue;
		var v = get(what);
		if (v != null) {
			i = Std.parseInt(v);
		}
		return i;
	}
	
	public function getPercent(what:String, defaultValue:Int = -1):Int {
		var i = defaultValue;
		var v = get(what);
		if (v != null && StringTools.endsWith(v, "%") == true) {
			var s:String = cast v;
			i = Std.parseInt(s.substr(0, s.length - 1));
		}
		return i;
	}
	
	public function getBool(what:String, defaultValue:Bool = false):Bool {
		var b = defaultValue;
		var v = get(what);
		if (v != null) {
			b = (v == "true");
		}
		return b;
	}
	
	public function set(what:String, val:Dynamic) {
		switch(what.toLowerCase()) {
			case 'start':
				start = Std.parseFloat(val);
			case 'stop':
				stop = Std.parseFloat(val);
			case 'duration':
				duration = Std.parseFloat(val);
			case 'hideresults':
				var str:String = Std.string(val).toLowerCase();
				if (str == 'true') hideResults = true;
			case 'id':
				id = Std.string(val);
			case 'depth':
				depth = Std.parseInt(val);
            case 'group':
                groupName = Std.string(val);
			default:
				__properties.set(what, val);
		}
	}
	
	public function results(trial_id:String):Map<String,String> {
		//does not need below as logic is used elsewhere in ExtractResults
		//if (hideResults == true) return null;
		
		if (builder != null) {
			var myResults:Map<String,String> = builder.results();
	
			var labelledResults:Map<String,String> = new Map<String,String>();
			var label:String;
			if(myResults !=null && labelledResults!=null){
				for (key in myResults.keys()) {
				
					if (key.length == 0) label = id;
					else label = id + "_" + key;
					labelledResults.set(trial_id+label, myResults.get(key));
				}

				if(label !=null) return labelledResults;
			}
		}
		return null;
	}
	public function kill() {
		__underlings = null;
		__properties = null;
		
		disposeComponent();
	}
	
	//*********************************************************************************
	// BUILDER / COMPONENT 
	//*********************************************************************************
	public var builder(default, default):StimulusBuilder;
	
	private var _component:Component;
	public var component(get, null):Component;
	private function get_component():Component {
		if (_component == null) {
			if (builder == null) {
				throw "No builder set of stimulus";
			}
			_component = builder.build(this);
		}
		return _component;
	}
	
    public function updateComponent():Void {
        builder.update();
    }
    
	private function disposeComponent() {
		if (_component != null) {
			if (_component.parent != null && _component.parent.contains(_component)) {
				_component.parent.removeChild(_component);
			} else {
				_component.dispose();
			}
			_component = null;
		}
	}
    
	//*********************************************************************************
	// GROUPING
	//*********************************************************************************
    private static var _groups:Map<String, Array<Stimulus>>;
    private static function addToGroup(groupName:String, stim:Stimulus):Void {
        if (_groups == null) {
            _groups = new Map<String, Array<Stimulus>>();
        }
        
        var group:Array<Stimulus> = _groups.get(groupName);
        if (group == null) {
            group = new Array<Stimulus>();
            _groups.set(groupName, group);
        }
        
        if (group.indexOf(stim) == -1) {
            group.push(stim);
        }
    }
    
    private static function getGroup(groupName:String):Array<Stimulus> {
        if (_groups == null || groupName == null) {
            return null;
        }
        return _groups.get(groupName);
    }
    
    public static var groups(get, null):Map<String,Array<Stimulus>>;
    private static function get_groups():Map<String,Array<Stimulus>> {
        return _groups;
    }
    
    public static function resetGroups():Void {
        _groups = null;
    }
    
}

