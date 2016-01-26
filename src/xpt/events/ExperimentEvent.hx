package xpt.events;

import openfl.events.Event;
import xpt.trial.Trial;

class ExperimentEvent extends Event {
    public static inline var TRIAL_START:String = "TrailStart";
    public static inline var TRAIL_END:String = "TrailEnd";
    
    public var trail(default, default):Trial;
    
    public function new(type:String) {
        super(type);
    }
    
}