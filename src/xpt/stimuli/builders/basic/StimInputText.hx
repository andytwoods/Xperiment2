package xpt.stimuli.builders.basic;

import code.Scripting;
import haxe.ui.toolkit.controls.TextInput;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.events.UIEvent;
import haxe.ui.toolkit.text.ITextDisplay;
import haxe.ui.toolkit.text.TextDisplay;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.utils.Timer;
import xpt.events.ExperimentEvent;
import xpt.stimuli.builders.basic.StimInputText.FakeCaret;
import xpt.stimuli.StimulusBuilder;

class StimInputText extends StimulusBuilder {
	#if html5
		//var fakeCaret:FakeCaret;
	#end
	
    public function new() {
        super();
		
    }
	
	override public function onRemovedFromTrial() {
		#if html5
			//fakeCaret.kill();
			//fakeCaret = null;
		#end
		super.onRemovedFromTrial();
    }
    
	@:access(haxe.ui.toolkit.controls.TextInput, haxe.ui.toolkit.text.TextDisplay, openfl.text.TextField)
    private override function createComponentInstance():Component {
        var input:TextInput = new TextInput();
        
        #if html5
			//if (this.fakeCaret != null) fakeCaret.kill();
			//this.fakeCaret = new FakeCaret(input);
			//this.fakeCaret.x = 10;
			
		
			// stupid openfl workarounds for html5 - onchange never fired
			input.sprite.addEventListener(KeyboardEvent.KEY_DOWN, function(e) {
			   //fakeCaret.onLength(input.text.length);
			   onStimValueChanged(input.text); 
			});
			input.sprite.addEventListener(KeyboardEvent.KEY_UP, function(e) {
			   onStimValueChanged(input.text); 
			});
			
			input.sprite.addEventListener(MouseEvent.CLICK, function(e) { 
				input.style.borderSize = 2;
				//if (input.text.length == 0) fakeCaret.on();
		
			} );
			input.sprite.addEventListener(FocusEvent.FOCUS_OUT, function(e) { 
				input.style.borderSize = 1;
			} );

        #else
        
			input.addEventListener(UIEvent.CHANGE, function(e:UIEvent) {
			   onStimValueChanged(input.text); 
			 
			   
			});
			
        #end
		
		var bg = getColor('background', -1);
		
		if (bg != -1) {
			var td:TextDisplay = cast(input._textDisplay, TextDisplay);
			var tf: TextField = td._tf;
			tf.background = true;
			tf.backgroundColor = bg;	
		}
		
		input.multiline = getBool('multiline', true);

		
        return input;
    }
	

    private override function applyProperties(c:Component) {
        super.applyProperties(c);
    }
	
	override public function results():Map<String,String> {
		var map:Map<String,String> = new Map<String,String>();
		if(stim.value==null)map.set(stim.id, '');
		else map.set(stim.id, stim.value);
		return map;
	}
}


class FakeCaret extends Sprite {
	var t:Timer;
	var p:Component;
	
	public function new(parent:Component) {
		super();
		this.graphics.lineStyle(.5);
		this.graphics.lineTo(0, 20);
		this.y = 15;
		
		this.t = new Timer(500, 100);
		t.addEventListener(TimerEvent.TIMER, blinkL);
		this.p = parent;
		
	}
	
	public function on() {
		t.start();
		p.sprite.addChild(this);
	}
	
	public function onLength(i:Int) {
		if (i == 0) on();
		else off();
	}
	
	public function off() {
		t.stop();
		p.sprite.removeChild(this);	
	}
	
	private function blinkL(e:TimerEvent):Void 
	{
		this.visible = !this.visible;
	}
	
	public function kill() {
		t.stop();
		t.removeEventListener(TimerEvent.TIMER, blinkL);
		p = null;
	}
}