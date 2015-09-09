package xpt.tools;
import haxe.ds.StringMap;
import thx.Maps;
import xmlTools.E4X;

/**
 * ...
 * @author 
 */
class XML_tools
{

	/*
	findAttr cannot deal with xml with children. This is to be used for those rare occurences.
	*/
/*	static public function findAttr_ignoreChildren(xml:Xml, attrib:String):String
	{	
		var str = xml.get(attrib);
		if (str == null) return "";
		return str;
	}*/
	
	static public function findAttr(xml:Xml, attrib:String):String
	{	
		var str:Null<String> = simpleXML(xml).get(attrib);
		if (str == null) str = "";
		return str;
	}
	
	static public function findAttr_templates(xml:Xml, attrib:String):String
	{		
		try{
			if (xml.exists(attrib)) {
				return xml.get(attrib);	
			}
		}
		catch(e:String){}
		
		
		var str:Null<String> = findAttr(xml, attrib);
		
		if (str == "") {	
			try {
				str = xml.firstChild().get(attrib);
			}
			catch (e:String) {
				str = "";
			}
		}
		
		if(str == null) return "";
		return str;
	}
	
	
	static public function findParentAttr(xml:Xml, attrib:String):String
	{	
		var str = xml.parent.get(attrib);
		if (str == null) str = "";
		return str;
	}
	
	
	static public function find(xml:Xml, attrib:String = null, value:String = null):Iterator<Xml>
	{	
		if (value == null && attrib!=null)	return E4X.x(xml.desc(a(attrib) ));
		if (value != null && attrib!=null)	return E4X.x(xml._(a(attrib) == value));
		if (value != null && attrib==null)	return E4X.x(xml._(a() == value));	
		throw "";
		return null;
	}
	
	static public function nodeName_lowercase(xml:Xml):String {		
		try {
			return simpleXML(xml).nodeName.toLowerCase(); 
		}
		catch (e:String) {
			return xml.nodeName;
		}
		return '';
	}
	
	static public function findNode(xml:Xml, name:String):Iterator<Xml>
	{	
		return E4X.x(xml.desc(name));
	}
	
	static public function getChildren(xml:Xml):Iterator<Xml> {
		return E4X.x(xml.child());
	}
		
	/*differing from getChildren in that in only returns the immediate children and not children of children etc*/
	/*static public function getImmediateChildren(xml:Xml):Iterator<Xml> {
		return xml.firstChild().iterator();
	}*/
	
/*	static public function flatten(xml:Xml,recurseOn:Array<String>):Xml {
		if (recurseOn == null) return xml;
		var safeXML:Xml = simpleXML(xml);
		

		if (safeXML.nodeType == Xml.PCData && xml.nodeType == Xml.Element) {
			safeXML = xml;// return xml;
		}

		for (child in safeXML.elements()) {
			var nodeName:String = child.nodeName;
			
			if (recurseOn.indexOf(nodeName) != -1) {

				flatten(child,recurseOn);	
			}
			
			//if the parent is not a protected node name, that is, is to be an attribute of the node
			else if(recurseOn.indexOf(nodeName) == -1) {
				
				if(child.attributes().hasNext() == true) {
					throw("at this moment, not allowed attributes for nodes within eg a stimulus or trial that you want to 'move up' to the attributes.");
				}
				
				if(child.elements().hasNext() == true) {
					throw("at this moment, not allowed further children for nodes within eg a stimulus or trial that you want to 'move up' to the attributes.");
				}
				
				var val:String;

				if (child.firstChild() != null) {
					val = child.firstChild().nodeValue;
				}
				else {
					val = "";
				}
				
				safeXML.set(nodeName, val);
				safeXML.removeChild(child);

			}

			
		}
		
		return xml;
	}
	*/

	
	
	static public function find_inVal(xml, findArr:Array<String>):Map<String,Array<NodesWithFilteredAttribs>> {
		
		var map:Map<String, Array<NodesWithFilteredAttribs>> = new Map<	String, Array<NodesWithFilteredAttribs>	>();
		for (findNam in findArr) {
			map.set(findNam, new Array<NodesWithFilteredAttribs>()	);
		}
		
	/*	var index:Int;
		var find = function(attName:String, attValue:String, xml:Xml):Bool {
			index = findArr.indexOf(attValue);
			map.get(findArr[index]).push(xml);
			return index != -1;
		}*/
		
		//var nodes:Iterator<Xml> = E4X.x(xml._(a(function(attName:String, attValue:String, xml:Xml):Bool{return attName=="id";})));
		//E4X.x(xml._(a(find)));
		
		
		var index:Int;
		var nodes:Iterator<Xml> = E4X.x(xml._(a()));
		var val:String;
		for (node in nodes) {
		
			for ( att in node.attributes() ) {
				val = node.get(att);
				for (split in findArr) {
					if (val.split(split).length > 1) {
						var nodesWithFilteredAttribs = new NodesWithFilteredAttribs();
						nodesWithFilteredAttribs.attribName = att;
						nodesWithFilteredAttribs.attribVal = val;
						nodesWithFilteredAttribs.xml = node;
						map.get(split).push(nodesWithFilteredAttribs);
					}
				}
			}
		}
		
		return map;
	}
	
	
	
	static public function find_val(xml, findArr:Array<String>):Map<String,Array<Xml>> {
		
		//n.b. if the node has no attributes, is not included.
		var nodes:Iterator<Xml> = getAttribs(xml);	
		
		var map:Map<String, Array<Xml>> = new Map<	String, Array<Xml>	>();
		for (findNam in findArr) {
			map.set(findNam, new Array<Xml>()	);
		}
		
		
		//searches through each of the nodes
		for (node in nodes) {
			//for each property to search for
			for (findStr in findArr) {
				if (node.exists(findStr)) {
					map.get(findStr).push(node);
				}	
			}
		}
		
		return map;
	}
	
	static private inline function getAttribs(xml:Xml):Iterator<Xml> {
		return E4X.x(xml._(a()));
	}

	
	static public function addAttrib(xml:Xml, name:String, newValue:String):Xml {
		return modifyAttrib(xml, name, newValue);	
	}
	
	static public function delAttrib(xml:Xml, name:String):Xml {
		xml.firstChild().remove(name);
		return xml;	
	}
	
	
	
	static public function modifyAttrib(xml:Xml, name:String, newValue:String):Xml
	{	
		simpleXML(xml).set(name, newValue);
		
		return xml;
	}


	
	static public inline function many_modifyAttrib(xmls:Iterator<Xml>, name:String, newValue:String):Iterator<Xml> {
		var arr = [];
		for (xml in xmls) {
			arr[arr.length] = XML_tools.modifyAttrib(xml, name, newValue);
		}
		
		return xmls = arr.iterator();
	}
	
	static public function firstSimpleXML(xml:Xml) {
		if (Xml.Element == xml.nodeType || Xml.Document == xml.nodeType) {
			for (child in xml.iterator()) {
				if (child != null) {
				
					if (child.nodeType == Xml.Element || child.nodeType == Xml.Document) {
						return child;
					}
				}
				else return xml;
			}
		}
		
		
		return xml;
	}
	
	public static inline function simpleXML(xml:Xml ) {
		if (xml.firstChild() != null) 	return xml.firstChild();
		else 							return xml;
	}
	
	/*
		adds attribs to the boss node, despite there being no 'param' specified for this node.
	*/
	static public function extendXML_inclBossNodeParams(xml1:Xml, xml2:Xml, param:String, _override:Bool = false ):Xml {
		extendAttribs(xml1, xml2, _override);
		//trace(xml1, xml2);
		var xml:Xml = extendXML(xml1, xml2, param);
		return xml;
	}
	
	
	/*
		Achieves the same purpose as extendXML but does so in the inverse fashion by copying over existing attributes and nodes. Probably more efficient for the scenario of of a small 'bossXml' and a much larger 'toCopyOver' xml.
	*/
	static public function extendXML_multi(bossXML:Xml, xml2:Xml, param:String):Xml {
		bossXML = simpleXML(bossXML);
		xml2 = simpleXML(xml2);
		
		for (child in xml2.elements()) {
			child = simpleXML(child);
			var paramVal:String = child.get(param);

			if (paramVal != null) {
				var bossNodes = find(bossXML, param, paramVal);
				nodes_overrideAttribs(bossNodes, xml2);
			}
		}

		return bossXML;
	}
	
	
	//such that xml1 is the protected
	static public function extendXML(xml1:Xml, xml2:Xml, param:String):Xml {
		
		var xml1_:Xml = simpleXML(xml1);
		var xml2_:Xml = simpleXML(xml2);
		//trace(xml2_, xml2_.elements().hasNext());
		var elements:Iterator<Xml>;
		
		try {
			elements = xml2_.elements();
		}
		catch (e:String) {
			xml2_ = xml2;
			elements = xml2_.elements();

		}
		
		for (child in elements) {
			
			child = simpleXML(child);
			var paramVal:String = child.get(param);

			if (paramVal != null) {
				var bossNodes = find(xml1_, param, paramVal);
				nodes_extendAttribs(bossNodes, child);
			}
			else {
				try {
					xml1_.addChild(child);
				}
				catch (e:String) {
					xml1.addChild(child);
				}
			}
		}

		return xml1_;
	}
	
	static private inline function nodes_extendAttribs(bossNodes:Iterator<Xml>, child:Xml) 
	{
		for (bossNode in bossNodes) {
			extendAttribs(bossNode, child);
		}
	}
	
	static private inline function nodes_overrideAttribs(bossNodes:Iterator<Xml>, child:Xml) 
	{
		for (bossNode in bossNodes) {
			overrideAttribs(bossNode, child);
		}
	}
	
	//such that xml1 paras are the protected
	static public function extendAttribs(xml1:Xml, xml2:Xml, _override:Bool = false):Xml {		
		var xml1_ = (xml1);
		var xml2_ = (xml2);

		var attribs:Iterator<String>;
		
		try {
			attribs = xml2_.attributes();
		}
		catch (str:String) {
			xml1_ = simpleXML(xml1);
			xml2_ = simpleXML(xml2);
			attribs = xml2_.attributes();
		}
	
		for (attrib in attribs) {
			
			if (_override == true || xml1_.exists(attrib) == false) {
					xml1_.set(	attrib, xml2_.get(attrib).toString()	);
			}
		}	

		return xml1_;		
	}
	
	static public function iteratorToMap(found1:Iterator<Xml>, param:String): Map<String, Xml>
	{
		var map:Map<String, Xml> = new Map<String, Xml>();
		var nam:String;
		for (xml in found1) {
			map.set( simpleXML(xml).get(param), xml);
		}
		return map;
	}
	

	
	static public function overrideAttribs(bossNode:Xml, childNode:Xml):Xml {
		
		bossNode = simpleXML(bossNode);
		childNode = simpleXML(childNode);
		
		for (attrib in childNode.attributes()) {
			if (bossNode.exists(attrib) == false) {
					bossNode.set(	attrib, childNode.get(attrib).toString()	);
			}
		}	
		return bossNode;
	}
	
	static public function attribsToMap(xml:Xml):Map<String,String> {
		xml = simpleXML(xml);
		return _attribsToMap(xml);
	}
	
	static private function _attribsToMap(xml:Xml):Map<String,String> {
		var myMap:Map<String,String> = new Map<String,String>();
		
		var attribs:Iterator<String>;
		if(xml.nodeType == Xml.Element){
			attribs = xml.attributes();
			for (attrib in attribs) {

				var val = xml.get(attrib);
					myMap.set(attrib, val);
			}
		}
	
		return myMap;
	}
	
	static inline public function addAttribsToMap(map:Map<String,String>,xml:Xml) {
		for (attrib in xml.attributes()) {
			map.set(attrib, xml.get(attrib));
		}
	}
	
	
	static inline public function checkNode(xml:Xml):Bool {
		return xml.nodeType == Xml.Element || xml.nodeType == Xml.Document;
	}
	
	static private inline function combineStringMaps(boss:StringMap<String>, slave:StringMap<String>) {
		if (boss == null) boss = new StringMap<String>();
		if (slave == null) return;
		
		
		for (key in slave.keys()) {
			boss.set(key, slave.get(key));
		}
		
	}
	
	static public function flattened_attribsToMap(xml:Xml, ignore:Array<String>, myMap:Map<String,String> = null):Map<String,String> {
		if (xml == null) return null;
		if (myMap == null) myMap = new StringMap<String>();
		switch(xml.nodeType) {
			case Xml.Element:
				addAttribsToMap(myMap, xml);			
				for(child in xml){
					flattened_attribsToMap(child, ignore, myMap);
				}
	
			case Xml.PCData:
				var nam = xml.parent.nodeName;
					
				if(ignore.indexOf(nam) ==-1){
					var val:String = xml.toString();
					if(val !=null)	myMap.set(nam, val);
				}	
				
			case Xml.Document:
				combineStringMaps(myMap, 	flattened_attribsToMap(xml.firstChild(),ignore,myMap)		);

			default:
				myMap = new Map <String, String>(); 
		}
	
		return myMap;
	}
	

	

	
	static public inline function nodeName(xml:Xml):String {
		return xml.nodeName;
	}
	
	static public inline function nodeValue(xml:Xml):String {
		return simpleXML(xml).nodeValue;
	}
	
	static public function augment(boss:Xml, donator:Xml):Xml {
		
		var nam:String;
		var bossChild:Xml, found:Xml;
		
		for (child in getChildren(donator)) {
			nam = nodeName(child);
			var bossFound = findNode(boss, nam);
			
			if (bossFound.hasNext() == true) {
				found = bossFound.next();
				extendAttribs(found, child);
			}
			else {
				addChildCopy(boss,child);
			}
			
		}
		return boss;
	}
	
	/*inefficiently copies node and children*/
	static public inline function copy(toCopy:Xml):Xml
	{
		return Xml.parse(toCopy.toString());
	}
	
	/*adds a copy of toCopy to within the boss xml*/
	static public inline function addChildCopy(boss:Xml, toCopy:Xml):Xml
	{
		var copy:Xml = Xml.parse(toCopy.toString());
		boss.firstElement().addChild(copy.firstChild());
		
		return boss;
	}
	
	static public inline function overwriteAttribs(found:Iterator<Xml>, map:Map<String, String>) 
	{
		var val:String;
		
		for (key in map.keys()) {
			trace(key, 22);
			val = map.get(key);
			for (xml in found) {	
				xml.set(key, val);
			}
		}
	}
	
	
	
	static public inline function addAbsentChildren(bossList:Iterator<Xml>, slave:Xml) {
		var nam:String;
		for (boss in bossList) {
			boss = simpleXML(boss);
			for (child in getChildren(slave)) {			
				boss.addChild(copy(child).firstChild());
			}
		}	
	}
	
	static public inline function overwriteAttribs_addAbsentChildren(found:Iterator<Xml>, map:Map<String, String>, children:Iterator<Xml>) 
	{
		var val:String;
		
		var childrenArr:Array<Xml> = [];
		
		for (child in children) {
			childrenArr[childrenArr.length] = child;	
		}
		
		for (key in map.keys()) {
			val = map.get(key);
			for (xml in found) {	
				xml.set(key, val);				
				for (child in childrenArr) {			
					xml.addChild(copy(child).firstChild());
				}				
			}
		}
	}
	

	

}

			





class NodesWithFilteredAttribs {
	public var attribName:String;
	public var attribVal:String;
	public var xml:Xml;
	
	public function new(){}
}