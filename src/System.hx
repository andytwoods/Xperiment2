package;

import haxe.macro.Context;
import haxe.macro.Expr;

class System {
	macro public static function init() {
		var code:String = "function() {\n";
		
		var file = findFilePath("system.xml", Context.getClassPath());
		if (file == null) {
			throw "Could not find system.xml";
		}
		
		var content:String = sys.io.File.getContent(file);
		var xml:Xml = Xml.parse(content);
		var systemNode:Xml = xml.firstElement();
		
		// init haxeui toolkit
		var toolkitNode:Xml = systemNode.elementsNamed("toolkit").next();
		var toolkitTheme:String = toolkitNode.get("theme");
		if (toolkitTheme != null) {
			code += "haxe.ui.toolkit.core.Toolkit.theme = '" + toolkitTheme + "';\n";
		}
		code += "haxe.ui.toolkit.core.Toolkit.setTransitionForClass(haxe.ui.toolkit.controls.popups.Popup, 'none');\n";
		code += "haxe.ui.toolkit.core.Toolkit.init();\n";
		
		var toolkitStylesNode:Xml = toolkitNode.elementsNamed("styles").next();
		for (node in toolkitStylesNode.elements()) {
			switch (node.nodeName) {
				case "asset":
					var resourceId:String = null;
					if (node.get("resource") != null) {
						resourceId = node.get("resource");
					}
					
					code += "haxe.ui.toolkit.core.Toolkit.addStyleSheet('" + resourceId + "');\n";
				default:
					trace("Unknown toolkit style type: " + node.nodeName);
			}
		}

		code += "var mainRoot = haxe.ui.toolkit.core.Toolkit.openFullscreen();\n";
		
		// setup debug
		if (systemNode.get("debug") != null && systemNode.get("debug") == "true") {
			code += "xpt.debug.DebugManager.instance.enabled = true;\n";
		}
		
		
		if (systemNode.elementsNamed("timing").hasNext()) {
			var timingNode:Xml = systemNode.elementsNamed("timing").next();
			var timingManager:String = timingNode.get("manager");
			if (timingManager != null) {
				code += "xpt.timing.TimingManagerFactory.managerClassAlias='" + timingManager + "';\n";
			}
		}
		
		// register stim classes
		var stimuliNode:Xml = systemNode.elementsNamed("stimuli").next();
		for (node in stimuliNode.elements()) {
			var stimName = node.nodeName;
			var stimBuilder = node.get("builder");
			code += "xpt.stimuli.StimuliFactory.registerStimBuilderClass('" + stimName + "', " + stimBuilder + ");\n";
			for (param in node.elements()) {
				var paramName:String = param.nodeName;
				var paramValue:String = param.firstChild().nodeValue;
				code += "xpt.stimuli.StimuliFactory.addStimParam('" + stimName + "', '" + paramName + "', '" + paramValue + "');\n";
			}
		}

		code += "}()\n";
		return Context.parseInlineString(code, Context.currentPos());
	}
	
	#if macro
	public static function findFilePath(file:String, paths:Array<String>):String {
		for (p in paths) {
			var f:String = p + "/" + file;
			if (sys.FileSystem.exists(f)) {
				return f;
			}
		}
		return null;
	}
	#end
}