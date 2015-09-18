package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.core.Component;
import xpt.stimuli.StimulusBuilder;
import xpt.ui.custom.ImageSequence;

class StimImageSequence extends StimulusBuilder {
	public function new() {
		super();
	}

	private override function createComponentInstance():Component {
		return new ImageSequence();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		var s:ImageSequence = cast c;
		
		s.resourcePattern = get("resourcePattern");
		s.min = 1;// getInt("start", 1);
		s.max = getInt("count", 1);
		s.val = 1;// getInt("start", 1);
	}
	
	public override function buildPreloadList(props:Map<String, String>):Array<String> {
		var array:Array<String> = new Array<String>();
		var resourcePattern:String = props.get("resourcePattern");
		
		var startString:String = props.get("start");
		var start:Int = 1;
		if (startString != null) {
			start = Std.parseInt(startString);
		}
		
		var countString:String = props.get("count");
		var count = 1;
		if (countString != null) {
			count = Std.parseInt(countString);
		}
		
		if (resourcePattern != null && count >= 1) {
			for (n in start...count + 1) {
				array.push(StringTools.replace(resourcePattern, "${value}", "" + n));
			}
		}
		return array;
	}
}