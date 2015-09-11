package xpt.stimuli.all;

import haxe.ui.toolkit.core.Component;
import xpt.stimuli.Stimulus;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.RootManager;

class HaxeUIStimulus extends Stimulus {
	public function new() {
		super();
	}

	private function applyProps(c:Component):Void {
		var r:Root = RootManager.instance.currentRoot;
		c.id = get("peg");
		
		var t:String = get("text");
		if (t == null) {
			t = "";
		}
		t = StringTools.replace(t, "{b}", ""); // temp for now
		t = StringTools.replace(t, "{/b}", ""); // temp for now
		c.text = t;

		c.x = getUnit("x", r.width);
		c.y = getUnit("y", r.height);
		c.width = getUnit("width", r.width);
		c.height = getUnit("height", r.height);
		if (c.width != 0 || c.height != 0) {
			c.autoSize = false;
		}
		if (getInt("fontSize") != -1) {
			c.style.fontSize = getInt("fontSize");
		} else {
			c.style.fontSize = 20;
		}
		
		if (get("align") != null) {
			switch (get("align")) {
				case "center" | "centre":
					c.x = (r.width / 2) - (c.width / 2);
			}
		}
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
	
	public function buildComponent():Component {
		return null;
	}
	
	private function dispose(c:Component):Void {
		if (c != null) { // probably not needed, but good for sanity
			if (c.parent != null) {
				c.parent.removeChild(c);
			} else {
				c.dispose();
			}
			c = null;
		}
	}
}