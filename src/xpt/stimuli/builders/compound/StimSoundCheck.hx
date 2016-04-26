package xpt.stimuli.builders.compound;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.Component;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TimerEvent;
import openfl.media.SoundChannel;
import openfl.utils.Timer;
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
	var sounds:Map<String, SoundChannelBundle>;
	var pword:Password;
	var startWhenLoaded:Bool = false;
	var pause:Button;
	var play:Button;
	
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
			sounds = new Map<String, SoundChannelBundle>();
			for (resource in resources.split(",")) {

				var load_resource = PathTools.fixPath(resource);
				var sound = Preloader.instance.getSound(load_resource);
			   
			    if(sound!=null) setSound(resource.split(".")[0], sound);	
			    else {
					Preloader.instance.callbackWhenLoaded(load_resource, function() {
						sound = Preloader.instance.getSound(load_resource);
						setSound(resource.split(".")[0], sound);	
					});
				}
			}
		}
       
		if(buttons == null){
			buttons = new Map<String, Button>();
			
			var button:Button;
			
			var xArr:Array<Float> = [35, 50, 65, 35, 50, 65, 35, 50, 65, 50]; 
			var yArr:Array<Float> = [45, 45, 45, 60, 60, 60, 75, 75, 75, 90];
		
			
			var dimension:Float = c.width * .13 * .5;
			
			var text:String;
			for (i in 0...10) {
				
				button = new Button();
				button.percentWidth = button.percentHeight = 13;
				
				button.x = xArr[i] * c.width *.01 - dimension;
				button.y = yArr[i] * c.height *.01 - dimension;
				
				text = Std.string(i);
				button.text = text;
				button.id = text;
				button.sprite.name = text;
				buttons.set(text, button);
				c.addChild(button);
			}
			
			pause = new Button();
			pause.icon = "img/icons/pause.png";
			pause.x = 35 * c.width * .01 - dimension;
			pause.y = 90 * c.height * .01 - dimension;
			pause.percentWidth = pause.percentHeight = 13;
			pause.iconPosition = 'center';
			c.addChild(pause);
			
			play = new Button();
			play.icon = "img/icons/play.png";
			play.x = 65 * c.width * .01 - dimension;
			play.y = 90 * c.height * .01 - dimension;
			play.percentWidth = play.percentHeight = 13;
			play.iconPosition = 'center';
			c.addChild(play);
			
			var text:Text = new Text();
			text.percentWidth = 100;
			text.percentHeight = 20;
			text.style.fontSize = 20;
			text.multiline = true;
			text.wrapLines = true;
			text.text = get('text');
			text.x = 0;
			c.addChild(text);
		}
	}
	

	

	inline function setSound(nam:String, sound:Sound) 
	{
		sounds.set(nam, new SoundChannelBundle(sound));
		if (startWhenLoaded) {
			if ( checkLoaded() ) start();
		}
	}
    
	
	private function start() {
		pword = new Password(buttons, sounds, success, pause, play);	
	}
	
	
		//*********************************************************************************
	// CALLBACKS
	//*********************************************************************************
    public override function onAddedToTrial() {
		if ( checkLoaded() ) start();
		else startWhenLoaded = true;
    }
	
	private inline function checkLoaded():Bool {
		return XTools.iteratorToArray(sounds.keys()).length == 10;
	}
    
	private function success() {
		pword.kill();
		pword = null;
		experiment.nextTrial();
	}
    
    
    public override function onRemovedFromTrial() {
      if(pword !=null) pword.kill();
    }
    
}

class Password {
	var sounds:Map<String, SoundChannelBundle>;
	var buttons:Map<String, Button>;
	var passcode:Array<String> = [];
	var current:Int = 0;
	var playing:SoundChannelBundle;
	var clickStream:String = "";
	var passcodeStr:String;
	var callback:Void->Void;
	var pause:Button;
	var start:Button;
	var paused:Bool = false;
	var keys:Array<String> = '1,2,3,4,5,6,7,8,9,0'.split(",");
	
	public function new(buttons:Map<String,Button>, sounds:Map<String,SoundChannelBundle>, callback:Void ->Void, pause:Button, start:Button) {
		this.callback = callback;
		this.buttons = buttons;
		this.sounds = sounds;
		this.pause = pause;
		this.start = start;
		for (b in buttons) {
			b.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		var list:Array<String> = '1,2,3,4,5,6,7,8,9,0'.split(",");
		for (i in 0...3) {
			passcode.push(XRandom.randomlySelect(list));
		}
		passcodeStr = passcode.join("");
		playNext();
		
		
		pause.addEventListener(MouseEvent.CLICK, pauseL);
		start.addEventListener(MouseEvent.CLICK, startL);
		
		start.sprite.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardL);
	}
	
	
	
	private function keyboardL(e:KeyboardEvent):Void 
	{
		var char:String = String.fromCharCode(e.keyCode);

		if (keys.indexOf(char) != -1) {
				var button:Button = buttons[char];
				button.state = Button.STATE_DOWN;
				XTools.delay(100, function() { 
					if (button !=null ) button.state = Button.STATE_NORMAL;
				} );
				button.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
	}
	
	
	
	private function startL(e:MouseEvent):Void 
	{
		var origPause:Bool = paused;
		paused = false;
		if (origPause == true) {
			playNext();
		}
		
	}
	
	private function pauseL(e:MouseEvent):Void 
	{
		paused = true;
		

	}
	
	function playNext() 
	{
		if (paused == false) {
				if(sounds!=null){
				playing = sounds.get(passcode[current]);
				playing.play(soundchannelbundle_callback);
				current++;
			}
		}
	}
	
	private function soundchannelbundle_callback():Void 
	{
		if (current >= passcode.length) {
			current = 0;
			XTools.delay(1000, playNext);
		}
		else playNext();
	}
	

	
	private function onClick(e:MouseEvent):Void 
	{
		clickStream_add(e.currentTarget.name);
	}
	
	private function clickStream_add(str:String):Void {
		clickStream += str;
		if(clickStream.length > passcode.length) {
			clickStream = clickStream.substr(clickStream.length - passcode.length, passcode.length);
		}
		if (clickStream == passcodeStr) if(callback!=null) callback();
	}
	
	public function kill() {
		start.sprite.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardL);
		pause.removeEventListener(MouseEvent.CLICK, pauseL);
		start.removeEventListener(MouseEvent.CLICK, startL);
		pause = start = null;
		
		for (s in sounds) {
			s.kill();
		}
		sounds = null;
			
		for (b in buttons) {
			b.removeEventListener(MouseEvent.CLICK, onClick);
		}
		buttons = null;
	}
}

class SoundChannelBundle {
	
	private var callback:Void->Void;
	private var t:Timer;
	public var sound:Sound;
	
	public function new(sound:Sound) {
		this.sound = sound;
		t = new Timer(1000, 0);
		listeners(true);
	}
	
	public function kill() {
		listeners(false);
	}
	
	public function play(callback:Void->Void) {
		this.callback = callback;
		sound.play();
		t.start();

		
	}
	
	function listeners(on:Bool) 
	{
		if(on) t.addEventListener(TimerEvent.TIMER, finishedL);
		else t.removeEventListener(Event.SOUND_COMPLETE, finishedL);
		
	}
	
	private function finishedL(e:Event):Void 
	{
		t.stop();
		if (callback != null) {
			callback();
		}
	}

	

	
}