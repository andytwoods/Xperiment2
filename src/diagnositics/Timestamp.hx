package diagnositics;

#if html5
import js.Browser;
import js.html.Performance;
#end

class Timestamp {
    public static function get():Float {
        var t:Float = -1;
        #if html5
            var perf:Performance = Browser.window.performance;
            if (perf != null) {
                t = perf.now();
            } else { // if brower doesnt support it
                t = getSystemTimestamp();
            }
        #else
            t = getSystemTimestamp();
        #end
        return t;
    }
    
    private static function getSystemTimestamp():Float {
        var t:Float = -1;
        var dt:Date = Date.now();
        t = dt.getTime();
        return t;
    }
    
}