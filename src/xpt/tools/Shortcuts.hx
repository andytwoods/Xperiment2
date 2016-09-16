package xpt.tools;
import xpt.trial.Trial;

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
	
		
	public function stimulus_wide(props:Map<String,String>, trial:Trial) {
	//ugly hack
		
	for (shortcut in shortcuts.keys()) {
		if (props.exists(shortcut)) {
			var mod:String = props.get(shortcut);
			var arr:Array<String> = XRandom.shuffle(mod.split("---"));
			props.set(shortcut, arr.join("---"));
			
		}
	
	}
	}
	
	
	
	public function experiment_wide(xml:Xml) {
		
		var uppercase_keys:Array<String> = XTools.iteratorToArray(shortcuts.keys());
		
		for (i in 0...uppercase_keys.length) {
			uppercase_keys[i] = uppercase_keys[i].toUpperCase();
		}

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
			command.make_vals_same_len();
			shortcuts.get(key.toLowerCase())(xml, command);
		}	
	}
	
	public function shortcut_shuffle(xml:Xml, command:Shortcuts_Command) {
		var primaryShuffle:Array<Int> = new Array<Int>();
		var secondaryShuffle:Array<Int> = null;
		
		for (i in 0...command.max_primary_len) {
			primaryShuffle.push(i);
		}
		
		XRandom.shuffle(primaryShuffle);
		
		if (command.max_secondary_len > 0) {
			secondaryShuffle = new Array<Int>();
			for (i in 0...command.max_secondary_len) {
				secondaryShuffle.push(i);
			}
			XRandom.shuffle(secondaryShuffle);
		}
		
		command.reorder(primaryShuffle, secondaryShuffle);	

		command.save();	
	}
	
}

class Shortcuts_Command {
	
	public var propVals:Array<PropVal> = new Array<PropVal>();
	public static var permitted:Array<String>;
	public var splitBy_arr:Array<String> = new Array<String>();
	public var max_primary_len = 0;
	public var max_secondary_len = 0;
	
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
	
	public function save() {
		var by:String = splitBy_arr[0];
		for (pv in propVals) {
			pv.save(by);
			pv = null;
		}
		propVals = null;
	}
	
	public function reorder(primaryShuffle:Array<Int>, secondaryShuffle:Array<Int>) {
		var arr:Array<String> = new Array<String>();
		var i:Int;
		for (pv in propVals) {
			pv.primary_order(primaryShuffle);
		}

		if (secondaryShuffle != null) {
			var secondSplit:String = splitBy_arr[1];
			for (pv in propVals) {
				pv.secondary_order(secondaryShuffle, secondSplit);
			}
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
				var arr:Array<String> = propVal.prop.split(".");
				propVal.prop = arr[1];
				var id:String = arr[0];
				var siblings = xml.elements();
				var found:Bool = false;
				for (sibling in siblings) {
					if (sibling.exists('id') && sibling.get('id').toString() == id) {
						propVal.xmlParent = sibling;
						propVal.val = sibling.get(propVal.prop);
						found = true;
						break;
					}
				}
				if (found == false) {
					throw 'Could not find an id: '+arr.join(".");
				}
				
			}
		
		}
		if (splitBy_arr.length == 0) {
			var vals:Array<String> = [];
			for (propVal in propVals) {
				vals.push(propVal.val);
			}	
			var detected:String = detect_split(vals, xml);

			splitBy_arr.push(detected);
		}	
		for (propVal in propVals) { 
			propVal.doSplit(splitBy_arr);
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
	

	public function make_vals_same_len() {
		
		for (propVal in propVals) {
			if (max_primary_len < propVal.primary_len) max_primary_len = propVal.primary_len;
			if (max_secondary_len < propVal.secondary_len) max_secondary_len = propVal.secondary_len;
		}
		
		for (propVal in propVals) {
			propVal.expandVal(max_primary_len, max_secondary_len, splitBy_arr);
		}
	}	
}

class PropVal {
	public var prop:String;
	public var val_split:Array<String>;
	public var primary_len:Int;
	public var secondary_len:Int = 0;
	public var val:String;
	public var xmlParent:Xml;
	
	public function new(nam:String) {
		prop = nam;
	}
	
	public function save(by:String) {
		xmlParent.set(prop, val_split.join(by));
	}
	
	
	public function primary_order(order:Array<Int>) {
		var pos:Int;
		var arr:Array<String> = new Array<String>();
		for (i in 0...order.length) {
			pos = order[i];
			arr.push(val_split[pos]);
		}
		val_split = arr;
	}
	
	public function secondary_order(order:Array<Int>, by:String) {
		for (i in 0...val_split.length) {
			val_split[i] = _secondary_order(val_split[i], order, by);
		}
	}
	
	public inline function _secondary_order(text:String, order:Array<Int>, by:String) {
		var split:Array<String> = text.split(by);
		var ordered:Array<String> = new Array<String>();
		var pos:Int;
		for (i in 0...split.length) {
			pos = order[i];
			ordered.push(split[pos]);
		}
		return ordered.join(by);
	}
	

	
	public function expandVal(primary:Int, secondary:Int, splitBy_arr:Array<String>) {
		if (primary_len == 0) return;
		var counter:Int = 0;
		while (val_split.length < primary) {
			val_split.push(val_split[counter++]);
		}
		if (secondary != 0) expandSecondary(secondary, val_split, splitBy_arr[1]);		
	}
	
	public function expandSecondary(secondary:Int, val_split:Array<String>, splitBy:String) 
	{
		var val:String;
		var arr:Array<String>;
		var counter:Int;
		for (i in 0...val_split.length) {
			val = val_split[i];
			arr = val.split(splitBy);
			counter = 0;
			while (arr.length < secondary) {
				arr.push(arr[counter++]);
			}
			val_split[i] = arr.join(splitBy);
		}
	}
	
	public function doSplit(splitByArr:Array<String>) {
		val_split = val.split(splitByArr[0]);
		
		primary_len = val_split.length;
		
		if (splitByArr.length > 1) {
			var current:Int = 0;
			for(splitVal in val_split) {
				current = splitVal.split(splitByArr[1]).length;
				if (secondary_len < current) secondary_len = current;
			}
		}
		
	}
}