package xpt.stimuli.builders.basic;

import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import xpt.stimuli.StimulusBuilder;

class StimInputText extends StimulusBuilder {
    public function new() {
        super();
    }
    
    private override function createComponentInstance():Component {
        var input:TextInput = new TextInput();
        input.addEventListener(UIEvent.CHANGE, function(e:UIEvent) {
			trace(111, input.text, 22);
           onStimValueChanged(input.text); 
        });
        return input;
    }
    
    private override function applyProperties(c:Component) {
        super.applyProperties(c);
    }
}