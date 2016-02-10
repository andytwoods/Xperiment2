package xpt.stimuli.builders.basic;

import code.Scripting;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.text.ITextDisplay;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.text.TextField;
import xpt.events.ExperimentEvent;
import xpt.stimuli.StimulusBuilder;

class StimInputText extends StimulusBuilder {
    public function new() {
        super();
    }
    
    private override function createComponentInstance():Component {
        var input:TextInput = new TextInput();
        
        #if html5
        // supid openfl workarounds for html5 - onchange never fired
        input.sprite.addEventListener(KeyboardEvent.KEY_DOWN, function(e) {
           onStimValueChanged(input.text); 
        });
        input.sprite.addEventListener(KeyboardEvent.KEY_UP, function(e) {
           onStimValueChanged(input.text); 
        });
        
        // this stupid one is so the caret appears when the text is 0 length
        var textDisplay:ITextDisplay = Reflect.field(input, "_textDisplay");
        var textField:TextField = cast textDisplay.display;
        textField.border = true;
        textField.borderColor = 0xFFFFFF;
        
        #else
        
        input.addEventListener(UIEvent.CHANGE, function(e:UIEvent) {
           onStimValueChanged(input.text); 
        });
        
        #end

        return input;
    }
    
    private override function applyProperties(c:Component) {
        super.applyProperties(c);
    }
	
	override public function results():Map<String,String> {
		var map:Map<String,String> = new Map<String,String>();
		map.set('', _stim.value);
		return map;
	}
}