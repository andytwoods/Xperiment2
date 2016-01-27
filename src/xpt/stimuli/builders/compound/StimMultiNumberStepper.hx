package xpt.stimuli.builders.compound;

import haxe.ui.toolkit.containers.HBox;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import xpt.stimuli.StimulusBuilder;
import xpt.ui.custom.NumberStepper;

class StimMultiNumberStepper extends StimulusBuilder {
    private var _steppers:Array<NumberStepper>;
    
	public function new() {
		super();
	}
	
	private override function createComponentInstance():Component {
		return new HBox();
	}
	
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		
        c.removeAllChildren();
        _steppers = new Array<NumberStepper>();
        
		var fontSize:Int = getInt("fontSize");
		
		var val:String = get("val", "00");
		var n:Int = val.length;
		for (x in 0...n) {
			var stepper:NumberStepper = new NumberStepper();
			stepper.percentWidth = 100 / n;
			stepper.percentHeight = 100;
			stepper.val = Std.parseInt(val.charAt(x));
			c.addChild(stepper);
			
			if (fontSize != -1) {
				stepper.style.fontSize = fontSize;
			}
            
            stepper.addEventListener(UIEvent.CHANGE, onStepperChanged);
            _steppers.push(stepper);
		}
	}
    
    private function onStepperChanged(event:UIEvent) {
        var value = "";
        for (stepper in _steppers) {
            value += "" + stepper.val;
        }
        onStimValueChanged(Std.parseInt(value));
    }
}