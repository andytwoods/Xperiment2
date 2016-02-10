package xpt.tools;
import haxe.ds.StringMap;
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
		xml = simpleXML(xml);
		if (xml.exists(attrib)) return xml.get(attrib);
		return "";
	}

	
	static public inline function getAttribs_map(xml:Xml):Map<String, String > {
		var attribsXml = find(xml);
		var child;
		var map:Map<String,String> = new Map<String, String > ();
		for (node in attribsXml) {
			if (node != null) {
				for (attrib in node.attributes()) {
					map.set(attrib.toString(), node.get(attrib).toString());
				}
			}
		}
		return map;
	}
	
	static public function find(xml:Xml, attrib:String = null, value:String = null):Iterator<Xml>
	{	
		if (value == null && attrib!=null)	return E4X.x(xml.desc(a(attrib) ));
		if (value != null && attrib!=null)	return E4X.x(xml._(a(attrib) == value));
		if (value != null && attrib == null)	return E4X.x(xml._(a() == value));	
		if (value == null && attrib==null)	return E4X.x(xml._(a()));	
		throw "";
		return null;
	}
	
	static public function allNodes(xml:Xml):Map<String,String>
	{	
		
		var list = new Map<String,String>();
		var child;
		var str:String;

		for (x in E4X.x(xml.desc())) {
			if (x != null) {
				if( x.nodeType == Xml.Element){
					
					child =  x.iterator().next();
					if(child!=null){
						switch(child.nodeType) {
							case Xml.Element:
							case Xml.CData:
								str = child.toString();
								list.set(x.nodeName, str.substr(9,str.length-12));
							case Xml.PCData:
								list.set(x.nodeName, child.toString());
							default:
								trace('who knows', child.nodeType, child);
						}
					}
				}
			}
		}

		return list;
	}

	static public function findNode(xml:Xml, name:String):Iterator<Xml>
	{	
		return E4X.x(xml.desc(name));
	}
	
	static public function getChildren(xml:Xml):Iterator<Xml> {
		xml = simpleXML(xml);
		return E4X.x(xml.child());
	}
		

	
	static public function find_inVal(xml, findArr:Array<String>):Map<String,Array<NodesWithFilteredAttribs>> {
		
		var map:Map<String, Array<NodesWithFilteredAttribs>> = new Map<	String, Array<NodesWithFilteredAttribs>	>();
		for (findNam in findArr) {
			map.set(findNam, new Array<NodesWithFilteredAttribs>()	);
		}
		
		
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
	
	
	static public inline function getNodeAttribsMap(xml:Xml):Map < String, String> {
		xml = simpleXML(xml);
		var map:Map<String,String> = new Map<String,String>();
		if(xml.nodeType == Xml.Element){
			for (nam in xml.attributes()) {
				map.set(nam, xml.get(nam));
			}
		}
		return map;
	}
	
	
	static public function addAttrib(xml:Xml, name:String, newValue:String):Xml {
		return modifyAttrib(xml, name, newValue);	
	}
	
	static public function delAttrib(xml:Xml, name:String):Xml {
		simpleXML(xml).remove(name);
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
		if(xml.nodeType != Xml.Element){
			if(xml.nodeType == Xml.Document) xml = simpleXML(xml.firstChild());
			else xml = null;
			
		}
		return xml;
	}
	
	/*
		adds attribs to the boss node, despite there being no 'param' specified for this node.
	*/
	static public function extendXML_inclBossNodeParams(xml1:Xml, xml2:Xml, param:String, _override:Bool = false ):Xml {
		extendAttribs(xml1, xml2, _override);
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
		var elements:Iterator<Xml> = xml2_.elements();
		
		var bossElementsCopyOver:Array<String> = new Array<String>();
		for (child in xml1_.elements()) {
			if (child.exists(param)) bossElementsCopyOver.push(child.get(param));
		}

		for (child in elements) {

			child = simpleXML(child);
			var paramVal:String = child.get(param);
			if (paramVal != null) {
				var bossNodes = find(xml1_, param, paramVal);		
				nodes_extendAttribs_copyOverChildren(bossNodes, child);
				
				if (bossElementsCopyOver.indexOf(paramVal) == -1) {
					xml1_.addChild(child);
				}
				
			}
			else {

				xml1_.addChild(child);
			}
		}

		return xml1_;
	}
	

	
	static private inline function nodes_addChildren(bossNodes:Iterator<Xml>, child:Xml) 
	{
		for (childNode in child.elements()) {
			for (bossNode in bossNodes) {
				bossNode.addChild(childNode);

			}	
		}
	}
	
	static private inline function nodes_extendAttribs_copyOverChildren(bossNodes:Iterator<Xml>, child:Xml) 
	{
		for (bossNode in bossNodes) {
			extendAttribs(bossNode, child);
			addChildren(bossNode, child);
		}
	}
	
	static private inline function addChildren(bossNode:Xml, child:Xml) 
	{
		for (childNode in child.elements()) {	
				bossNode.addChild(childNode);
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
		xml1 = simpleXML(xml1);
		xml2 = simpleXML(xml2);

		for (attrib in xml2.attributes()) {
			
			if (_override == true || xml1.exists(attrib) == false) {
					xml1.set(	attrib, xml2.get(attrib).toString()	);
			}
		}	

		return xml1;		
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
		//trace(111, xml);
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
		return simpleXML(xml).nodeName;
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