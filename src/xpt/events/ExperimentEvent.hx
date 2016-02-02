package xpt.events;

import openfl.events.Event;
import xpt.trial.Trial;

class ExperimentEvent extends Event {
    public static inline var TRIAL_START:String = "TrialStart";
    public static inline var TRIAL_END:String = "TrialEnd";
    public static inline var TRIAL_VALID:String = "TrialValid";
    public static inline var TRIAL_INVALID:String = "TrialInvalid";
    
    public var trial(default, default):Trial;
    
    public function new(type:String) {
        super(type);
    }
    
}