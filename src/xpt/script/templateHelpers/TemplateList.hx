package xpt.script.templateHelpers;
import thx.Arrays;
import xpt.script.templateHelpers.RequireTemplating;
import xpt.tools.XML_tools;

/**
 * ...
 * @author 
 */
class TemplateList
{

	static public function compose(script:Xml,requireTemplatingIterator:Iterator<Xml>):Array<RequireTemplating>
	{
		
		var requireTemplatingList:Array<RequireTemplating> = __generateList(requireTemplatingIterator);
		var templateNameList:Array<String> = __getTemplateNames(requireTemplatingList);
		markTemplatesInList(requireTemplatingList, templateNameList);
		templateNameList = __removeDuplicates(templateNameList, requireTemplatingList);
		
		__addMissingTemplatesToList(requireTemplatingList, templateNameList, script);
		
		return requireTemplatingList;
		
	}

	
	static private function markTemplatesInList(requireTemplatingList:Array<RequireTemplating>, templateNameList:Array<String>) 
	{
		for (requireTemplating in requireTemplatingList) {
			if (templateNameList.indexOf(requireTemplating.name) != -1) {
					requireTemplating.isTemplate = true;
			}
			else {
					requireTemplating.isTemplate = false;
			}
			
		}
	}
	
	static public function __removeDuplicates(templateNameList:Array<String>, requireTemplatingList:Array<RequireTemplating>) 
	{
		templateNameList = Arrays.distinct(templateNameList);
		
		for (requireTemplating in requireTemplatingList) {
			templateNameList.remove(requireTemplating.name);
		}
		
		return templateNameList;
	}
	
	static public function __addMissingTemplatesToList(requireTemplatingList:Array<RequireTemplating>, missingTemplateList:Array<String>, script:Xml) 
	{
		for (missing in missingTemplateList) {
			var xmlIterat = XML_tools.findNode(script,missing);
			if (xmlIterat.hasNext()) {
				var requireTemplating = new RequireTemplating();
				requireTemplating.name = missing;
				requireTemplating.isTemplate = true;
				requireTemplating.xml = xmlIterat.next();
				if (xmlIterat.hasNext())	throw "A template has been requested, but there are several templates of the same name which is not allowed: " + missing;
				requireTemplatingList[requireTemplatingList.length] = requireTemplating;
				
			}
		}
	}
	
	static public function __getTemplateNames(arr:Array<RequireTemplating>):Array<String>
	{
		var arr2:Array<String> = [];
		for (requiresTemplating in arr) {
			arr2 = arr2.concat(requiresTemplating.templates);
		}
		return arr2;
	}
	
	public static function __generateList(requireTemplatingIterator:Iterator<Xml>): Array<RequireTemplating>
	{
		var arr:Array<RequireTemplating> = [];
		
		for (xml in requireTemplatingIterator) {

			var requireTemplating = RequireTemplating.make(xml);
			if (requireTemplating != null) arr[arr.length] = requireTemplating;
		}
		
		return arr;
	}
	
	
}