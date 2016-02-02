package wrappers;
import xpt.ExptWideSpecs;

class SystemWrapper {
    public function new() 
    {
        
    }
    
    public var invalidTrialBehaviour(get, null):String;
    public function get_invalidTrialBehaviour():String {
        var value:String = "hide";
        if (ExptWideSpecs.IS("invalidTrialBehaviour", false) != null) {
            value = ExptWideSpecs.IS("invalidTrialBehaviour", false);
        }
        return value;
    }
    
}