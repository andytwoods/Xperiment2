package xpt.stimuli.all;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.util.CallStackHelper;
import xpt.experiment.Experiment;
import xpt.stimuli.Stimulus;
import haxe.ui.toolkit.core.Component;

class Stim_Button extends HaxeUIStimulus {
	private var _button:Button;
	
	private var _action:String;
	
	public function new() {
		super();
	}

	public override function applyProps(c:Component):Void {
		super.applyProps(c);
		_action = get("action");
		if (_action == null) { // TODO: defaults to next trial
			_action = "Experiment.nextTrial();";
		}
	}
	
	public override function buildComponent():Component {
		dispose(_button);
		_button = new Button();
		applyProps(_button);
		_button.addEventListener(UIEvent.CLICK, _onClick);
		return _button;
	}
	
	private function _onClick(event:UIEvent):Void {
		if (_action != null) {
			try {
				var parser = new hscript.Parser();
				var expr = parser.parseString(_action);
				Experiment.scriptEngine.expr(expr);
			} catch (e:Dynamic) {
				trace("ERROR! " + e);
				CallStackHelper.traceCallStack();
			}
		}
	}
}