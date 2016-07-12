package xpt.stimuli;
import thx.Arrays;
import thx.Ints;
import xpt.stimuli.Stimulus;
import xpt.tools.XRandom;
import xpt.tools.XTools;

class StimHelper {
    public static function shuffle(list:Array<Stimulus>, fixedProps:Array<String> = null) {
		
        var fixedValues:Map<String, Array<String>> = null;
        if (fixedProps != null) {
            fixedValues = new Map<String, Array<String>>();
            for (propName in fixedProps) {
                var valueList:Array<String> = new Array<String>();
                for (s in list) {
                    var propValue:String = s.get(propName);
                    valueList.push(propValue);
                }
                fixedValues.set(propName, valueList);
                
            }
        }
       
		
        XRandom.shuffle(list);
	
		
        if (fixedValues != null) {
            for (key in fixedValues.keys()) {
                var valueList:Array<String> = fixedValues.get(key);
                var n:Int = 0;
                for (s in list) {
                    s.set(key, valueList[n]);
                    n++;
                    s.updateComponent();
                }
            }
        }
		

    }
    
    public static function shuffleArrangement(list:Array<Stimulus>, fixedProps:Array<String> = null) {
        if (fixedProps == null) {
            fixedProps = [];
        }
        //fixedProps = fixedProps.concat(['x', 'y', 'horizontalAlign', 'verticalAlign', 'marginLeft', 'marginTop', 'marginRight', 'marginBottom']);
        shuffle(list, fixedProps);
    }
	
	static public function arrange(stims:Array<Stimulus>) 
	{
		for (prop in ['x','y']) {
			arrange_prop(prop, stims);
		}
	}
	
	static private function arrange_prop(prop:String, stims:Array<Stimulus>) 
	{
		var propsArr:Array<Int> = new Array<Int>();
		for (stim in stims) {
			propsArr.push(Reflect.getProperty(stim.component, prop));
		}
		var max:Int = ArrayInts.max(propsArr);
		var min:Int = ArrayInts.min(propsArr);
			
		var overall_gap:Int = max - min;
		
		var gap_per_stim:Float = overall_gap / (stims.length -1);
		
		var positions:Array<Int> = new Array<Int>();
		
		for (i in 0...stims.length) {
			positions.push(Std.int(i * gap_per_stim) + min);
		}

		XRandom.shuffle(positions);
		
		for (stim in stims) {
			Reflect.setProperty(stim.component, prop,  positions.shift());
		}
	}
}