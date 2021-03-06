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
	
	public static inline var Trial_copyOverId:String = "copyOverId";
	public static inline var Trial_TemplateId:String = "template";
	
	public static inline var BetweenSJs_copyOverId:String = "multiCopyOverId";
	public static inline var BetweenSJs_TemplateId:String = "multiTemplate";	
	
	public static inline var betweenSJ_nodeName:String = "multi";
	
	
	public function new(script:Xml) {
		if(script !=null) compose(script);
	}

	public function compose(script:Xml):Xml
	{
	
		var requireTemplatingIterator = XML_tools.find(script, Trial_TemplateId);
		

		if (requireTemplatingIterator.hasNext() == false) {
			return script;
		}

		var templateList:TemplateList = new TemplateList();
		var requireTemplatingList:Array<RequireTemplating> = templateList.compose(script,requireTemplatingIterator); 

		var templateMap:Map<String, RequireTemplating> = __generateTemplatesMap(requireTemplatingList);

		var requireTemplate:RequireTemplating;
		for (requireTemplate in requireTemplatingList) {
			//trace(requireTemplate.requested);
			__applyTemplates(requireTemplate, templateMap, Trial_copyOverId);
		}

		return script;
	}
	
	private inline function checkRequired(script:Xml) 
	{
		return betweenSJ_nodeName == XML_tools.nodeName(script).toLowerCase();
	}
	
	public function __applyTemplates(require:RequireTemplating, templateMap:Map<String, RequireTemplating>,copyOverTag:String) 
	{
		if (require.templates.length == 0) return;
		if (require.hasBeenTemplated) return;
		
		var template:RequireTemplating;
	
		for (templateNam in require.templates) {
			//trace(111, templateNam,222,require.templates,require.templates.length,require.templates[0].length,require.name);
			template = templateMap.get(templateNam);
			if (template == null) throw "Error: You probably have a typo in one of your template names ("+templateNam+").";
			if (template.hasBeenTemplated == false) {
				if (template.requested > 100) {
					throw "Problem with your templates: infinitely looped.";
				}
				template.requested++;
				__applyTemplates(template, templateMap, copyOverTag);
			}
			//nb dislike cloning xml this way https://groups.google.com/forum/#!topic/haxelang/Waz0taglqMk
			XML_tools.extendXML_inclBossNodeParams(require.xml, Xml.parse(template.xml.toString()) , copyOverTag, false);
			
			require.hasBeenTemplated = true;
		}
	}
	
	public function __generateTemplatesMap(requireTemplatingList:Array<RequireTemplating>):Map<String, RequireTemplating>
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

