package xpt.stimuli;

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
        
        Random.shuffle(list);
        
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
        fixedProps = fixedProps.concat(['x', 'y', 'horizontalAlign', 'verticalAlign', 'marginLeft', 'marginTop', 'marginRight', 'marginBottom']);
        shuffle(list, fixedProps);
    }
}