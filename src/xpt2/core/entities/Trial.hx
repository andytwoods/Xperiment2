package xpt2.core.entities;

import xpt2.core.utils.XMLUtils;

class Trial {
	public var id:String;
	public var type:String;
	public var templates:String;
	
	public var stimuli:Array<Stimulas>;
	
	public function new() {
		stimuli = new Array<Stimulas>();
	}
	
	public function findStimulasById(stimulasId:String):Stimulas {
		var s:Stimulas = null;
		for (child in stimuli) {
			if (child.id == stimulasId) {
				s = child;
				break;
			}
		}
		return s;
	}
	
	public function toString():String {
		var s = "{\n";
		s += "\tid: " + id + ",\n";
		s += "\ttype: " + type + ",\n";
		s += "\ttemplates: [" + templates + "],\n";
		s += "\tstimuli: [\n";
		for (x in stimuli) {
			s += x.toString(2);
		}
		s += "\t]\n";
		s += "}\n";
		return s;
	}
	
	private static function recursivelyLoadStimuli(xml:Xml, array:Array<Stimulas>) {
		for (node in xml.elements()) {
			var sa:Array<Stimulas> = Stimulas.multipleFromXML(node);
			for (s in sa) {
				array.push(s);
				if (node.elements().hasNext() == true) {
					recursivelyLoadStimuli(node, s.children);
				}
			}
		}
	}
	
	public static function fromXML(xml:Xml, index:Int = 0):Trial {
		var t:Trial = new Trial();
		XMLUtils.applyXMLProperties(t, xml, index);
		if (xml.get("templates") != null) {
			t.templates = xml.get("templates");
		} else if (xml.get("template") != null) {
			t.templates = xml.get("template");
		}

		recursivelyLoadStimuli(xml, t.stimuli);
		
		return t;
	}
	
	public static function multipleFromXML(xml:Xml):Array<Trial> {
		var array:Array<Trial> = new Array<Trial>();
		
		var count:Int = 1;
		if (xml.get("count") != null) {
			count = Std.parseInt(xml.get("count"));
		}
		
		for (i in 0...count) {
			var t:Trial = fromXML(xml, i);
			array.push(t);
		}
		
		return array;
	}
}