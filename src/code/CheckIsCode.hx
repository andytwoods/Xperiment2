package code;
import xpt.tools.XML_tools;

enum Checks  {

	BeforeEverything;
	BeforeExperiment;
	BeforeFirstTrial;
	BeforeTrial;
	AfterTrial;
	BeforeLastTrial;

}
class CheckIsCode
{

	public static function DO(xml:Xml, check:Checks):Xml {
		
		if (xml == null) return null;
		var code:Xml;
		
		
		switch check {
			
			case BeforeEverything | BeforeExperiment:
				code = xml.firstChild();
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

		
		return code;
	}
	
	static public function afterExperimentSetup(xml:Xml):Xml
	{
		var i:Int = 0;
		var firstIsSetup:Bool = false;
		for (node in XML_tools.getChildren(xml)){
			if (i == 1) {
				if (checkIsCode(node) == true && firstIsSetup) return node;
			}
			if ( i == 0) {
				if (node.nodeName.toLowerCase() == "setup") firstIsSetup = true;
			}
			i++;
		}
		return null;
	}
	

	
	
	public static inline function checkIsCode(xml:Xml):Bool {
		if (xml.nodeName.toLowerCase() != "code") return false;
		else return true;
	}
	
}