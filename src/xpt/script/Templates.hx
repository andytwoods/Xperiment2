package xpt.script;
import thx.Arrays;
import thx.Iterators;
import xpt.script.templateHelpers.RequireTemplating;
import xpt.script.templateHelpers.TemplateList;
import xpt.tools.XML_tools;

/**
 * ...
 * @author 
 */
class Templates
{
	
	public static var COPYOVER_ID = "copyOverId";
	
	static public function compose(script:Xml) 
	{
		var requireTemplatingIterator = XML_tools.find(script, "template");
		if (requireTemplatingIterator.hasNext() == false) return;
		
		var requireTemplatingList:Array<RequireTemplating> = TemplateList.compose(script,requireTemplatingIterator); 
		
		var templateMap:Map<String, RequireTemplating> = __generateTemplatesMap(requireTemplatingList);
		
		for (requireTemplate in requireTemplatingList) {
			__applyTemplates(requireTemplate, templateMap);
		}
		
	}
	
	static public function __applyTemplates(require:RequireTemplating, templateMap:Map<String, RequireTemplating>) 
	{
		if (require.templates.length == 0) return;
		if (require.hasBeenTemplated) return;
		
		var template:RequireTemplating;
		
		for (templateNam in require.templates) {
			//trace(111, templateNam,222,require.templates,require.templates.length,require.templates[0].length,require.name);
			template = templateMap.get(templateNam);
			if (template == null) throw "devel err";
			if (template.hasBeenTemplated == false) {
				if (template.requested > 100) {
					throw "Problem with your templates: infinitely looped.";
				}
				template.requested++;
				__applyTemplates(template, templateMap);
			}
			
			XML_tools.extendXML_inclBossNodeParams(require.xml, template.xml, COPYOVER_ID);
			require.hasBeenTemplated = true;
		}
	}
	
	static public function __generateTemplatesMap(requireTemplatingList:Array<RequireTemplating>):Map<String, RequireTemplating>
	{
		var templateMap:Map<String, RequireTemplating> = new Map<String, RequireTemplating>();
		
		for (maybeTemplate in requireTemplatingList) {
			if (maybeTemplate.isTemplate) {
				var nam:String = maybeTemplate.name;
				if (templateMap.exists(nam)) {
					throw "devel err";
				}
				templateMap.set(nam, maybeTemplate);
			}
		}
		return templateMap;
	}
	
	
}