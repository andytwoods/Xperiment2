package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import flash.display.Sprite;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import thx.Floats;
import xpt.events.ExperimentEvent;
import xpt.stimuli.builders.StimulusBuilder_nonvisual;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import haxe.ui.toolkit.core.Component;
import xpt.stimuli.tools.NonVisual_Tools;
import xpt.tools.XTools;

class StimDragXY extends StimulusBuilder_nonvisual {
    private var _dragStims:Array<Stimulus>;
    private var _currentDrag:Component;
    private var _dragTarget:Stimulus;
    private var _origin:Point;
    
    public function new() {
        super();
        Scripting.experiment.addEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;
	}
    
    private function onTrialStarted(e:ExperimentEvent) {
        Scripting.experiment.removeEventListener(ExperimentEvent.TRIAL_START, onTrialStarted);
        
        //RootManager.instance.currentRoot.removeEventListener(UIEvent.MOUSE_MOVE, onScreenMouseMove);
        RootManager.instance.currentRoot.removeEventListener(UIEvent.MOUSE_UP, onScreenMouseUp);
        //RootManager.instance.currentRoot.addEventListener(UIEvent.MOUSE_MOVE, onScreenMouseMove);
        RootManager.instance.currentRoot.addEventListener(UIEvent.MOUSE_UP, onScreenMouseUp);
        
        if (get("target") != null) {
            _dragTarget = trial.findStimulus(get("target"));
        }

        _dragStims = NonVisual_Tools.getStims(trial, this);
		
        for (stim in _dragStims) {
            stim.component.removeEventListener(UIEvent.MOUSE_DOWN, onDragStimMouseDown);
            stim.component.addEventListener(UIEvent.MOUSE_DOWN, onDragStimMouseDown);
          
            stim.component.sprite.useHandCursor = true;
            stim.component.sprite.buttonMode = true;
        }
        
    }
    
    private function onDragStimMouseDown(event:UIEvent) {
        _currentDrag = event.component;
        _origin = new Point(_currentDrag.x,_currentDrag.y);
        var lastIndex:Int = event.component.parent.numChildren - 1;
        event.component.parent.setChildIndex(event.component, lastIndex);
		_currentDrag.sprite.startDrag();
    }
    

    
    private function onScreenMouseUp(event:UIEvent) {
        if (_currentDrag == null) {
            return;
        }
        _currentDrag.sprite.stopDrag();
		
        if (_dragTarget != null) {
            if (isStimInTarget(_currentDrag.sprite, _dragTarget.component.sprite) == false) {
                Actuate.tween(_currentDrag, .5, { x: _origin.x, y: _origin.y } ).onComplete(updateValue);
            }
			else {
				_currentDrag.x = _currentDrag.sprite.x;
				_currentDrag.y = _currentDrag.sprite.y;
			}
        }
        _currentDrag = null;
        updateValue();
    }
    
    private function updateValue() {
        var stimIds:Array<String> = [];
        if (_dragTarget != null) {
            for (stim in _dragStims) {
                if (isStimInTarget(stim.component.sprite, _dragTarget.component.sprite) == true) {
                    stimIds.push(stim.id);
                }
            }
        }

        var newValue:String = stimIds.join(",");
        onStimValueChanged(newValue);
    }
    
    private function isStimInTarget(stim:Sprite, target:Sprite):Bool {
		if (stim.x < target.x || stim.x + stim.width > target.x + target.width) return false;
		if (stim.y < target.y || stim.y + stim.height > target.y + target.height) return false;		
        return true;
    }
    
 
	
	override public function results():Map<String,String> {
		
		var propsStr:String = get("capture");
		if (propsStr.length == 0) return super.results();
		
		var props:Array<String> = propsStr.split(',');
		
		
		var data:Map<String,String> = new Map<String,String>();		
		
		var saveId:String = get('saveId');
		
		function getSaveIdVal(stim:Stimulus):String {
			if (saveId == 'id') return stim.id;
			if (stim.get(saveId) == null) throw 'In Drag, unkown saveId val in your dragging stimuli ('+saveId+')';
			return stim.get(saveId);
		}
		
		for (stim in _dragStims) {
			if (isStimInTarget(stim.component.sprite, _dragTarget.component.sprite)){
				for (prop in props) {
					data.set(getSaveIdVal(stim)+"_"+prop, get_percent_loc(stim, prop));	
				}
			}
		}
		//trace(data);
		return data;
	}
	
	private function get_percent_loc(s:Stimulus, p:String):String {
		var val:Float = -1;
		switch(p.toLowerCase()) {
			case 'x':
				val =  s.component.stageX;
				val = val - _dragTarget.component.stageX + s.component.width *.5;
				val = val / _dragTarget.component.width * 100;
					
			case 'y':
				val = s.component.stageY;
				val = val - _dragTarget.component.stageY + s.component.height *.5;
				val = val / _dragTarget.component.height * 100;
				val = 100 - val;
		}
		return Std.string(Floats.roundTo(val,2));
	}
}