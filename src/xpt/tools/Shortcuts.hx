package xpt.tools;

/**
 * ...
 * @author Andy Woods
 */
class Shortcuts
{
	
	public var shortcuts = new Map<String, Xml-> Shortcuts_Command -> Void>();
	
    public static var instance(get, null):Shortcuts;
    
	public static function get_instance():Shortcuts {
        if (instance == null) {
            instance = new Shortcuts();
        }
        return instance;
    }
	
	public function new() 
	{
		shortcuts.set('shuffle', shortcut_shuffle);
	}
	
	
	public function experiment_wide(xml:Xml) {
		var uppercase_keys:Array<String> = XTools.iteratorToArray(shortcuts.keys());
		crunch(xml, uppercase_keys);
	}
	
	private inline function crunch(xml:Xml, list:Array<String>) {
		var found:Map<String, Array<Xml>> = XML_tools.find_val(xml, list);
		
		for (key in found.keys()) {
			iterate_over_finds(found.get(key), key);	
		}	
	}
	
	private inline function iterate_over_finds(Xmls:Array<Xml>, key:String) {
		var command:Shortcuts_Command;
		for (xml in Xmls) {
			command = new Shortcuts_Command(xml.get(key));
			command.gather_values(xml);
			shortcuts.get(key)(xml, command);
		}	
	}
	
	public function shortcut_shuffle(xml:Xml, command:Shortcuts_Command) {
	
	
	}
	
}

class Shortcuts_Command {
	
	public var propVals:Array<PropVal> = new Array<PropVal>();
	public static var permitted:Array<String>;
	public var splitBy_arr:Array<String> = new Array<String>();
	
	public function new(str:String){
		
		var properties:Array<String> = str.split(" ");
		
		if (properties.length > 0) {
			var text:String;
			while(properties.length>=0){
				text = properties.pop();
				if (permitted.indexOf(text) == -1) {
					properties.push(text);
					break;
				}
				splitBy_arr.unshift(text);
			}
		} else {
			throw 'not given anything to shuffle';
		}
		
		var propVal:PropVal;
		for (prop in properties) {
			propVal = new PropVal(prop);
			propVals.push(propVal);
		}
	}
	
	//for testing purposes
	public function properties() {
		var arr:Array<String> = [];
		for (propVal in propVals) {
			arr.push(propVal.prop);
		}
		return arr;
	}
	
	public function gather_values(xml:Xml) {
		var found:Xml;
		for (propVal in propVals) { 
			if (propVal.prop.indexOf(".") == -1) {
				propVal.xmlParent = xml;
				propVal.val = xml.get(propVal.prop);
			}
			else {
				//need to traverse up xml tree and find prop that is being referred to.
				throw 'not implemented yet';
			}
		}
		if (splitBy_arr.length == 0) {
			var vals:Array<String> = [];
			for (propVal in propVals) {
				vals.push(propVal.val);
			}	
			var detected:String = detect_split(vals, xml);
		}	
	}
	

	public function detect_split(vals:Array<String>, xml:Xml) {
		var found:Array<String> = [];
		var combined:String = vals.join("");
		
		for (split in permitted) {
			if (combined.indexOf(split) != -1) found.push(split);
		}
		if (found.length == 1) return found[0];
		else if(found.length == 0) return null;
		else {
		
			throw 'cannot automatically find what to split in this node: ' + xml.toString();
		}		
	}
	
	
}

class PropVal {
	public var prop:String;
	public var val:String;
	public var xmlParent:Xml;
	
	public function new(nam:String) {
		prop = nam;
	}
	
}