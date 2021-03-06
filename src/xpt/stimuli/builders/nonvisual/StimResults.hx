package xpt.stimuli.builders.nonvisual;

import haxe.ui.toolkit.core.Component;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import xpt.debug.DebugManager;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import xpt.trial.Trial;

class StimResults extends StimulusBuilder_nonvisual {
	
	public static var ignoreParamsList:Array<String> = ['multiId','copyOverId'];
    
    public function new() {
        super();
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;    
	}
    
	override public function results():Map<String,String> {
		var res:Map<String,String> = new Map<String,String>();
		
		var stimuli:Array<Stimulus> = trial.stimuli;
		

		for (prop in stim.props.keys()) {
			if(ignoreParamsList.indexOf(prop)==-1){
				//res.set(prop, retrieveInfo(_stim.props.get(prop), stimuli));
				res.set(prop, stim.props.get(prop));
			}
		}
		return res;
	}
	
/*	function retrieveInfo(getWhat:String, stimuli:Array<Stimulus>):String
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
	*/
	
    
}