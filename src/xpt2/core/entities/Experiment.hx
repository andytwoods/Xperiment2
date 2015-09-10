package xpt2.core.entities;
import xpt2.core.utils.ObjectUtils;

class Experiment {
	public var meta:ExperimentMetadata;
	public var setup:ExperimentSetup;
	public var templates:Map<String, TrialTemplate>;
	public var trials:Array<Trial>;
	
	private function new() {
		templates = new Map<String, TrialTemplate>();
		trials = new Array<Trial>();
	}
	
	private function applyTemplates() {
		for (trial in trials) {
			if (trial.templates != null) {
				var templateArray:Array<String> = trial.templates.split(",");
				for (template in templateArray) {
					template = StringTools.trim(template);
					var t:TrialTemplate = templates.get(template);
					if (t != null) {
						ObjectUtils.copyProperties(t, trial, ["templates", "stimuli"]);
						
						for (s in t.stimuli) {
							var currentStimulas = trial.findStimulasById(s.id);
							if (currentStimulas == null) {
								trial.stimuli.push(s.clone());
							} else {
								ObjectUtils.copyProperties(s, currentStimulas, ["children"]);
							}
						}
					} else {
						trace("WARNING! could not find template: " + template);
					}
				}
			}
		}
	}
	
	private function postProcess() {
		
	}
	
	private function validate() {
		if (trials.length == 0) {
			throw "No trials in experiment!";
		}
	}
	
	public function toString():String {
		var s:String = "";
		s += "meta: \n";
		s += "setup: \n";
		s += "trails: \n";
		for (t in trials) {
			s += t.toString();
		}
		s += "templates: \n";
		return s;
	}
	
	public static function fromXML(xml:Xml):Experiment {
		var e:Experiment = new Experiment();
		var experimentNode:Xml = xml.firstElement();
		if (experimentNode.nodeName != "experiment") {
			throw "Root node must be an experiment";
		}
		
		for (node in experimentNode.elements()) {
			switch (node.nodeName) {
				case "meta":
					e.meta = ExperimentMetadata.fromXML(node);
				case "setup":
					e.setup = ExperimentSetup.fromXML(node);
				case "trial":
					e.trials = e.trials.concat(Trial.multipleFromXML(node));
				default:
					var template:TrialTemplate = TrialTemplate.fromXML(node);
					if (template != null) {
						e.templates.set(template.templateId, template);
					}
			}
		}
		
		if (e.meta == null) {
			e.meta = ExperimentMetadata.defaultMetadata();
		}
		
		if (e.setup == null) {
			e.setup = ExperimentSetup.defaultSetup();
		}
		
		e.applyTemplates();
		e.postProcess();
		e.validate();
		
		return e;
	}
}