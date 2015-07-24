package script;
import assets.manager.FolderTree.Error;
import xmlTools.E4X;

/**
 * ...
 * @author 
 */
class XML_tools
{

/*	public function new() 
	{
		
	}*/
	
	
	static public function findAttr(xml:Xml, attrib:String):String
	{	
		var val = find(xml, attrib, null);
		if (val.hasNext() == false) return "";
		var str:String = simpleXML(val.next()).get(attrib);
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
	
	static public function findNode(xml:Xml, name:String):Iterator<Xml>
	{	
		return E4X.x(xml.desc(name));
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
	

	
	static public function findInVal(xml, findArr:Array<String>):Map<String,Array<Xml>> {
		
		//n.b. if the node has no attributes, is not included.
		var nodes:Iterator<Xml> = E4X.x(xml._(a()));	
		
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
	
	//such that xml1 is the protected
	static public function extendXML(xml1:Xml, xml2:Xml, param:String):Xml {
		
		xml1 = simpleXML(xml1);
		xml2 = simpleXML(xml2);
		
		for (child in xml2.elements()) {
			child = simpleXML(child);
			var paramVal:String = child.get(param);

			if (paramVal != null) {
				var bossNodes = find(xml1, param, paramVal);
				nodes_extendAttribs(bossNodes, child, param);
			}
			else {
				xml1.addChild(child);
			}
		}

		return xml1;
	}
	
	@:extern static private inline function nodes_extendAttribs(bossNodes:Iterator<Xml>, child:Xml, param:String) 
	{
		for (bossNode in bossNodes) {
			extendAttribs(bossNode, child);
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
	
	
}

