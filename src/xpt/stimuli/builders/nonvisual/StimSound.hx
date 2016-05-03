package xpt.stimuli.builders.nonvisual;

import haxe.ui.toolkit.core.Component;
import openfl.media.SoundChannel;
import xpt.experiment.Preloader;
import xpt.debug.DebugManager;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.PathTools;
import openfl.media.Sound;

class StimSound extends StimulusBuilder {
	
	private var my_sound:Sound;
	var soundChannel:SoundChannel;

    public function new() {
        super();
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;    
		

		var resource:String = get("resource");

		if (resource != null) {
           resource = PathTools.fixPath(resource);
		   
		   var sound = Preloader.instance.getSound(resource);
		   
           if(sound!=null) setSound(sound);	
		   else {
				Preloader.instance.callbackWhenLoaded(resource, function() {
					update();
				});
			}
		}
	}
	
	function setSound(sound:Sound) 
	{
		this.my_sound = sound;
	}
    
	
		//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() {
        if (this.my_sound != null) {
			soundChannel = this.my_sound.play();
		}
    }
    
    
    
    public override function onRemovedFromTrial() {
       if (this.soundChannel != null) {
			this.soundChannel.stop();
			soundChannel = null;
			my_sound = null;
		}
    }
    
}