package xpt.stimuli.builders.nonvisual;

import haxe.ui.toolkit.containers.Absolute;
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
	public var selectButton:Button;
	var absolute:Absolute;
	var destroyed:Bool = false;
		
    public function new() {
        super();
    }
	
	override function enabled(val:String) {
		var valBool = val != 'true';
		if (play != null) play.disabled = pause.disabled = valBool;
		if (selectButton != null) selectButton.disabled = valBool;
	}
	
	
	public override function onRemovedFromTrial() {
		destroyed = true;
		if (this.soundChannel != null) {
			this.soundChannel.stop();
			soundChannel = null;
			my_sound = null;
		}
		
		if (play != null) {
			if (play.parent!=null){
				play.parent.removeChild(play);
				play.parent.removeChild(pause);
			}
			pause.removeEventListener(MouseEvent.CLICK, mouseL);
			play.removeEventListener(MouseEvent.CLICK, mouseL);
		}
		if (selectButton != null) {
			if(selectButton.parent != null) {
				selectButton.parent.removeChild(selectButton);
			}
			selectButton.removeEventListener(MouseEvent.CLICK, selectL);
		}
		

	
	
	}
	
	
	private override function createComponentInstance():Component {
		return new Absolute();
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
		absolute = cast c;
		if (pause != null) {
			c.removeAllChildren();
			pause.removeEventListener(MouseEvent.CLICK, mouseL);
			play.removeEventListener(MouseEvent.CLICK, mouseL);
		}
		
		pause = new Button();
		play = new Button();
		
		pause.addEventListener(MouseEvent.CLICK, mouseL);
		play.addEventListener(MouseEvent.CLICK, mouseL);
		
		
		pause.icon = "img/icons/pause.png";
		play.icon = "img/icons/play.png";

		if(select != ''){
			if (selectButton != null) {
				selectButton.removeEventListener(MouseEvent.CLICK, selectL);
			}
			selectButton = new Button();		
			selectButton.addEventListener(MouseEvent.CLICK, selectL);
		}

		play.iconPosition = pause.iconPosition = 'center';

		play.percentWidth = pause.percentWidth = 49;
		
		c.addChild(pause);
		c.addChild(play);
		
		pause.x = c.width * .51;

		if (selectButton != null) {
					
			selectButton.percentWidth = 100;
			play.percentHeight = pause.percentHeight = selectButton.percentHeight = 49;
			selectButton.y = c.height*.51;
			selectButton.text = select;	
			c.addChild(selectButton);

		}
		else {
			play.percentHeight = pause.percentHeight = c.height;
		}
		
		enabled(get('enabled'));
	}
	
	private function mouseL(e:MouseEvent):Void 
	{
		if (e.currentTarget == play.sprite) {
			if(this.my_sound != null){
				soundChannel = this.my_sound.play();
			}
			
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
        if (this.my_sound != null && destroyed == false) {
			soundChannel = this.my_sound.play();
		}
		super.onAddedToTrial();
    }

    
}