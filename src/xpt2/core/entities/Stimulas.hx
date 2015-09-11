package xpt2.core.entities;

import xpt2.core.IClonable;
import xpt2.core.utils.XMLUtils;

class Stimulas implements IClonable<Stimulas> {
	public var id:String;
	public var type:String = "Stimulas";
	public var children:Array<Stimulas>;
	
	public function new() {
		children = new Array<Stimulas>();
	}

	private function self():Stimulas {
		return new Stimulas();
	}
	
	public function clone():Stimulas {
		var c:Stimulas = self();
		c.id = this.id;
		c.type = this.type;
		for (child in this.children) {
			c.children.push(child.clone());
		}
		return c;
	}
	
	public function toString(indent:Int = 0):String {
		var is:String = "";
		for (n in 0...indent) {
			is += "\t";
		}
		var s = is + "{\n";
		var fields = Reflect.fields(this);
		for (f in fields) {
			if (f != "children") {
				s += is + "\t" + f + ": " + Reflect.field(this, f) + ",\n";
			}
		}
		s += is + "}\n";
		return s;
	}
	
	public static function fromXML(xml:Xml, index:Int = 0):Stimulas {
		var s:Stimulas = StimulasFactory.createStimulas(xml.nodeName);
		XMLUtils.applyXMLProperties(s, xml, index, ["count"]);
		return s;
	}
	
	public static function multipleFromXML(xml:Xml):Array<Stimulas> {
		var array:Array<Stimulas> = new Array<Stimulas>();
		
		var count:Int = 1;
		if (xml.get("count") != null) {
			count = Std.parseInt(xml.get("count"));
		}
		
		for (i in 0...count) {
			var s:Stimulas = fromXML(xml, i);
			array.push(s);
		}
		
		return array;
	}
}
