package xpt2.core.entities;

import xpt2.core.utils.XMLUtils;

class TrialTemplate extends Trial {
	public var templateId:String;
	
	public function new() {
		super();
	}
	
	public static override function fromXML(xml:Xml):TrialTemplate {
		var t:TrialTemplate = cast Trial.fromXML(xml);
		t.templateId = xml.nodeName;
		return t;
	}
}