package xpt.stimuli;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;

class StimulusBuilder {
	private var _stim:Stimulus;
	
	public function new() {
		
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
		
		c.x = getUnit("x", root.width);
		c.y = getUnit("y", root.height);
		c.width = getUnit("width", root.width);
		c.height = getUnit("height", root.height);
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
	}
	
	public function build(stim:Stimulus):Component {
		_stim = stim;
		var c = createComponentInstance();
		applyProperties(c);
		return c;
	}
}