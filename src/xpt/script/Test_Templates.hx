package xpt.script;
import thx.Arrays;
import utest.Assert;
import xpt.script.templateHelpers.RequireTemplating;
import xpt.tools.XML_tools;
import xpt.tools.XTools;

/**
 * ...
 * @author 
 */
class Test_Templates
{

	public function new() { }

	public function test__generateTemplatesMap() {
	
		var nodeNames:Array<String> = "a,b,c,d,e,f,g".split(",");
		var isTemplates:Array<String> = "1,0,1,0,1,0,1".split(",");
		var needsNodes:Array<String> = "c,d,e---c------a---b---ab---f".split("---");
		
		var requireTemplatingList:Array<RequireTemplating> = [];
		
		for (i in 0...nodeNames.length) {
			var nodeName = nodeNames[i];
			var isTemplate = isTemplates[i] == "1";
			var templatesStr:String = needsNodes[i];
			var template:RequireTemplating = new RequireTemplating();
			template.name = nodeName;
			template.isTemplate = isTemplate;
			template.templates = templatesStr.split(",");
			requireTemplatingList.push(template);
		}
		
		var templates:Templates = new Templates(null);
		var templateMap:Map<String, RequireTemplating> = templates.__generateTemplatesMap(requireTemplatingList);
		
		var keys:Array<String> = XTools.iteratorToArray(templateMap.keys());
		XTools.sort(keys);
		Assert.isTrue(Arrays.equals(keys,["a","c","e","g"]));
	}
	
	
	public function test__applyTemplates() {
		
		var gen = function():Array<RequireTemplating> {
			var a = "<a></a>";
			var b = "<b></b>";
			var c = "<c></c>";
			var d = "<d dd='dd'><ddd dddd='dddd'/></d>";

			var nodeNames:Array<String> = "a,b,c,d".split(",");
			var isTemplates:Array<String> = "0,1,1,1".split(",");
			var needsNodes:Array<String> = "c,d---c------b".split("---");
			var xmls:Array<String> = [a, b, c, d];
			
			var r:Array<RequireTemplating> = [];
			
			for (i in 0...nodeNames.length) {
				var nodeName = nodeNames[i];
				var isTemplate = isTemplates[i] == "1";
				var templatesStr:String = needsNodes[i];
				var template:RequireTemplating = new RequireTemplating();
				template.name = nodeName;
				template.isTemplate = isTemplate;
				var templates:Array<String> = templatesStr.split(","); 
				if (templates.length == 1 && templates[0].length == 0) templates = [];
				template.templates = templates;
				template.xml = Xml.parse(xmls[i]);
				r.push(template);
			}
			return r;
		}
		
		var requireTemplatingList = gen();
		
		var getReq = function(nam:String):RequireTemplating {
			for (r in requireTemplatingList) {
				if (r.name == nam) return r;
			}
			return null;
		}
		
		var templates:Templates = new Templates(null);
		var templateMap:Map<String, RequireTemplating> = templates.__generateTemplatesMap(requireTemplatingList);
		
		var req:RequireTemplating = getReq("a");
		
		templates.__applyTemplates(req, templateMap, Templates.Trial_copyOverId);
		

		Assert.isTrue(req.xml.toString() == "<a dd=\"dd\"><ddd dddd=\"dddd\"/></a>");
	}
	
	
	
	public function test_templates() {
/*<exptA exptType="WEB">
<SETUP>  </SETUP>
<TRIAL template="cereal,template"  block="10" trials="25"></TRIAL>	
<cereal><image copyOverId="image" resource="cereal" /></cereal>	
<template order="random" trials="15"><image copyOverId="image"  /></template>
</exptA>*/

		var xml:Xml = Xml.parse("<exptA exptType='WEB'><TRIAL template='cereal,template'  block='10' trials='25'></TRIAL>	<cereal><image copyOverId='image' resource='cereal' /></cereal>	<template order='random' trials='15'><image copyOverId='image'  /></template></exptA>");
		var templates:Templates = new Templates(xml);
		Assert.isTrue(xml.firstElement().firstElement().firstElement().nodeName == "image") ;
		
	}
	

	
}