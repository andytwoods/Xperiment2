package xpt.stimuli.builders.nonvisual;

import haxe.ui.toolkit.controls.Button;
import haxe.ui.toolkit.core.Component;
import openfl.events.MouseEvent;
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
	var play:Button;
	var pause:Button;
	var selectButton:Button;
		
    public function new() {
        super();
    }
    
	private override function applyProperties(c:Component) {
        
		
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
		
		var controls:String = get("controls", "none");
		if (controls != "none") {
			
			var select:String = get("select", '' );
			
			super.applyProperties(c);
			setup_buttons(c, select);

		}
		else{
			c.visible = false;    
		}

	}
	
	inline function setup_buttons(c:Component, select:String) 
	{
		if (pause == null) {
			pause = new Button();
			play = new Button();
			pause.addEventListener(MouseEvent.CLICK, mouseL);
			play.addEventListener(MouseEvent.CLICK, mouseL);
		};
	
		
		pause.icon = "img/icons/pause.png";
		play.icon = "img/icons/play.png";

		
		if(select != ''){
			
			if (selectButton == null) {
				selectButton = new Button();
		
				selectButton.addEventListener(MouseEvent.CLICK, selectL);
			}						
		}

		play.iconPosition = pause.iconPosition = 'center';
		
		c.addChild(pause);
		c.addChild(play);
		pause.x = c.width * .51;
		play.percentWidth = pause.percentWidth = 49;
		
		if (selectButton != null) {
			c.addChild(selectButton);
			play.percentHeight = pause.percentHeight = selectButton.percentHeight = 49;
			selectButton.y = c.height * .51;
			selectButton.text = select;	
		}
	}
	
	private function mouseL(e:MouseEvent):Void 
	{
		if (e.currentTarget == play) {
			if(my_sound!=null) my_sound.play();
		}
		else {
			if(soundChannel!=null) this.soundChannel.stop();
		}
	}
	
	private function selectL(e:MouseEvent):Void 
	{
		runScriptEvent("action", e);
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
		super.onAddedToTrial();
    }
    
    
    
    public override function onRemovedFromTrial() {
       if (this.soundChannel != null) {
			this.soundChannel.stop();
			soundChannel = null;
			my_sound = null;
		}
    }
    
}