package xpt2.core.entities;

class ExperimentSetup {
	private function new() {
		
	}
	
	public static function fromXML(xml:Xml):ExperimentSetup {
		var s:ExperimentSetup = new ExperimentSetup();
		return s;
	}
	
	public static function defaultSetup():ExperimentSetup {
		var s:ExperimentSetup = new ExperimentSetup();
		return s;
	}
}