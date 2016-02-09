package xpt.stimuli.tools;
import flash.display.Stage;
import flash.events.KeyboardEvent;
import openfl.Lib;
import openfl.ui.Keyboard;
import xpt.stimuli.Stimulus;
import xpt.stimuli.tools.KeyPress.StimInfo;

/**
 * ...
 * @author 
 */
class KeyPress
{
	private static var _instance:KeyPress;
	public static var instance(get, never):KeyPress;
	private var list:Array<StimInfo>;
	private var keys:Map<Int,   Array<StimInfo> >;
	private var stage:Stage;
	
	public function new() { 
		list = new Array<StimInfo>();
		keys = new Map<Int,   Array<StimInfo> >();
		stage = Lib.current.stage;
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardL);
	}
	
	private function keyboardL(e:KeyboardEvent):Void 
	{
		if (keys.exists(e.keyCode)) {
			for (stimInfo in keys.get(e.keyCode)) {
				stimInfo.callBack(e.keyCode);
			}
		}
	}
	

	
	public static function get_instance():KeyPress 
	{
		if (_instance == null) {
			_instance = new KeyPress();
			
		}
		return _instance;
	}
	
	public function listen(stim:StimulusBuilder, keyStr:String, callBack:Int->Void) {
		var stimInfo:StimInfo = new StimInfo();
		stimInfo.stim = stim;
		stimInfo.key = getKeyCode(keyStr);
		stimInfo.callBack = callBack;
		
		list.push(stimInfo);
		if (keys.exists(stimInfo.key) == false) {
			keys.set(stimInfo.key, new Array<StimInfo>());
		}
		keys.get(stimInfo.key).push(stimInfo);
	}

	public function forget(stim:StimulusBuilder) 
	{
		for (stimInfo in list) {
			if (stimInfo.stim == stim) {
				if (keys.exists(stimInfo.key) == false) throw 'devel err';
				keys.get(stimInfo.key).remove(stimInfo);
				list.remove(stimInfo);
			}
		}
	}
	
	
	private function getKeyCode(keyStr:String):Int {
		if(keyStr.charAt(0).toUpperCase()=="C"){
				return Std.parseInt(keyStr.substr(1,keyStr.length-1));
			}
		else if(['left','right','up','down'].indexOf(keyStr.toLowerCase())!=-1){
			switch(keyStr.toLowerCase()){
				case 'left':
					return Keyboard.LEFT;
				case 'right':
					return Keyboard.RIGHT;
				case 'up':
					return Keyboard.UP;
				case 'down':
					return Keyboard.DOWN;
			}
		}

		return keyStr.toUpperCase().charCodeAt(0);
	}
	
}

class StimInfo {
	
	public function new(){}
	
	public var callBack:Int->Void;
	public var stim:StimulusBuilder;
	public var key:Int;
	
}