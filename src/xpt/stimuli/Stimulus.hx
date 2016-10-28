package xpt.stimuli;

import code.Scripting;
import flash.events.Event;
import flash.events.MouseEvent;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import thx.Strings;
import xpt.experiment.Experiment;
import xpt.stimuli.validation.Validator;
import xpt.timing.TimingManager;
import xpt.tools.XTools;
import xpt.trial.Trial;

@:allow(xpt.stimuli.builders.Test_Stimulus)
@:allow(xpt.trialOrder.Test_TrialOrder)
@:allow(xpt.stimuli.StimulusBuilder)
class Stimulus {
	
	static public inline var UNSPECIFIED:String = 'unspecified';
	
	public var start:Float = 0;
	public var stop:Float = -1;
	public var duration:Float = -1;
	public var hideResults:Bool = false;
	public var id:String = UNSPECIFIED;
	public var depth:Int = 50;
	public var ran:Bool = false;
	public var type:String;
	
    public var value:Dynamic;
	public var props:Map<String,String>;
    
	private var __properties:Map<String,Dynamic>;
	private var __underlings:Array<Stimulus> = [];
	
	public function new() {
		__properties = new Map<String, Dynamic>();
	}
	
	public function next(stim:Stimulus) {
		builder.next(stim);
	}
	
	public function moveY(modY:Float) {
		this.component.y = modY;
	}
	
	public function hide() {
		this._component.visible = false;
	}
	
	public function enabled(val:String) {
		builder.enabled(val);
	}
	
	public function show() {
		this._component.visible = true;
	}
	
	public function text(str:String) {
		this.builder.set_text(str);
	}
	
	public function snapshot(nam:String) {
		builder.snapshot(nam);
	}
	
	public function begin(delay:Int = 0) {
		function start_from_trial() {
		
			if (builder.trial != null) {
				builder.trial.addStimulus(this);	
			}
		}
		
		if (delay != 0) {
			XTools.delay(delay, function() {
				start_from_trial();
			});
		}
		else {
			start_from_trial();
		}
	}
	
	
	public function end(delay:Int = 0) {
		function stop_from_trial() {
			if (builder.trial != null) {
				builder.trial.addStimulus(this);	
			}
		}
		
		if (delay != 0) {
			XTools.delay(delay, function() {
				stop_from_trial();
			});
		}
		else stop_from_trial();
		
	}
	
    public var isValid(get, null):Bool;
    private function get_isValid():Bool {
        var valid:Bool = true;
        if (get("valid") != null) {
            valid = Validator.instance.validateStim(this, get("valid"));
        }
        return valid;
    }
    
    public var experiment(get, null):Experiment;
    private function get_experiment():Experiment {
        return Scripting.experiment;
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
	
	public function setProps(stimProps:Map<String, String>) 
	{
		props = stimProps;
		for (key in stimProps.keys()) {
			this.set(key, stimProps.get(key	));
		}
	}
	
	public function get(what:String, defaultValue:String = null):Dynamic {
		switch(what) {
			case 'start': return start;
			case 'stop': return stop;		
			case 'duration': return duration;
            case 'group': return _groupName;
		}

        if (__properties == null) {
            return defaultValue;
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
	
	public function setDynamic(what:String, val:Dynamic) {
		var prev = __properties.get(what);
		if(Std.is(prev, Int)) {
			__properties.set(what, Std.parseInt(val));
		}
		else if (Std.is(prev, Float)) {
			__properties.set(what, Std.parseFloat(val));
		}
		else if(Std.is(prev, String)) {
			__properties.set(what, Std.string(val));
		}
		else throw 'unknown type: '+Std.string(prev);
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
		removeListeners();
		builder.kill();
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
				throw "No builder set for stimulus";
			}
			_component = builder.build(this);
		}
	
		return _component;
	}
		
	
    public function updateComponent():Void {
        if (_component != null) {
            builder.update();
        }
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
	// CALLBACKS
	//*********************************************************************************
    public function onAddedToTrial() {
        if (builder != null) {
			addListeners();
            builder.onAddedToTrial();
        }
    }
    
    public function onRemovedFromTrial() {
        if (builder != null) {
            builder.onRemovedFromTrial();
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
    
    public static function getGroup(groupName:String):Array<Stimulus> {
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
	
	//*********************************************************************************
	// LISTENERS
	//*********************************************************************************
    private static var possibleMouseListeners:Map<String,String> = ['onClick'=>MouseEvent.CLICK, 'onMouseDown'=>MouseEvent.MOUSE_DOWN, 'onChange' =>UIEvent.CHANGE ];
	private var listeners:Map<String, Stim_Listener>;
	
	
	private function removeListeners() {
		if (listeners == null) return;
		
		var listener:Stim_Listener;

		for (nam in listeners.keys()) {
			listener = listeners.get(nam);
			listener.remove();
			listener = null;
		}
		listeners = null;
	}
	
	private function addListeners() {
		var found:String;
		var stim_listener:Stim_Listener;
		var type:String;
		
		for (listener in possibleMouseListeners.keys()) {
			
			found = get(listener);
			if (found != null && found.length>0) {
				if (listeners == null) listeners = new Map<String,Stim_Listener>();
				type = possibleMouseListeners.get(listener);
				stim_listener = new Stim_Listener();	
				stim_listener.type = listener;
				stim_listener.remove = function() {
					//if necessary used for testing purposes
					if(_component!=null)	_component.removeEventListener(type, listenerF);
				}
	
				//if logic necessary for testing purposes
				if(_component!=null)	_component.addEventListener(type, listenerF);	
				listeners.set(type, stim_listener);
			}
		}
	}
	
	private function listenerF(e:Event) {
		var listener:Stim_Listener = listeners.get(e.type);
		Scripting.runScriptEvent(listener.type, e, this);	

	}
}


class Stim_Listener {
	public var type:String;
	public var remove:Void->Void;

	public function new() {}
	
	
}