package code;
import xpt.tools.XML_tools;
import xpt.tools.XTools;
import xpt.trial.Trial;

enum RunCodeEvents  {

	BeforeEverything;
	BeforeExperiment;
	BeforeFirstTrial;
	BeforeTrial;
	AfterTrial;
	BeforeLastTrial;

}
class CheckIsCode
{

	public static function DO(xml:Xml, check:RunCodeEvents):String {
		
		
		if (xml == null) return null;
		var code:Xml = xml;
		
		
		switch check {
			
			case BeforeEverything | BeforeExperiment:
				if (checkIsCode(code) == false) return null;
				
			case BeforeFirstTrial:
				code = afterExperimentSetup(xml);
				if (code == null) return null;
				
			case BeforeLastTrial:
				code = null;
				
			case BeforeTrial:
				code = null;
				
			case AfterTrial:
				code = null;
			
		}

		if (code != null) return code.toString();
		
		return null;
	}
	
	static public function afterExperimentSetup(xml:Xml):Xml
	{
		var i:Int = 0;
		var firstIsSetup:Bool = false;
		for (node in XML_tools.getChildren(xml)) {
			
			if(node.nodeType != Xml.PCData){
				if (i == 1) {
					if (checkIsCode(node) == true && firstIsSetup) return node;
				}
				if ( i == 0) {
					if (XML_tools.nodeName(node).toLowerCase() == "setup") firstIsSetup = true;
				}
				i++;
			}
		}
		return null;
	}
	

	
	
	public static inline function checkIsCode(xml:Xml):Bool {
		if (XML_tools.nodeName(xml).toLowerCase() != "code") return false;
		else return true;
	}
	
	public static function seekScripts(trial:Trial, xml:Xml) 
	{
		var nodes:Iterator<Xml> = XML_tools.getChildren(xml);
		
		
		var nodesArr:Array<Xml> = XTools.iteratorToArray(nodes);

		if (nodesArr.length == 0) return;

		var node:Xml;

		node = nodesArr[0];

		if (node != null && node.nodeType == Xml.Element && checkIsCode(node)) {
			trial.codeStartTrial = getCode(node);
		}

		if (nodesArr.length == 1) return;
		
		node = nodesArr[nodesArr.length - 1];
		if(node != null && node.nodeType == Xml.Element && checkIsCode(node)) 	trial.codeEndTrial = getCode(node);


	}
	
	public static function getCode(xml:Xml):String
	{
		var str:String = xml.toString();
		var i:Int = str.indexOf(">") + 1;
		str = str.substr(i, str.length - i - 7);
		if (str.substr(0, 9) == "<![CDATA[") str = str.substr(9, str.length - 12);
		return str;
	}
	
}