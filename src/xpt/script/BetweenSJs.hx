package xpt.script;
import xpt.script.BetweenSJs.Action;
import xpt.script.BetweenSJs.BetweenSJcond;
import xpt.tools.XML_tools;
import xpt.tools.XTools;

/**
 * ...
 * @author 
 */
class BetweenSJs
{
	static public inline var betweenSJ_nodeName = "multi";
	static public inline var PARENT:String = "parent";
	static public inline var MULTIID:String = "multiId";
	
	
	static public function compose(script:Xml, forceToRun:String=''):Xml
	{
		if (	continueCheck(script) == false) return script;
		
		var parent:Xml = script.firstChild();
		var condition:BetweenSJcond;
		var betweenSJMap:Map<String, BetweenSJcond> = getBetweenSJConds(script, parent.firstChild().nodeName);

		for (condNam in betweenSJMap.keys() ) {
			condition =  betweenSJMap.get(condNam);
			__applyParentConditions(condNam, condition, betweenSJMap);
		}
		

		if(forceToRun=="")	forceToRun= ToRun.compose(script);
		if(betweenSJMap.exists(forceToRun)){
			__applyToParent(parent, betweenSJMap.get(forceToRun).xml);
		}
		script = parent.firstChild();
		return script;
	}
	
	static public function __applyToParent(parent:Xml, experiment:Xml):Xml
	{
		var action:Action;
		var lookFor:String;
		var found:Iterator<Xml>;
		
		for (actionXml in XML_tools.getChildren(experiment)) {
			action = new Action(actionXml);		
			applyAction(parent, action);	
		}
		
		return parent; 
	}
	
	static public inline function applyAction(parent:Xml, action:Action) 
	{
		
		var found = XML_tools.find(parent, MULTIID, action.name);
		if (found.hasNext()) {
			XML_tools.overwriteAttribs_addAbsentChildren(found, action.map,action.children);
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
			XML_tools.extendAttribs(condition.xml, template.xml);
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
				betweenSJcond = new BetweenSJcond(child,nam);
				if (map.exists(betweenSJcond.name)) throw "each experimental between SJ condition must have a unique name, not like these: " + betweenSJcond.name;
				map[nam] = betweenSJcond;
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
	
	public function new(xml:Xml, nam:String) {
		name = nam;
		this.xml = XML_tools.copy(xml);
		
		
		var copyFromStr:String = XML_tools.findAttr(xml, BetweenSJs.PARENT);
		
		if (copyFromStr == "") {
			copyFrom = [];
			hasBeenFleshedOut = true;
		}
		else copyFrom = copyFromStr.split(",");
		
	}	
}

class Action {

	public var name:String;
	public var children:Iterator<Xml>;
	public var map:Map<String,String>;
	
	public function new(xml:Xml) {
		
		map = XML_tools.attribsToMap(XML_tools.copy(xml)); //crazyness
		name = XML_tools.nodeName(xml);
		
		children = XML_tools.getChildren(xml);		
	}
	
}