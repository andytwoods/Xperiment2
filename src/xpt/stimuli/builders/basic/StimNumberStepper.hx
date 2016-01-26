package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import xpt.stimuli.StimulusBuilder;
import xpt.ui.custom.NumberStepper;

class StimNumberStepper extends StimulusBuilder {
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
        var stepper:NumberStepper = new NumberStepper();
        stepper.addEventListener(UIEvent.CHANGE, function(e:UIEvent) {
           onStimValueChanged(stepper.val); 
        });
		return stepper;
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
	}
}