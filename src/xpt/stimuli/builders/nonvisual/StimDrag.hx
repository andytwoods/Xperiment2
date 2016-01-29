package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import thx.Floats;
import xpt.events.ExperimentEvent;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import haxe.ui.toolkit.core.Component;
import xpt.tools.XTools;

class StimDrag extends StimulusBuilder {
    private var _dragStims:Array<Stimulus>;
    private var _currentDrag:Component;
    private var _dragTarget:Stimulus;
    private var _offset:Point;
    private var _origin:Point;
    
    public function new() {
        super();
        Scripting.experiment.addEventListener(ExperimentEvent.TRIAL_START, onTrailStarted);
    }
    
	private override function applyProperties(c:Component) {
        c.visible = false;
	}
    
    private function onTrailStarted(e:ExperimentEvent) {
        Scripting.experiment.removeEventListener(ExperimentEvent.TRIAL_START, onTrailStarted);
        
        RootManager.instance.currentRoot.removeEventListener(UIEvent.MOUSE_MOVE, onScreenMouseMove);
        RootManager.instance.currentRoot.removeEventListener(UIEvent.MOUSE_UP, onScreenMouseUp);
        RootManager.instance.currentRoot.addEventListener(UIEvent.MOUSE_MOVE, onScreenMouseMove);
        RootManager.instance.currentRoot.addEventListener(UIEvent.MOUSE_UP, onScreenMouseUp);
        
        if (get("target") != null) {
            _dragTarget = trial.findStimulus(get("target"));
        }

        _dragStims = getDraggableStims();
        for (stim in _dragStims) {
            stim.component.removeEventListener(UIEvent.MOUSE_DOWN, onDragStimMouseDown);
            stim.component.addEventListener(UIEvent.MOUSE_DOWN, onDragStimMouseDown);
            
            stim.component.sprite.useHandCursor = true;
            stim.component.sprite.buttonMode = true;
        }
        
    }
    
    private function onDragStimMouseDown(event:UIEvent) {
        _currentDrag = event.component;
        _offset = new Point(event.stageX - event.component.stageX, event.stageY - event.component.stageY);
        _origin = new Point(event.component.stageX, event.component.stageY);
        var lastIndex:Int = event.component.parent.numChildren - 1;
        event.component.parent.setChildIndex(event.component, lastIndex);
    }
    
    private function onScreenMouseMove(event:UIEvent) {
        if (_currentDrag != null) {
            _currentDrag.x = event.stageX - _offset.x;
            _currentDrag.y = event.stageY - _offset.y;
        }
    }
    
    private function onScreenMouseUp(event:UIEvent) {
        if (_currentDrag == null) {
            return;
        }
        
        if (_dragTarget != null) {
            if (isStimInTarget(_currentDrag, _dragTarget.component) == false) {
                Actuate.tween(_currentDrag, .5, { x: _origin.x, y: _origin.y } ).onComplete(updateValue);
            }
        }
        _currentDrag = null;
        updateValue();
    }
    
    private function updateValue() {
        var stimIds:Array<String> = [];
        if (_dragTarget != null) {
            for (stim in _dragStims) {
                if (isStimInTarget(stim.component, _dragTarget.component) == true) {
                    stimIds.push(stim.id);
					trace(get_percent_loc(stim, 'y'));
                }
            }
        }

        var newValue:String = stimIds.join(",");
        onStimValueChanged(newValue);
    }
    
    private function isStimInTarget(stim:Component, target:Component):Bool {
        var rcTarget:Rectangle = new Rectangle(target.stageX,
                                               target.stageY,
                                               target.width,
                                               target.height);
        var rcStim:Rectangle = new Rectangle(stim.stageX,
                                             stim.stageY,
                                             stim.width,
                                             stim.height);
															 
		return rcTarget.containsRect(rcStim);
    }
    
    private function getDraggableStims():Array<Stimulus> {
        var stims:Array<Stimulus> = [];
        
        if (get("stims") != null) {
            var stimIds:Array<String> = getStringArray("stims");
            if (stimIds != null) {
                for (stimId in stimIds) {
                    var stim:Stimulus = trial.findStimulus(stimId);
                    if (stim != null && stims.indexOf(stim) == -1) {
                        stims.push(stim);
                    }
                }
            }
        }
        
        if (get("groups") != null) {
            var groupIds:Array<String> = getStringArray("groups");
            if (groupIds != null) {
                for (groupId in groupIds) {
                    var groupStims:Array<Stimulus> = Stimulus.getGroup(groupId);
                    if (groupStims != null) {
                        stims = stims.concat(groupStims);
                    }
                }
            }
        }
        
        return stims;
    }
	
	
	override public function results():Map<String,String> {
		
		var propsStr:String = get("capture");
		if (propsStr.length == 0) return super.results();
		
		var props:Array<String> = propsStr.split(',');
		
		
		var data:Map<String,String> = new Map<String,String>();		
		
		for (stim in _dragStims) {
			if (isStimInTarget(stim.component, _dragTarget.component)){
				for (prop in props) {
					data.set(stim.id+"_"+prop, get_percent_loc(stim, prop));	
				}
			}
		}
		
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