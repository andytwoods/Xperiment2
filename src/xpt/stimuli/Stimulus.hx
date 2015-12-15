package xpt.stimuli;

import haxe.ui.toolkit.core.Component;

@:allow(xpt.trialOrder.Test_TrialOrder)
class Stimulus {
	public var parent:Stimulus;
	public var children:Array<Stimulus> = new Array<Stimulus>();
	
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
			default:
				__properties.set(what, val);
		}
	}
	
	//to be overriden by stimuli returning data
	public function results():Map<String,String> {

		//does not need below as logic is used elsewhere in ExtractResults
		//if (hideResults == true) return null;
		
		if (builder != null) {
			var myResults:Map<String,String> = builder.results();
	
			var labelledResults:Map<String,String> = new Map<String,String>();
			var label:String;
			if(myResults !=null && labelledResults!=null){
				for (key in myResults.keys()) {
				
					if (key.length == 0) label = key;
					else label = id + "_" + key;
					//if the key is empty, just use this stim's id, else use id+"_"+key.
					labelledResults.set(label, myResults.get(key));
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
		
		for (child in children) {
			if (_component.contains(child.component) == false) {
				_component.addChild(child.component);
			}
		}
		return _component;
	}
	
	private function disposeComponent() {
		if (_component != null) {
			for (child in children) {
				child.disposeComponent();
			}
			if (_component.parent != null && _component.parent.contains(_component)) {
				_component.parent.removeChild(_component);
			} else {
				_component.dispose();
			}
			_component = null;
		}
	}
}

