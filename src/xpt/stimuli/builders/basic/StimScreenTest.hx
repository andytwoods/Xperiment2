package xpt.stimuli.builders.basic;

import code.Scripting;
import haxe.ui.toolkit.controls.Text;
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
import thx.Floats;
import xpt.events.ExperimentEvent;
import xpt.screenManager.ScreenManager;
import xpt.stimuli.builders.basic.StimInputText.FakeCaret;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.XTools;

class StimScreenTest extends StimText {
	#if html5
		//var fakeCaret:FakeCaret;
	#end
	
    public function new() {
        super();
		
    }
	
	var my_txt:String;
	var my_text:Text;
	var scaling:Float;
	
	override public function onRemovedFromTrial() {
		listen(false);
		super.onRemovedFromTrial();
    }
    
	@:access(haxe.ui.toolkit.controls.TextInput, haxe.ui.toolkit.text.TextDisplay, openfl.text.TextField)
    private override function createComponentInstance():Component {
		if (my_text != null) return my_text;
		
		my_text = new Text();
      
		my_txt = get('text');
		#if html5
			listen(true);
			ScreenManager.instance.refresh();
			callback(1, 1);
		#else
			scaling = stim.value = 1;
			onStimValueChanged(scaling);
			stim.text(my_txt + '100%');
		#end
		
        return my_text;
    }
	
	private function listen(yes:Bool) {
	
		if (yes) {
			ScreenManager.instance.callbacks.push(callback);
		}
		else {
			ScreenManager.instance.callbacks.remove(callback);
		}
		
	}
	
	private function callback(_bla1:Float, _bla2:Float) {
		scaling = stim.value = Floats.roundTo(ScreenManager.instance.stageScale, 2);
		onStimValueChanged(scaling); 
		stim.text(my_txt + Std.string(Floats.roundTo(100 * scaling, 2)) + '%');
		
	}
	

    private override function applyProperties(c:Component) {
        super.applyProperties(c);
    }

}
