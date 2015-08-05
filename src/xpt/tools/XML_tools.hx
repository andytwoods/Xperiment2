package xpt.tools;
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
		var str = simpleXML(xml).get(attrib);
		if (str == null) str = "";
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
		if (value == null && attrib!=null)	return E4X.x(xml._(a(attrib) ));
		if (value != null && attrib!=null)	return E4X.x(xml._(a(attrib) == value));
		if (value != null && attrib==null)	return E4X.x(xml._(a() == value));	
		throw "";
		return null;
	}
	
	static public function nodeName_lowercase(xml:Xml):String {
		return simpleXML(xml).nodeName.toLowerCase();
	}
	
	static public function findNode(xml:Xml, name:String):Iterator<Xml>
	{	
		return E4X.x(xml.desc(name));
	}
	
	static public function getChildren(xml:Xml):Iterator<Xml> {
		return E4X.x(xml.child());
	}
	
	static public function flatten(xml:Xml,recurseOn:Array<String>):Xml {
	
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


	
	static public function many_modifyAttrib(xmls:Iterator<Xml>, name:String, newValue:String):Iterator<Xml> {
		var arr = [];
		for (xml in xmls) {
			arr[arr.length] = XML_tools.modifyAttrib(xml, name, newValue);
		}
		
		return xmls = arr.iterator();
	}
	
	@:extern public static inline function simpleXML(xml:Xml ) {
		if (xml.firstChild() !=null) 	return xml.firstChild()
		else 							return xml;
	}
	
	/*
		adds attribs to the boss node, despite there being no 'param' specified for this node.
	*/
	static public function extendXML_inclBossNodeParams(xml1:Xml, xml2:Xml, param:String):Xml {
		extendAttribs(xml1, xml2);
		return extendXML(xml1, xml2, param);
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
		
		xml1 = simpleXML(xml1);
		xml2 = simpleXML(xml2);
		
		for (child in xml2.elements()) {
			child = simpleXML(child);
			var paramVal:String = child.get(param);

			if (paramVal != null) {
				var bossNodes = find(xml1, param, paramVal);
				nodes_extendAttribs(bossNodes, child);
			}
			else {
				xml1.addChild(child);
			}
		}

		return xml1;
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
	
	static public function iteratorToMap(found1:Iterator<Xml>, param:String): Map<String, Xml>
	{
		var map:Map<String, Xml> = new Map<String, Xml>();
		var nam:String;
		for (xml in found1) {
			map.set( simpleXML(xml).get(param), xml);
		}
		return map;
	}
	
	//such that xml1 paras are the protected
	static public function extendAttribs(xml1:Xml, xml2:Xml):Xml {
		
		xml1 = simpleXML(xml1);
		xml2 = simpleXML(xml2);
		
		for (attrib in xml2.attributes()) {
			if (xml1.exists(attrib) == false) {
					xml1.set(	attrib, xml2.get(attrib).toString()	);
			}
		}	
		return xml1;
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
	
	static public function AttribsToMap(xml:Xml):Map<String,String> {
		xml = simpleXML(xml);
		var myMap:Map<String,String> = new Map<String,String>();
		for (attrib in xml.attributes()) {
			var val = xml.get(attrib);
				myMap.set(attrib, val);
		}
		return myMap;
	}
	
	static public inline function nodeName(xml:Xml):String {
		return simpleXML(xml).nodeName;
	}
	
	static public inline function nodeValue(xml:Xml):String {
		return simpleXML(xml).nodeValue;
	}
	
	static public function augment(boss:Xml, donator:Xml):Xml {
		
		var nam:String, val:String;
		
		var bossChild:Xml;
		
		for (child in getChildren(donator)) {
			
			nam = nodeName(child);
			val = nodeValue(child);
		
			var bossFound = findNode(boss, nam);
			
			if (bossFound.hasNext() == true) {
				extendAttribs(bossFound.next(), child);
			}
			else {
				addChildCopy(boss,child,nam);
			}
			
		}
		return boss;
	}
	
	static public inline function addChildCopy(boss:Xml, toCopy:Xml, nam:String):Xml
	{
		var copy:Xml = Xml.parse("<" + nam + "/>");
		var nam:String, val:String;
		

			for (nam in toCopy.attributes()) {
				val = toCopy.get(nam);
				//addAttrib(copy, attrib.nodeName, attrib.nodeValue);
				trace(nam, val);
			}
			//boss.addChild(copy);
		
		
		return boss;
	}
	
}


class NodesWithFilteredAttribs {
	public var attribName:String;
	public var attribVal:String;
	public var xml:Xml;
	
	public function new(){}
}