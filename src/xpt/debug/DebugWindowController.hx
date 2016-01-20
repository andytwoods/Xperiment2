package xpt.debug;

import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import openfl.events.KeyboardEvent;
import xpt.experiment.Experiment;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/debug-window.xml"))
class DebugWindowController extends XMLController {
	private var ICONS:Map<String, String> = [
		"INFO" => "img/icons/information-white.png",
		"STIMULUS" => "img/icons/ui-buttons.png",
		"ERROR" => "img/icons/exclamation-red.png",
		"WARNING" => "img/icons/exclamation.png",
		"PROGRESS" => "img/icons/ui-progress-bar.png",
		"SCRIPT" => "img/icons/script-code.png",
		"EVENT" => "img/icons/lightning.png",
	];
	
	public var experiment:Experiment;
	
	public function new(experiment:Experiment) {
		this.experiment = experiment;
		
		run.onClick = function(e) {
			runScript();
		}

		scriptText.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			if (e.keyCode == 13) {
				runScript();
			}
		});
	}

	private function runScript() {
		var scriptValue:String = scriptText.text;
		
		script("Running script", scriptValue);
		try {
			var parser = new hscript.Parser();
			var s:String = StringTools.trim(scriptValue);
			s = StringTools.replace(s, "|", ";");
			s = StringTools.replace(s, "\t", " ");
			s = StringTools.replace(s, "\r\n", ";\n");
			var expr = parser.parseString(s);
			experiment.scriptEngine.execute(expr);
		} catch (e:Dynamic) {
			error("Error running script", "" + e);
		}
		
		scriptText.text = "";
	}
	
	public function addItem(type:String, message:String, details:String = null) {
		var o = {
			text: message,
			icon: ICONS.get(type),
			subtext: details
		};
		log.dataSource.add(o);
		log.vscrollPos = log.vscrollMax;
	}
	
	public function info(message:String, details:String = null) {
		addItem("INFO", message, details);
	}
	
	public function error(message:String, details:String = null) {
		addItem("ERROR", message, details);
	}
	
	public function warning(message:String, details:String = null) {
		addItem("WARNING", message, details);
	}
	
	public function stimulus(message:String, details:String = null) {
		addItem("STIMULUS", message, details);
	}
	
	public function progress(message:String, details:String = null) {
		addItem("PROGRESS", message, details);
	}
	
	public function script(message:String, details:String = null) {
		addItem("SCRIPT", message, details);
	}
	
	public function event(message:String, details:String = null) {
		addItem("EVENT", message, details);
	}
}