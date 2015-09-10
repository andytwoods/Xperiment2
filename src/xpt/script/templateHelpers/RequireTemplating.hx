package xpt.script.templateHelpers;
import xpt.tools.XML_tools;


class RequireTemplating {
	
	public var templates:Array<String> = [];
	public var name:String;
	public var xml:Xml;
	public var isTemplate:Bool;
	public var hasBeenTemplated:Bool = false;
	public var requested:Int = 0;
	
	static public inline function make(xml:Xml):RequireTemplating
	{
		var requiredTemplatesStr:Null<String> = XML_tools.findAttr(xml, Templates.Trial_TemplateId);
		//trace(requiredTemplatesStr, 222, xml);
		
		if (requiredTemplatesStr == '') return null;
		
		var instance = new RequireTemplating();
		//instance.templates.reverse();
		instance.name = XML_tools.nodeName(xml).toLowerCase();
		instance.xml = xml;
		instance.templates = requiredTemplatesStr.split(",");
		
		return instance;
	}
	
	public function new() { }
	
	/*public function setTemplates(str:String) {
		var arr:Array<String> = str.split(",");
		for (i in 0...arr.length) {
			var item = arr[i];
			if (item.length > 0) {
					templates.push(item);
			}
		}
		
	}*/

	
	
	
	
}