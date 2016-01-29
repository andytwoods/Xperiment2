package wrappers;
import xpt.ExptWideSpecs;

class SystemWrapper {
    public function new() 
    {
        
    }
    
    public var invalidTrailBehaviour(get, null):String;
    public function get_invalidTrailBehaviour():String {
        var value:String = "hide";
        if (ExptWideSpecs.IS("invalidTrailBehaviour", false) != null) {
            value = ExptWideSpecs.IS("invalidTrailBehaviour", false);
        }
        return value;
    }
    
}