package xpt2.core.entities;

class Stimulas {
	public var children:Array<Stimulas>;
	
	public function new() {
		children = new Array<Stimulas>();
	}
	
	public static function fromXML(xml:Xml, index:Int = 0):Stimulas {
		var s:Stimulas = StimulasFactory.createStimulas(xml.nodeName);
		return s;
	}
	
	public static function multipleFromXML(xml:Xml):Array<Stimulas> {
		var array:Array<Stimulas> = new Array<Stimulas>();
		return array;
	}
}
