package xpt2.core.entities;

import xpt2.core.utils.XMLUtils;

class Trial {
	public var id:String;
	public var type:String;
	public var template:String;
	
	public var stimuli:Array<Stimulas>;
	
	public function new() {
		stimuli = new Array<Stimulas>();
	}
	
	private static function recursivelyLoadStimuli(xml:Xml, array:Array<Stimulas>) {
		for (node in xml.elements()) {
			trace(node.nodeName);
			var s:Stimulas = Stimulas.fromXML(xml);
			if (s != null) {
				array.push(s);
				if (node.elements().hasNext() == true) {
					recursivelyLoadStimuli(node, s.children);
				}
			} else {
				trace("WARNING! Stimulas not found: " + node.nodeName);
			}
		}
	}
	
	public static function fromXML(xml:Xml, index:Int = 0):Trial {
		var t:Trial = new Trial();
		XMLUtils.applyXMLProperties(t, xml, index);

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