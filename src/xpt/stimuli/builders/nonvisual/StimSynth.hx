package xpt.stimuli.builders.nonvisual;

import haxe.ui.toolkit.core.Component;
import openfl.media.SoundChannel;
import thx.Floats;
import xpt.experiment.Preloader;
import xpt.debug.DebugManager;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.PathTools;
import openfl.media.Sound;

class StimSynth extends StimulusBuilder {

	var synth:Dynamic;
	
    public function new() {
        super();
		
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;    

	}
	

	
	public function play(val:Float) {
		if (val >= 0 && val <= 100) {
			#if html5
				untyped synth.triggerAttackRelease(440*val*.1, "2n");		
		#end
		}
	
	}
    
	
	//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() {
		stim.set('play', play);
		#if html5
				untyped __js__('var s = new Tone.SimpleSynth().toMaster();');
				synth = untyped __js__('s');
				untyped synth.triggerAttackRelease("C4", "8n");		
		#end
		
		super.onAddedToTrial();
    }
    
    
    
    public override function onRemovedFromTrial() {
      
    }
    
}


