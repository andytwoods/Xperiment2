package code;
import xpt.tools.XML_tools;

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
	
}