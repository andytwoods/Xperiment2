package xpt.script;
import xpt.script.BetweenSJs.BetweenSJcond;
import xpt.tools.XML_tools;

/**
 * ...
 * @author 
 */
class BetweenSJs
{
	static public inline var betweenSJ_nodeName = "multi";
	static public inline var PARENT:String = "parent";
	
	
	static public function compose(script:Xml) 
	{
		if (	continueCheck(script) == false) return;
		
		var parent:Xml = script.firstChild();
		var betweenSJMap:Map<String, BetweenSJcond> = getBetweenSJConds(script, parent.nodeName);
		
		for (condNam in betweenSJMap.keys() ) {
			__applyParentConditions(condNam, betweenSJMap.get(condNam), betweenSJMap);
		}
		
	}
	
	static public inline function __applyParentConditions(condNam:String, condition:BetweenSJcond, betweenSJMap:Map<String, BetweenSJcond>) 
	{
		if (condition.hasBeenFleshedOut == true) return;
		
		var template:BetweenSJcond;
		for (templateNam in condition.copyFrom) {
			template = betweenSJMap.get(templateNam);
			if (template.hasBeenFleshedOut == false) {
				if (template.attempt++ > 100) throw "infinite loop in betweenSJs templating: "+ template;
				__applyParentConditions(templateNam, template, betweenSJMap);
			}
			XML_tools.augment(condition.xml, template.xml);
		}

		return;
	}
	
	static public inline function getBetweenSJConds(script:Xml, ignore:String):Map<String, BetweenSJcond>
	{
		var map = new Map<String, BetweenSJcond>();
		
		var children = XML_tools.getChildren(script);
		
		var betweenSJcond:BetweenSJcond;
		
		var nam:String;
		
		for (child in children) {
			nam = child.nodeName;
			if(nam!=ignore){
				betweenSJcond = new BetweenSJcond(child);
				if (map.exists(betweenSJcond.name)) throw "each experimental between SJ condition must have a unique name, not like these: "+ betweenSJcond.name;
				map[betweenSJcond.name] = betweenSJcond;
				script.removeChild(child);
			}
		}
		
		
		return map;
	}

	

	
	static inline public function continueCheck(script:Xml):Bool {
		return betweenSJ_nodeName == XML_tools.nodeName_lowercase(script);
	}
	
	
	
	
}

class BetweenSJcond {
	
	public var name:String;
	public var xml:Xml;
	public var copyFrom:Array<String>;
	public var hasBeenFleshedOut:Bool = false;
	public var attempt:Int = 0;
	
	public function new(xml:Xml) {
		name = xml.nodeName;
		this.xml = xml;
		
		var copyFromStr:String = XML_tools.findAttr(xml, BetweenSJs.PARENT);
		
		if (copyFromStr == "") {
			copyFrom = [];
			hasBeenFleshedOut = true;
		}
		else copyFrom = copyFromStr.split(",");
		
	}
	
	
	
}