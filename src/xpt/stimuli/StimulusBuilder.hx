package xpt.stimuli;

import xpt.preloader.Preloader;
import code.Scripting;
import diagnositics.DiagnosticsManager;
import diagnositics.DiagnosticsRecord;
import diagnositics.Timestamp;
import flash.desktop.Clipboard;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.util.StringUtil;
import openfl.events.Event;
import openfl.events.MouseEvent;
import xpt.debug.DebugManager;
import xpt.events.ExperimentEvent;
import xpt.experiment.Experiment;
import xpt.preloader.Preloader.PreloaderEvent;
import xpt.tools.XTools;
import xpt.trial.Trial;

#if html5
	import js.Browser;
#end

class StimulusBuilder {
	
	@:allow(StimImage)
	public var stim:Stimulus;
	
	public static var stageOffset_x:Float = 0;
	public static var stageOffset_y:Float = 0;
	
	public static var fontSize_multiplier:Float = 1;
	
	public function new() {
		#if html5
			//fontSize_multiplier = Browser.window.devicePixelRatio;
			//if (fontSize_multiplier > 1) fontSize_multiplier * .75;
		#end
	}
	
	public function kill() {
		stim = null;
	}
	
	public function set_text(txt:String) {
		//override
	}
	
	public function next(stim:Stimulus) {
		//to be overridden
	}
	
	public static function updateTrial_XY(x:Float, y:Float) {
		stageOffset_x = x;
		stageOffset_y = y;
	}
	
	public function enabled(val:String) {
		
	}
	
    private var reactionTime:Float = -1;
    
    public var stimType(get, null):String;
    private function get_stimType():String {
        return get("stimType");
    }
    
    public var stimId(get, null):String;
    private function get_stimId():String {
        return stim.id;
    }
    
	public var trial:Trial;
	
    public var experiment(get, null):Experiment;
    private function get_experiment():Experiment {
        return stim.experiment;
    }
	
	private function getDynamic(what:String, defaultValue:Dynamic = null):Dynamic {
		var v:Dynamic = defaultValue;
		if (stim == null) {
			return v;
		}
		
		var temp = stim.get(what);
		if (temp != null) {
			v = temp;
		}
		return v;
	}
	
	
	
	public function get(what:String, defaultValue:String = null):String {
		var v:String = defaultValue;
		if (stim == null) {
			return v;
		}
		var temp = stim.get(what);
		if (temp != null) {
			v = temp;
		}
		return v;
	}
	
    public function getStringArray(what:String, defaultValue:Array<String> = null, delim:String = ","):Array<String> {
       
        var v:String = get(what, null);
		if (v == null || v.length == 0) return defaultValue;

		var arr:Array<String> = [];
		var temp:Array<String> = v.split(delim);
		for (s in temp) {
			arr.push(StringTools.trim(s));
		}
		return arr;
    }

    
	public function getFloat(what:String, defaultValue:Float = -1):Float {
		var i = defaultValue;
		var v = get(what);
		if (v != null) {
			i = Std.parseFloat(v);
		}
		return i;
	}
	
	public function getInt(what:String, defaultValue:Int = -1):Int {
		var i = defaultValue;
		var v = get(what);
		if (v != null) {
			i = Std.parseInt(v);
		}
		return i;
	}
	
	public function getPercent(what:String, defaultValue:Float = -1):Float{
		var i = defaultValue;
		var v = get(what);
		if (v != null && StringTools.endsWith(v, "%") == true) {
			var s:String = cast v;
			i = Std.parseFloat(s.substr(0, s.length - 1));
		}
		return i;
	}
	
	public function exists(what:String):Bool {
		return stim.__properties.exists(what);
	}
	
	public function getBool(what:String, defaultValue:Bool = false):Bool {
		var b = defaultValue;
		var v = get(what);
		if (v != null) {
			b = (v == "true");
		}
		return b;
	}

	
	private function getUnit(propName:String, dimension:Float):Float {
		var v:Float = 0;
		if (getPercent(propName) != -1) {
			v = (getPercent(propName) * dimension) / 100;
		} else if (getInt(propName) != -1) {
			v = getInt(propName);
		}
		return v;
	}
	
    private function getColor(propName:String, defaultValue:Int = -1):Int {
        var stringValue:String = get(propName, null);
        if (stringValue == null) {
            return defaultValue;
        }
        return XTools.getColour(stringValue);
    }
	
    private function createComponentInstance():Component {
		return new Component();
	}
	
	@:allow(StimImage)
	private inline function sort_alignment(c:Component) {
		if (get("horizontalAlign") != null) {
			switch (get("horizontalAlign").toLowerCase()) {
                case "left":
                    //
				case "center" | "middle" | "centre":
					c.x -= .5 * c.width;
                case "right":
                    c.x -= c.width;
			}
		}

		if (get("verticalAlign") != null) {
			switch (get("verticalAlign").toLowerCase()) {
                case "top":
                   //
				case "center" | "middle" | "centre":
					c.y -= .5 * c.height;	
                case "bottom":
                    c.y -=  c.height;
			}
		}	
	}
	
	inline public function sortPosition(c:Component, root:Root) {
		c.x = getUnit("x", root.width);
		c.y = getUnit("y", root.height);
	}
	

	private function applyProperties(c:Component) {
		var root:Root = RootManager.instance.currentRoot;
		
		var text:String = get("text");
		
		if (text == null) {
			text = "";
		}
		#if html5
			text = text.split("\n").join("\n\n");
		#end
		
		c.text = text;

		c.visible = getBool("visible", true);
		
        sortDimensions(c, root);
		sortPosition(c, root);
		sort_alignment(c);
		
        if (get("marginLeft") != null)          c.x += getInt("marginLeft", 0);
        if (get("marginTop") != null)           c.y += getInt("marginTop", 0);
        if (get("marginRight") != null)         c.x -= getInt("marginRight", 0);
        if (get("marginBottom") != null)        c.y -= getInt("marginBottom", 0);
        
		if (c.width != 0 || c.height != 0) {
			c.autoSize = false;
		}
        
		if (getInt("fontSize") != -1) {
    
			var n = getInt("fontSize") * fontSize_multiplier;
			
            //if (n % 2 != 0) {
            //    n++;
            //}
			c.style.fontSize = n;
		}	
		
		var color:Int = getColor('color');
		if (color != -1) c.style.color = color;
		
		if (getBool("drawBox") == true) {
			c.style.borderSize = 1;
			c.style.borderColor = 0x000000;
		}
		
        if (get("borderSize") != null) {
            c.style.borderSize = getInt("borderSize", 1);
        }
        if (get("borderColour") != null) {
            c.style.borderColor = getColor("borderColour");
        }
        if (get("fillColour") != null) {
            c.style.backgroundColor = getColor("fillColour");
        }
        if (get("cornerRadius") != null) {
            c.style.cornerRadius = getInt("borderSize", 1);
        }
        
		if (get("onPreloadProgress") != null || get("onPreloadComplete") != null) {
			experiment.removeEventListener(PreloaderEvent.PROGRESS, onPreloaderProgress);
			experiment.removeEventListener(PreloaderEvent.COMPLETE, onPreloaderComplete);
			experiment.addEventListener(PreloaderEvent.PROGRESS, onPreloaderProgress);
			experiment.addEventListener(PreloaderEvent.COMPLETE, onPreloaderComplete);
		}
        
        if (get("onTrialValid") != null) {
            experiment.removeEventListener(ExperimentEvent.TRIAL_VALID, onTrialValid);
            experiment.addEventListener(ExperimentEvent.TRIAL_VALID, onTrialValid);
        }
        
        if (get("onTrialInvalid") != null) {
            experiment.removeEventListener(ExperimentEvent.TRIAL_INVALID, onTrialInvalid);
            experiment.addEventListener(ExperimentEvent.TRIAL_INVALID, onTrialInvalid);
        }
	}
	
	private function onPreloaderProgress(event:PreloaderEvent) {
		Scripting.runScriptEvent("onPreloadProgress", event, stim, false);
	}

	private function onPreloaderComplete(event:PreloaderEvent) {
		runScriptEvent("onPreloadComplete", event);
		experiment.removeEventListener(PreloaderEvent.PROGRESS, onPreloaderProgress, false);
		experiment.removeEventListener(PreloaderEvent.COMPLETE, onPreloaderComplete, false);
	}
	
	private function onTrialValid(event:ExperimentEvent) {
		Scripting.runScriptEvent("onTrialValid", event, stim);
	}
    
	private function onTrialInvalid(event:ExperimentEvent) {
		Scripting.runScriptEvent("onTrialInvalid", event, stim);
	}
    
    private function onStimValueChanged(value:Dynamic) {
        stim.value = value;
        trial.validateStims();
    }
    
	public inline function runScriptEvent(action:String, event:Event) {
		Scripting.runScriptEvent(action, event, stim);
	}

	private function addScriptVars(vars:Map<String, Dynamic>) {
		vars.set("this", stim.component);
		vars.set("me", stim.component);
	}
	
	public function build(stim:Stimulus):Component {
		this.stim = stim;
		var c = createComponentInstance();
		applyProperties(c);

		return c;
	}
	
    public function update():Void {
        if(stim != null) applyProperties(stim._component);
    }
	
	public function buildPreloadList(props:Map<String, String>):Array<String> {
		return null;
	}
	
    private function addMouseDiagnostics(event:MouseEvent):Void {
        var diagnosticsEvent:String = null;
        switch (event.type) {
            case MouseEvent.CLICK:
                diagnosticsEvent = DiagnosticsManager.STIMULUS_CLICK;
                if (getBool("reactionTime") == true) {
                    var timestamp:Float = Timestamp.get();
                    var diagnosticsRecord:DiagnosticsRecord = DiagnosticsManager.findLast(DiagnosticsManager.STIMULUS_SHOW, stimId, stimType);
                    if (diagnosticsRecord != null) {
                        var delta:Float = timestamp - diagnosticsRecord.timestamp;
                        DebugManager.instance.stimulus('Recording reaction time for ${stimId}', '${delta}ms');
                        reactionTime = delta;
                    }
                }
        }
        if (diagnosticsEvent == null) {
            DebugManager.instance.warning("Could not map mouse event to diagnostics event: " + event.type);
            return;
        }
        DiagnosticsManager.add(diagnosticsEvent, stimId, stimType, [
            'mouse.x: ${event.localX}',
            'mouse.y: ${event.localY}'
        ]);
    }
	
	inline function sortDimensions(c:Component, root:Root):Void 
	{
		var cx = getUnit("width", root.width);
		if (cx > 0) {
			c.width = cx;
		}
		var cy = getUnit("height", root.height);
		if (cy > 0) {
			c.height = cy;
		}
	}
	
	public function snapshot(nam:String) {
		//override
	}
    
	//override this
	public function results():Map<String,String> {
		if (stim == null || stim.value == null) return null;
		
		var r:Map<String,String> = new Map<String,String>();
		r.set('', Std.string(stim.value));
		return r;
	}
    
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public function onAddedToTrial() {
		Scripting.runScriptEvent("onAdded", null, stim, false);
    }
    
    public function onRemovedFromTrial() {
		Scripting.runScriptEvent("onRemoved", null, stim, false);
    }
}