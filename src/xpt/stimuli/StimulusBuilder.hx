package xpt.stimuli;

import code.Scripting;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.util.StringUtil;
import openfl.events.Event;
import xpt.debug.DebugManager;
import xpt.experiment.Experiment;
import xpt.experiment.Preloader.PreloaderEvent;
import xpt.trial.Trial;

class StimulusBuilder {
	private var _stim:Stimulus;
	
	public function new() {
		
	}
	
	private var trial(get, null):Trial;
	private function get_trial():Trial {
		var t:Trial = getDynamic("trial");
		return t;
	}
	
	private var experiment(get, null):Experiment;
	private function get_experiment():Experiment {
		if (trial == null) {
			return null;
		}
		return trial.experiment;
	}
	
	private function getDynamic(what:String, defaultValue:Dynamic = null):Dynamic {
		var v:Dynamic = defaultValue;
		if (_stim == null) {
			return v;
		}
		
		var temp = _stim.get(what);
		if (temp != null) {
			v = temp;
		}
		return v;
	}
	
	private function get(what:String, defaultValue:String = null):String {
		var v:String = defaultValue;
		if (_stim == null) {
			return v;
		}
		var temp = _stim.get(what);
		if (temp != null) {
			v = temp;
		}
		return v;
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

	
	private function getUnit(propName:String, dimension:Float):Float {
		var v:Float = 0;
		if (getPercent(propName) != -1) {
			v = (getPercent(propName) * dimension) / 100;
		} else if (getInt(propName) != -1) {
			v = getInt(propName);
		}
		return v;
	}
	
	private function createComponentInstance():Component {
		return new Component();
	}
	
	private function applyProperties(c:Component) {
		var root:Root = RootManager.instance.currentRoot;
		
		var text:String = get("text");
		if (text == null) {
			text = "";
		}
		c.text = text;
		
		c.visible = getBool("visible", true);
		
		c.width = getUnit("width", root.width);
		c.height = getUnit("height", root.height);
		c.x = getUnit("x", root.width);
		c.y = getUnit("y", root.height);
		
		if (get("horizontalAlign") != null) {
			switch (get("horizontalAlign")) {
				case "center":
					c.x = (root.width / 2) - (c.width / 2);
			}
		}

		if (get("verticalAlign") != null) {
			switch (get("verticalAlign")) {
				case "center":
					c.y = (root.height / 2) - (c.height / 2);
			}
		}
		
		if (c.width != 0 || c.height != 0) {
			c.autoSize = false;
		}
		if (getInt("fontSize") != -1) {
			c.style.fontSize = getInt("fontSize");
		}	
		
		if (getBool("drawBox") == true) {
			c.style.borderSize = 1;
			c.style.borderColor = 0x000000;
		}
		
		if (get("onPreloadProgress") != null || get("onPreloadComplete") != null) {
			experiment.addEventListener(PreloaderEvent.PROGRESS, onPreloaderProgress);
			experiment.addEventListener(PreloaderEvent.COMPLETE, onPreloaderComplete);
		}
	}
	
	private function onPreloaderProgress(event:PreloaderEvent) {
		Scripting.runScriptEvent("onPreloadProgress", event, _stim, false);
	}

	private function onPreloaderComplete(event:PreloaderEvent) {
		runScriptEvent("onPreloadComplete", event);
		experiment.removeEventListener(PreloaderEvent.PROGRESS, onPreloaderProgress, false);
		experiment.removeEventListener(PreloaderEvent.COMPLETE, onPreloaderComplete, false);
	}
	
	public inline function runScriptEvent(action:String, event) {
		Scripting.runScriptEvent(action, event, _stim);
	}

	
	
	private function addScriptVars(vars:Map<String, Dynamic>) {
		vars.set("this", _stim.component);
		vars.set("me", _stim.component);
	}
	
	public function build(stim:Stimulus):Component {
		_stim = stim;
		var c = createComponentInstance();
		applyProperties(c);
		return c;
	}
	
	public function buildPreloadList(props:Map<String, String>):Array<String> {
		return null;
	}
	
	//override this
	public function results():Map<String,String> {
		return null;
	}
}