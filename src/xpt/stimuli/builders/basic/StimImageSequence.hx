package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;

class StimImageSequence extends StimulusBuilder {
	public function new() {
		super();
	}

	private override function createComponentInstance():Component {
		return new Image();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
	}
	
	public override function buildPreloadList(props:Map<String, String>):Array<String> {
		var array:Array<String> = new Array<String>();
		var resourcePattern:String = props.get("resourcePattern");
		var countString:String = props.get("count");
		var count = 1;
		if (countString != null) {
			count = Std.parseInt(countString);
		}
		
		if (resourcePattern != null && count >= 1) {
			for (n in 1...count + 1) {
				array.push(StringTools.replace(resourcePattern, "${n}", "" + n));
			}
		}
		return array;
	}
}