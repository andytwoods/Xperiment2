package xpt.stimuli.builders.nonvisual;

import haxe.ui.toolkit.core.Component;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import xpt.debug.DebugManager;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.trial.Trial;

class StimResults extends StimulusBuilder {
    
    public function new() {
        super();
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;    
	}
    
	override public function results():Map<String,String> {
		var res:Map<String,String> = new Map<String,String>();
		
		var stimuli:Array<Stimulus> = trial.stimuli;
		
		
		//only can access attributes that were set in the xml script.
		for (prop in _stim.props.keys()) {
			
			res.set(prop, retrieveInfo(_stim.props.get(prop), stimuli));
		}
		return res;
	}
	
	function retrieveInfo(getWhat:String, stimuli:Array<Stimulus>):String
	{
		var arr:Array<String> = getWhat.split(".");
		if (arr.length != 2) throw 'must be of format stimId:prop';
		var stimId:String = arr[0];
		var prop:String = arr[1];
		
		for (stim in stimuli) {
			if (stim.id == stimId) {
				return Std.string(stim.get(prop));				
			}
		}
		
		
		return 'not found: '+getWhat;
		
	}
	
	
    
}