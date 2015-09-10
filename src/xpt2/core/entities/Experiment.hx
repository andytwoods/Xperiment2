package xpt2.core.entities;

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
			if (trial.template != null) {
				var t:TrialTemplate = templates.get(trial.template);
				if (t != null) {
					if (trial.id == null && t.id != null)		trial.id = t.id;
					if (trial.type == null && t.type != null)	trial.type = t.type;
				} else {
					trace("WARNING! could not find template: " + trial.template);
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