package xpt.stimuli.builders.nonvisual;

import code.Scripting;
import haxe.ui.toolkit.core.RootManager;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import xpt.events.ExperimentEvent;
import xpt.stimuli.Stimulus;
import xpt.stimuli.StimulusBuilder;
import haxe.ui.toolkit.core.Component;

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
        if (_dragTarget != null && _currentDrag != null) {
            var rcTarget:Rectangle = new Rectangle(_dragTarget.component.stageX,
                                                   _dragTarget.component.stageY,
                                                   _dragTarget.component.width,
                                                   _dragTarget.component.height);
            var rcDrag:Rectangle = new Rectangle(_currentDrag.stageX,
                                                 _currentDrag.stageY,
                                                 _currentDrag.width,
                                                 _currentDrag.height);
            if (rcTarget.containsRect(rcDrag) == false) {
                Actuate.tween(_currentDrag, .5, { x: _origin.x, y: _origin.y } );
            }
        }
        _currentDrag = null;
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
        
        return stims;
    }
}