package xpt.stimuli.builders.compound;
import haxe.ui.toolkit.core.Component;
import openfl.events.Event;
import openfl.media.SoundChannel;
import xpt.experiment.Preloader;
import xpt.debug.DebugManager;
import haxe.ui.toolkit.containers.Absolute;
import xpt.stimuli.builders.compound.StimSoundCheck.Password;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.tools.PathTools;
import haxe.ui.toolkit.controls.Button;
import openfl.media.Sound;
import haxe.ui.toolkit.core.base.HorizontalAlign;
import openfl.events.MouseEvent;
import xpt.tools.XRandom;
import xpt.tools.XTools;

class StimSoundCheck extends StimulusBuilder {
	

	var buttons:Map<String, Button>;
	var sounds:Map<String, Sound>;
	var pword:Password;
	
    public function new() {
        super();
    }

	
	private override function createComponentInstance():Component {
		return new Absolute();
	}
    
	private override function applyProperties(c:Component) {
		super.applyProperties(c);
		
		if (sounds == null) {
			var resources = get("resource", null);
			if (resources == null) throw 'devel error. Assets not defined properly in system.xml';
			sounds = new Map<String, Sound>();
			for (resource in resources.split(",")) {

				var load_resource = PathTools.fixPath(resource);
				var sound = Preloader.instance.preloadedSound.get(load_resource);
			   
			    if(sound!=null) setSound(resource.split(".")[0], sound);	
			    else {
					Preloader.instance.callbackWhenLoaded(load_resource, function() {
						sound = Preloader.instance.preloadedSound.get(load_resource);
						setSound(resource.split(".")[0], sound);	
					});
				}
			}
		}
       
		if(buttons == null){
			buttons = new Map<String, Button>();
			
			var button:Button;
			
			var xArr:Array<Float> = [25, 50, 75, 25, 50, 75, 25, 50, 75, 50]; 
			var yArr:Array<Float> = [25, 25, 25, 50, 50, 50, 75, 75, 75, 100];
		
			
			var dimension:Float = c.width * .20 * .5;
			
			var text:String;
			for (i in 0...9) {
				
				button = new Button();
				button.percentWidth = button.percentHeight = 20;
				
				button.x = xArr[i] * c.width *.01 - dimension;
				button.y = yArr[i] * c.height *.01 - dimension;
				
				text = Std.string(i);
				button.text = text;
				button.id = text;
				button.sprite.name = text;
				buttons.set(text, button);
				c.addChild(button);
			}
		}
	}
	

	

	inline function setSound(nam:String, sound:Sound) 
	{
		sounds.set(nam, sound);
	}
    
	
		//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() {
		pword = new Password(buttons, sounds);
    }
    
    
    
    public override function onRemovedFromTrial() {
      if(pword !=null) pword.kill();
    }
    
}

class Password {
	var sounds:Map<String, Sound>;
	var buttons:Map<String, Button>;
	var passcode:Array<String> = [];
	var current:Int = 0;
	var playing:Sound;
	var channel:SoundChannel;

	public function new(buttons:Map<String,Button>, sounds:Map<String,Sound>) {
		this.buttons = buttons;
		this.sounds = sounds;
		for (b in buttons) {
			b.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		var list:Array<String> = '1,2,3,4,5,6,7,8,9,0'.split(",");
		for (i in 0...3) {
			passcode.push(XRandom.randomlySelect(list));
		}
		
		playNext();
		
	}
	
	function playNext() 
	{
		trace(11);
		if (current > passcode.length) current = 0;
		clean();
		playing = sounds.get(passcode[current]);
		channel = playing.play(0);
		trace(channel.position);
		channel.addEventListener(Event.SOUND_COMPLETE, soundFinishedL);
		current++;
	}
	
	private function soundFinishedL(e:Event):Void 
	{
		if (current < passcode.length) playNext();
	}
	
	function clean() {
		if (playing == null) return;
		channel.removeEventListener(Event.SOUND_COMPLETE, soundFinishedL);
		channel.stop();
		playing = null;
	}
	
	private function onClick(e:MouseEvent):Void 
	{
		trace(e.currentTarget.name);
	}
	
	public function kill() {
		clean();
		for (b in buttons) {
			b.removeEventListener(MouseEvent.CLICK, onClick);
		}
	}
}